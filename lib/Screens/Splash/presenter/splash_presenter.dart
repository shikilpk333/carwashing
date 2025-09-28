import 'package:carwashbooking/Screens/Splash/repository/signup_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class SplashView {
  void navigateToHome(User user);
  void navigateToLogin();
  void showError(String message);
}

class SplashPresenter {
  final SplashView _view;
  final SplashRepository _repository;
  bool _isDisposed = false;

  SplashPresenter({required SplashView view, required SplashRepository repository})
      : _view = view,
        _repository = repository;

  Future<void> checkAuthAndNavigate() async {
    if (_isDisposed) return;

    try {
      final isLoggedIn = await _repository.isLoggedIn();
      
      if (_isDisposed) return;

      if (isLoggedIn) {
        final user = await _repository.getCurrentUser();
        if (user != null && !_isDisposed) {
          _view.navigateToHome(user);
        } else {
          _view.navigateToLogin();
        }
      } else {
        _view.navigateToLogin();
      }
    } catch (e) {
      if (!_isDisposed) {
        _view.showError('Authentication check failed');
        // Fallback to login screen
        _view.navigateToLogin();
      }
    }
  }

  void dispose() {
    _isDisposed = true;
  }
}


/*abstract class SplashView {
  void navigateToHome();
  void navigateToLogin();
}

class SplashPresenter {
  final SplashView view;
  final dynamic repository;

  SplashPresenter({required this.view, required this.repository});

  Future<void> checkAuthAndNavigate() async {
    final loggedIn = await repository.isLoggedIn();
    if (loggedIn) {
      view.navigateToHome();
    } else {
      view.navigateToLogin();
    }
  }
}
*/