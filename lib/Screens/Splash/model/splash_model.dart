
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashModel {
  final FirebaseAuth _auth;
  
  SplashModel({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  Future<User?> getLoggedInUserIfSaved() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final user = _auth.currentUser;
      
      // Check if user exists and we have stored preference
      if (user != null) {
        await user.reload(); // Refresh token status
        final currentUser = _auth.currentUser;
        if (currentUser != null && prefs.containsKey('userId')) {
          return currentUser;
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to check user authentication: $e');
    }
  }
}
