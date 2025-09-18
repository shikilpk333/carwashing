import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_model.dart';

class ProfileRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ProfileRepository({required this.firestore, required this.auth});

  Future<UserModel?> fetchUserData(String uid) async {
    try {
      print('🔄 Fetching user data for UID: $uid');
      final doc = await firestore.collection('users').doc(uid).get();
      
      print('📄 Document exists: ${doc.exists}');
      if (doc.exists) {
        print('📊 Document data: ${doc.data()}');
        if (doc.data() != null) {
          final user = UserModel.fromMap(doc.data()!);
          print('✅ User loaded: $user');
          return user;
        }
      } else {
        print('❌ No document found for UID: $uid');
      }
      return null;
    } catch (e) {
      print('❌ Error fetching user data: $e');
      rethrow;
    }
  }

  Future<void> createUserIfNotExist(User user) async {
    try {
      print('🔄 Ensuring user document exists for UID: ${user.uid}');
      final docRef = firestore.collection('users').doc(user.uid);
      final doc = await docRef.get();
      
      if (!doc.exists) {
        print('➕ Creating new user document');
        final userData = {
          'uid': user.uid,
          'email': user.email,
          'fullName': user.displayName ?? 'User',
          'phoneNumber': user.phoneNumber ?? '',
          'photoURL': user.photoURL,
          'address': '123 Main St, Anytown, CA 90210',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        };
        
        await docRef.set(userData);
        print('✅ User document created: $userData');
      } else {
        print('✅ User document already exists');
        print('📊 Existing document data: ${doc.data()}');
      }
    } catch (e) {
      print('❌ Error creating user document: $e');
      rethrow;
    }
  }

  Future<void> updateAddress(String uid, String address) async {
    try {
      print('🔄 Updating address for UID: $uid');
      await firestore.collection('users').doc(uid).update({
        'address': address, 
        'updatedAt': FieldValue.serverTimestamp()
      });
      print('✅ Address updated successfully');
    } catch (e) {
      print('❌ Error updating address: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      print('🔄 Logging out user');
      await auth.signOut();
      print('✅ User logged out successfully');
    } catch (e) {
      print('❌ Error during logout: $e');
      rethrow;
    }
  }
}