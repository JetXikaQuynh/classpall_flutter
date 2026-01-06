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
    final data = (doc.data() ?? {}) as Map<String, dynamic>;

    String _asString(dynamic v) => v == null ? '' : v.toString();
    bool _asBool(dynamic v) {
      if (v is bool) return v;
      if (v is num) return v != 0;
      if (v is String) {
        final lower = v.toLowerCase();
        return lower == 'true' || lower == '1' || lower == 'yes';
      }
      return false;
    }

    return UserModel(
      id: doc.id,
      fullName: _asString(data['fullname']),
      email: _asString(data['email']),
      phone: _asString(data['phone']),
      avatar: _asString(data['avatar']),
      className: _asString(data['classname']),
      teamId: _asString(data['id_team']),
      isLeader: _asBool(data['is_leader']),
      role: _asBool(data['role']),
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
