
abstract class SplashView {
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
     // view.navigateToHome();
    } else {
      //view.navigateToLogin();
    }
  }
}
