
import 'package:carwashbooking/Screens/AddressScreen/Model/addressmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class HomeView {
  void updateSelectedIndex(int index);
  void navigateToProfile(User user);
  void navigateToBooking();
    void showAddressForm(); // 👈 new
}

class HomePresenter {
  final HomeView view;
  int selectedIndex = 0;

  HomePresenter({required this.view});

  void onTabSelected(int index, User user) {
    selectedIndex = index;
    view.updateSelectedIndex(index);
    if (index == 2) view.navigateToProfile(user);
  }

 Future<void> onBookNow(User user) async {
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("addresses")
        .limit(1)
        .get();

    if (doc.docs.isNotEmpty) {
      // Address exists → go to booking
      view.navigateToBooking();
    } else {
      // No address → ask user to add one
      view.showAddressForm();
    }
  }

  Future<void> saveAddress(User user, AddressModel address) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("addresses")
        .doc(address.id)
        .set(address.toMap());

    view.navigateToBooking();
  }


  //void onBookNow() => view.navigateToBooking();
}
