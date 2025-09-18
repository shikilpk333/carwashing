import 'package:flutter/material.dart';
import '../Screens/Splash/view/splash_screen.dart';
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
      // home/profile require user param — we still include named routes for convenience but prefer navigator with args
      home: (context) {
        final user = ModalRoute.of(context)!.settings.arguments as User?;
        if (user == null) return const LoginScreen();
        return HomeScreen(user: user);
      },
      profile: (context) {
        final user = ModalRoute.of(context)!.settings.arguments as User?;
        if (user == null) return const LoginScreen();
        return ProfileScreen(user: user);
      },
    };
  }
}
