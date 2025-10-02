import 'package:carwashbooking/Screens/BookingSlotScreen/view/slot_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Profile/view/profile_screen.dart';
import '../presenter/home_presenter.dart';
import '../model/home_model.dart';

import 'dart:ui';

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
                // height: 280,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://images.unsplash.com/photo-1502877338535-766e1452684a",
                    ),
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
                      onPressed: presenter.onBookNow,
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
      backgroundColor: const Color(0xFF121B2C),
      //const Color(0xFF0A0F1C),
      appBar: AppBar(
        backgroundColor:  const Color(0xFF0A0F1C),
        title: const Text(
          "Car Wash Booking",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        
        elevation: 1,
      ),
      body: Center(child: _homeCard()),
      bottomNavigationBar: BottomNavigationBar(
  backgroundColor: const Color(0xFF0A0F1C), // dark bg
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
  selectedItemColor: Colors.white,       // active tab white
  unselectedItemColor: Colors.grey[500], // inactive tabs grey
  onTap: (i) => presenter.onTabSelected(i, model.user),
),

      
      
      
      /* BottomNavigationBar(
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
      ),*/
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
*/