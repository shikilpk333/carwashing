
import 'package:firebase_auth/firebase_auth.dart';
import '../repository/login_repository.dart';

abstract class LoginView {
  void showLoading();
  void hideLoading();
  void showError(String message);
  void navigateToHome(User user);
  void navigateToSignup();
}

class LoginPresenter {
  final LoginView view;
  final LoginRepository repository;

  LoginPresenter({required this.view, required this.repository});

  Future<void> signIn(String email, String password) async {
    if (email.isEmpty || !email.contains('@')) {
      view.showError('Please enter a valid email address');
      return;
    }
    if (password.isEmpty) {
      view.showError('Please enter your password');
      return;
    }

    try {
      view.showLoading();
      final user = await repository.usersignIn(email, password) as User?;
      if (user != null) {
        view.navigateToHome(user);
      } else {
        view.showError('Login failed');
      }
    } on FirebaseAuthException catch (e) {
      var msg = 'An error occurred.';
      if (e.code == 'user-not-found') msg = 'No user found for that email.';
      if (e.code == 'wrong-password') msg = 'Wrong password provided.';
      view.showError(msg);
    } catch (e) {
      view.showError('An unexpected error occurred: $e');
    } finally {
      view.hideLoading();
    }
  }

  void goToSignup() => view.navigateToSignup();
}
