import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String? fullName;
  final String? email;
  final String? address;
  final DateTime? updatedAt;

  UserModel({
    required this.uid,
    this.fullName,
    this.email,
    this.address,
    this.updatedAt
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      fullName: data['fullName'],
      email: data['email'],
      address: data['address'],
      updatedAt: data['updatedAt'] != null ? 
          (data['updatedAt'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'address': address,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  UserModel copyWith({
    String? fullName,
    String? email,
    String? address,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      address: address ?? this.address,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, fullName: $fullName, email: $email, address: $address, createdAt: $updatedAt)';
  }
}