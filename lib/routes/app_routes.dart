
import 'package:carwashbooking/Screens/Splash/view/splash_screen.dart';
import 'package:flutter/material.dart';
import '../Screens/Login/view/login_screen.dart';
import '../Screens/Signup/view/signup_screen.dart';
import '../Screens/Home/view/home_screen.dart';
import '../Screens/Profile/view/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      signup: (context) => const SignupScreen(),
      home: (context) {
        // For named routes, expect user to be passed as argument
        final user = ModalRoute.of(context)?.settings.arguments as User?;
        if (user == null) {
          // Redirect to login if no user
          Future.microtask(() {
            Navigator.of(context).pushReplacementNamed(login);
          });
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return HomeScreen(user: user);
      },
      profile: (context) {
        final user = ModalRoute.of(context)?.settings.arguments as User?;
        if (user == null) {
          Future.microtask(() {
            Navigator.of(context).pushReplacementNamed(login);
          });
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return ProfileScreen(user: user);
      },
    };
  }

  // Helper method for navigation with user
  static void navigateToHome(BuildContext context, User user) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(user: user),
      ),
    );
  }

  static void navigateToProfile(BuildContext context, User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(user: user),
      ),
    );
  }
}
