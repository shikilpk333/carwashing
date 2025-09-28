

import 'package:firebase_auth/firebase_auth.dart';
import '../repository/login_repository.dart';

abstract class LoginView {
  void showLoading();
  void hideLoading();
  void showError(String message);
  void navigateToHome(User user);
  void navigateToSignup();
  void clearPasswordField();
}

class LoginPresenter {
  final LoginView _view;
  final LoginRepository _repository;
  bool _isDisposed = false;

  LoginPresenter({required LoginView view, required LoginRepository repository})
      : _view = view,
        _repository = repository;

  Future<void> signIn(String email, String password) async {
    if (_isDisposed) return;

    // Enhanced validation
    if (!_validateInput(email, password)) return;

    try {
      _view.showLoading();
      
      final user = await _repository.userSignIn(email, password);
      
      if (_isDisposed) return;

      if (user != null) {
        _view.navigateToHome(user);
      } else {
        _view.showError('Login failed - no user returned');
        _view.clearPasswordField();
      }
    } catch (e) {
      if (!_isDisposed) {
        _view.showError(e.toString().replaceFirst('Exception: ', ''));
        _view.clearPasswordField();
      }
    } finally {
      if (!_isDisposed) {
        _view.hideLoading();
      }
    }
  }

  bool _validateInput(String email, String password) {
    if (email.isEmpty) {
      _view.showError('Please enter your email address');
      return false;
    }
    
    if (!email.contains('@') || !email.contains('.')) {
      _view.showError('Please enter a valid email address');
      return false;
    }
    
    if (password.isEmpty) {
      _view.showError('Please enter your password');
      return false;
    }
    
    if (password.length < 6) {
      _view.showError('Password must be at least 6 characters');
      return false;
    }
    
    return true;
  }

  void goToSignup() {
    if (!_isDisposed) {
      _view.navigateToSignup();
    }
  }

  void dispose() {
    _isDisposed = true;
  }
}

/*import 'package:firebase_auth/firebase_auth.dart';
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
*/