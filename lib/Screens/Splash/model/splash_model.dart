
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashModel {
  Future<User?> getLoggedInUserIfSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && prefs.containsKey('userId')) {
      return user;
    }
    return null;
  }
}
