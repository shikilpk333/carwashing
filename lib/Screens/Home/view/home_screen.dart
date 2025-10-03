import 'package:carwashbooking/Screens/AddressScreen/Model/addressmodel.dart';
import 'package:carwashbooking/Screens/BookingSlotScreen/view/slot_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Profile/view/profile_screen.dart';
import '../presenter/home_presenter.dart';
import '../model/home_model.dart';



/*
class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> implements HomeView {
  late HomePresenter presenter;
  late HomeModel model;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    model = HomeModel(widget.user);
    presenter = HomePresenter(view: this);
  }

  @override
  void updateSelectedIndex(int index) {
    setState(() {});
    _pageController.jumpToPage(index); // 👈 sync tab with page
  }

  @override
  void navigateToBooking() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SlotBookingScreen()),
    );
  }

  @override
  void navigateToProfile(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProfileScreen(user: user)),
    ).then((_) {
      presenter.onTabSelected(0, user);
    });
  }

  @override
  void showAddressForm() {
    final addressController = TextEditingController();
    final phoneController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final postalController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Enter Address"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: addressController, decoration: const InputDecoration(labelText: "Address")),
                TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone")),
                TextField(controller: cityController, decoration: const InputDecoration(labelText: "City")),
                TextField(controller: stateController, decoration: const InputDecoration(labelText: "State")),
                TextField(controller: postalController, decoration: const InputDecoration(labelText: "Postal Code")),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                final newAddress = AddressModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  address: addressController.text,
                  phone: phoneController.text,
                  city: cityController.text,
                  state: stateController.text,
                  postalCode: postalController.text,
                );
                presenter.saveAddress(model.user, newAddress);
                Navigator.pop(ctx);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.8,
        centerTitle: true,
        title: const Text(
          "Car Wash Booking",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF121B2C),
      ),
      backgroundColor: const Color(0xFF121B2C),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => presenter.selectedIndex = index),
        children: [
          _homeCard(),                          // index 0 → Home
          MyBookingsScreen(user: model.user),   // index 1 → My Bookings
          ProfileScreen(user: model.user),      // index 2 → Profile
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0A0F1C),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: "My bookings"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
        currentIndex: presenter.selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: (i) => presenter.onTabSelected(i, model.user),
      ),
    );
  }

  Widget _homeCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/back.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 280,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your Car, Sparkling Clean!",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Schedule your next premium car wash with ease. Select your preferred date, time, and service package.",
                    style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => presenter.onBookNow(model.user),
                      icon: const Icon(Icons.local_car_wash, color: Colors.white),
                      label: const Text(
                        "Book Now",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class MyBookingsScreen extends StatelessWidget {
  final User user;
  const MyBookingsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "My Bookings for ${user.email}",
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
*/





class MyBookingsScreen extends StatelessWidget {
  final User user;
  const MyBookingsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "My Bookings for ${user.email}",
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> implements HomeView {
  late HomePresenter presenter;
  late HomeModel model;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    model = HomeModel(widget.user);
    presenter = HomePresenter(view: this);
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void updateSelectedIndex(int index) {
    setState(() {
      presenter.selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void navigateToBooking() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SlotBookingScreen()),
    );
  }

  @override
  void navigateToProfile(User user) {
    // now Profile is inside PageView, no navigation needed
    updateSelectedIndex(2);
  }

  @override
  void showAddressForm() {
    final addressController = TextEditingController();
    final phoneController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final postalController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Enter Address"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: addressController, decoration: const InputDecoration(labelText: "Address")),
                TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone")),
                TextField(controller: cityController, decoration: const InputDecoration(labelText: "City")),
                TextField(controller: stateController, decoration: const InputDecoration(labelText: "State")),
                TextField(controller: postalController, decoration: const InputDecoration(labelText: "Postal Code")),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                final newAddress = AddressModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  address: addressController.text,
                  phone: phoneController.text,
                  city: cityController.text,
                  state: stateController.text,
                  postalCode: postalController.text,
                );
                presenter.saveAddress(model.user, newAddress);
                Navigator.pop(ctx);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.8,
        centerTitle: true,
        title: Text(
          "Car Wash Booking",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF121B2C),
      ),
      backgroundColor: const Color(0xFF121B2C),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            presenter.selectedIndex = index;
          });
        },
        children: [
          _homeCard(), // Home page
          MyBookingsScreen(user: model.user,), // My Bookings page
          ProfileScreen(user: model.user), // Profile page
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0A0F1C),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: "My bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
        currentIndex: presenter.selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: (i) => updateSelectedIndex(i),
      ),
    );
  }

  Widget _homeCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/back.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your Car, Sparkling Clean!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Schedule your next premium car wash with ease. "
                    "Select your preferred date, time, and service package.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => presenter.onBookNow(model.user),
                      icon: const Icon(
                        Icons.local_car_wash,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Book Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}






/*
class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> implements HomeView {
  late HomePresenter presenter;
  late HomeModel model;

  @override
  void initState() {
    super.initState();
    model = HomeModel(widget.user);
    presenter = HomePresenter(view: this);
  }

  @override
  void updateSelectedIndex(int index) => setState(() {});

  @override
  void navigateToBooking() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SlotBookingScreen()),
    );
  }

  @override
  void navigateToProfile(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProfileScreen(user: user)),
    ).then((_) {
      presenter.onTabSelected(0, user);
    });
  }

  @override
void showAddressForm() {
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalController = TextEditingController();

  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text("Enter Address"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: addressController, decoration: const InputDecoration(labelText: "Address")),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone")),
              TextField(controller: cityController, decoration: const InputDecoration(labelText: "City")),
              TextField(controller: stateController, decoration: const InputDecoration(labelText: "State")),
              TextField(controller: postalController, decoration: const InputDecoration(labelText: "Postal Code")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final newAddress = AddressModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                address: addressController.text,
                phone: phoneController.text,
                city: cityController.text,
                state: stateController.text,
                postalCode: postalController.text,
              );
              presenter.saveAddress(model.user, newAddress);
              Navigator.pop(ctx);
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.8,
        centerTitle : true,
        title: Text(
          "Car Wash Booking",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor:const Color(0xFF121B2C),
      ),
      backgroundColor: const Color(0xFF121B2C),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Center(child: _homeCard())),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0A0F1C),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: "My bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
        currentIndex: presenter.selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: (i) => presenter.onTabSelected(i, model.user),
      ),
    );
  }

  Widget _homeCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background image
            Expanded(
              child: Container(
                height: double.infinity,
                // height: 280,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/back.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Glass overlay
            Container(
              height: 280,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your Car, Sparkling Clean!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Schedule your next premium car wash with ease. "
                    "Select your preferred date, time, and service package.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                       onPressed: () => presenter.onBookNow(model.user),
                      icon: const Icon(
                        Icons.local_car_wash,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Book Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

*/