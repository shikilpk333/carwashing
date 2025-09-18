
import 'package:firebase_auth/firebase_auth.dart';

import '../repository/signup_repository.dart';

abstract class SignupView {
  void showLoading();
  void hideLoading();
  void showError(String message);
  void showSuccessAndNavigateToLogin();
}

class SignupPresenter {
  final SignupView view;
  final SignupRepository repository;

  SignupPresenter({required this.view, required this.repository});

  Future<void> signUp(String name, String email, String password, String confirmPassword) async {
    if (name.isEmpty) {
      view.showError('Please enter your name');
      return;
    }
    if (!email.contains('@')) {
      view.showError('Please enter a valid email');
      return;
    }
    if (password.length < 6) {
      view.showError('Password must be at least 6 characters');
      return;
    }
    if (password != confirmPassword) {
      view.showError('Passwords do not match');
      return;
    }

    try {
      view.showLoading();
      final user = await repository.signUp(name, email, password);
      if (user != null) {
        view.showSuccessAndNavigateToLogin();
      } else {
        view.showError('Sign up failed');
      }
    } on FirebaseAuthException catch (e) {
      var msg = 'An error occurred.';
      if (e.code == 'weak-password') msg = 'The password provided is too weak.';
      if (e.code == 'email-already-in-use') msg = 'The account already exists for that email.';
      view.showError(msg);
    } catch (e) {
      view.showError('Unexpected error: $e');
    } finally {
      view.hideLoading();
    }
  }
}
