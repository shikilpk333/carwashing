import 'package:shared_preferences/shared_preferences.dart';

import '../model/login_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginRepository {
  final LoginModel _model;

  LoginRepository(this._model);

  Future<User?> userSignIn(String email, String password) async {
    try {
      return await _model.signIn(email, password);
    } catch (e) {
      // Re-throw with repository context
      throw Exception('Repository: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _model.signOut();
    } catch (e) {
      throw Exception('Repository sign out failed: $e');
    }
  }

  // Additional repository methods for future use
  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}


/*import '../model/login_model.dart';

class LoginRepository {
  final LoginModel model;
  LoginRepository(this.model);

  Future usersignIn(String email, String password) => model.signIn(email, password);
  Future signOut() => model.signOut();
}



*/