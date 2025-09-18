
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
    final user = cred.user;
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', user.uid);
    }
    return user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
  }
}
