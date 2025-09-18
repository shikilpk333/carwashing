
import 'package:firebase_auth/firebase_auth.dart';

abstract class HomeView {
  void updateSelectedIndex(int index);
  void navigateToProfile(User user);
  void navigateToBooking();
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

  void onBookNow() => view.navigateToBooking();
}
