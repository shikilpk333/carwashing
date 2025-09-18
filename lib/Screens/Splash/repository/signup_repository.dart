import '../model/splash_model.dart';

class SplashRepository {
  final SplashModel model;
  SplashRepository(this.model);

  Future<bool> isLoggedIn() async {
    final user = await model.getLoggedInUserIfSaved();
    return user != null;
  }
}
