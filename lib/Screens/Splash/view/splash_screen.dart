import 'package:carwashbooking/Screens/Splash/model/splash_model.dart';
import 'package:carwashbooking/Screens/Splash/presenter/splash_presenter.dart';
import 'package:carwashbooking/Screens/Splash/repository/signup_repository.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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

    Future.delayed(const Duration(seconds: 10), () {
      presenter.checkAuthAndNavigate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/splash.jpeg', fit: BoxFit.cover),
          Center(
            child:  Column(
              children: [
                SizedBox(height: 200),
                Lottie.asset(
                  'assets/animation/Simpleloading.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                Center(child: Text('AquaClean', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white))),
              ],
            ),
         
          ),
        ],
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
