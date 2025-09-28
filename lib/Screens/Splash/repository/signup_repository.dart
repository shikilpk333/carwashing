import 'package:firebase_auth/firebase_auth.dart';
import '../model/splash_model.dart';

class SplashRepository {
  final SplashModel _model;

  SplashRepository(this._model);

  Future<bool> isLoggedIn() async {
    try {
      final user = await _model.getLoggedInUserIfSaved();
      return user != null;
    } catch (e) {
      throw Exception('Login check failed: $e');
    }
  }

  Future<User?> getCurrentUser() async {
    return await _model.getLoggedInUserIfSaved();
  }
}


/*
class SplashRepository {
  final SplashModel model;
  SplashRepository(this.model);

  Future<bool> isLoggedIn() async {
    final user = await model.getLoggedInUserIfSaved();
    return user != null;
  }
}
*/