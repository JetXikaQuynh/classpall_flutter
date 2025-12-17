import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String avatar;
  final String className;
  final String teamId;
  final bool isLeader;
  final bool role; // true = admin | false = member

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.className,
    required this.teamId,
    required this.isLeader,
    required this.role,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      fullName: data['fullname'],
      email: data['email'],
      phone: data['phone'],
      avatar: data['avatar'],
      className: data['classname'],
      teamId: data['id_team'],
      isLeader: data['is_leader'],
      role: data['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullname': fullName,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'classname': className,
      'id_team': teamId,
      'is_leader': isLeader,
      'role': role,
    };
  }
}
