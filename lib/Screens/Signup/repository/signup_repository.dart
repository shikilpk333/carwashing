import '../model/signup_model.dart';

class SignupRepository {
  final SignupModel model;
  SignupRepository(this.model);

  Future signUp(String name, String email, String password) => model.signUp(name, email, password);
}
