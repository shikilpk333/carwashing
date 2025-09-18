import 'package:carwashbooking/Screens/Splash/model/splash_model.dart';
import 'package:carwashbooking/Screens/Splash/presenter/splash_presenter.dart';
import 'package:carwashbooking/Screens/Splash/repository/signup_repository.dart';
import 'package:flutter/material.dart';
import '../../Login/view/login_screen.dart';
import '../../Home/view/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> implements SplashView {
  late SplashPresenter presenter;

  @override
  void initState() {
    super.initState();
    presenter = SplashPresenter(
      view: this,
      repository: SplashRepository(SplashModel()),
    );

    Future.delayed(const Duration(seconds: 2), () {
      presenter.checkAuthAndNavigate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.local_car_wash, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              "AquaClean",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Sparkling clean, effortlessly booked.",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 40),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void navigateToHome() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
      );
    } else {
      navigateToLogin(); // fallback
    }
  }

  @override
  void navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
}
