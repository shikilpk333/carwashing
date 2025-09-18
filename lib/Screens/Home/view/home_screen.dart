import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Profile/view/profile_screen.dart';
import '../../BookingSlotScreen.dart'; // your existing booking screen path or adjust
import '../presenter/home_presenter.dart';
import '../model/home_model.dart';

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
    print("user in home screen: ${widget.user.uid}");
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
      presenter.onTabSelected(0, user); // reset to home after returning
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Car Wash Booking",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Center(child: _homeCard()),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
        currentIndex: presenter.selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: (i) => presenter.onTabSelected(i, model.user),
      ),
    );
  }

  Widget _homeCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: NetworkImage(
              "https://images.unsplash.com/photo-1502877338535-766e1452684a",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Your Car, Sparkling Clean!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Schedule your next premium car wash with ease. Select your preferred date, time, and service package.",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: presenter.onBookNow,
                icon: const Icon(Icons.local_car_wash,color: Colors.white,),
                label: const Text("Book Now",style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
