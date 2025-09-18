import '../model/login_model.dart';

class LoginRepository {
  final LoginModel model;
  LoginRepository(this.model);

  Future usersignIn(String email, String password) => model.signIn(email, password);
  Future signOut() => model.signOut();
}
