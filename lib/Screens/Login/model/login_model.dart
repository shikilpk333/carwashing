import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginModel {
  final FirebaseAuth _auth;
  
  LoginModel({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      // Input validation at model level
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password cannot be empty');
      }
      
      if (!_isValidEmail(email)) {
        throw Exception('Invalid email format');
      }

      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(), 
        password: password.trim()
      );
      
      final user = cred.user;
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', user.uid);
        await prefs.setBool('isLoggedIn', true);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      // Re-throw with proper context
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
      await prefs.setBool('isLoggedIn', false);
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email.trim());
  }

  Exception _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No account found with this email');
      case 'wrong-password':
        return Exception('Incorrect password');
      case 'invalid-email':
        return Exception('Invalid email address');
      case 'user-disabled':
        return Exception('This account has been disabled');
      case 'too-many-requests':
        return Exception('Too many attempts. Try again later');
      default:
        return Exception('Authentication failed: ${e.message}');
    }
  }
}
