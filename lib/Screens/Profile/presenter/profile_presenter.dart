
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_model.dart';
import '../repository/profile_repository.dart';

abstract class ProfileView {
  void showLoading();
  void hideLoading();
  void showUser(UserModel user);
  void showError(String message);
  void onAddressUpdated(String address);
  void onLogout();
}

class ProfilePresenter {
  final ProfileRepository repository;
  ProfileView? _view;

  ProfilePresenter({required this.repository});

  void attachView(ProfileView view) => _view = view;
  void detachView() => _view = null;

  Future<void> loadUser(String uid) async {
    _view?.showLoading();
    try {
      print('👤 Loading user with UID: $uid');
      final user = await repository.fetchUserData(uid);
      if (user != null) {
        print('✅ User loaded successfully: $user');
        _view?.showUser(user);
      } else {
        print('❌ User not found in Firestore');
        _view?.showError('User not found');
      }
    } catch (e) {
      print('❌ Error loading user: $e');
      _view?.showError('Failed to load user: $e');
    } finally {
      _view?.hideLoading();
    }
  }

  Future<void> ensureUserDocumentExists(User firebaseUser) async {
    try {
      print('🔍 Ensuring document exists for user: ${firebaseUser.uid}');
      await repository.createUserIfNotExist(firebaseUser);
      print('✅ User document ensured successfully');
    } catch (e) {
      print('❌ Error ensuring user document: $e');
      _view?.showError('Failed to create user doc: $e');
    }
  }

  Future<void> updateAddress(String uid, String address) async {
    try {
      print('📍 Updating address for user: $uid');
      await repository.updateAddress(uid, address);
      _view?.onAddressUpdated(address);
      print('✅ Address update completed');
    } catch (e) {
      print('❌ Error updating address: $e');
      _view?.showError('Failed to update address: $e');
    }
  }

  Future<void> logout() async {
    try {
      print('🚪 Logging out');
      await repository.logout();
      _view?.onLogout();
      print('✅ Logout completed');
    } catch (e) {
      print('❌ Error during logout: $e');
      _view?.showError('Logout failed: $e');
    }
  }
}