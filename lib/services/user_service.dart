import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final _userRef = FirebaseFirestore.instance.collection('users');

  /// Lấy tất cả user
  Future<List<UserModel>> getAllUsers() async {
    final snapshot = await _userRef.get();
    return snapshot.docs.map((e) => UserModel.fromFirestore(e)).toList();
  }

  /// Cập nhật thông tin user
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _userRef.doc(userId).update(data);
  }

  /// Lấy user theo id
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _userRef.doc(userId).get();
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    } catch (e, st) {
      // ignore: avoid_print
      print('Error in UserService.getUserById for id=$userId: $e\n$st');
      return null;
    }
  }

  /// Lấy user theo team
  Future<List<UserModel>> getUsersByTeam(String teamId) async {
    final snapshot = await _userRef.where('id_team', isEqualTo: teamId).get();

    return snapshot.docs.map((e) => UserModel.fromFirestore(e)).toList();
  }

  /// Cập nhật team cho user
  Future<void> updateUserTeam(String userId, String teamId) async {
    await _userRef.doc(userId).update({'id_team': teamId});
  }

  /// Set user làm tổ trưởng
  Future<void> setLeader(String userId, bool isLeader) async {
    await _userRef.doc(userId).update({'is_leader': isLeader});
  }

  /// Set user role (admin / member)
  Future<void> setRole(String userId, bool isAdmin) async {
    await _userRef.doc(userId).update({'role': isAdmin});
  }

  Stream<List<UserModel>> streamAllUsers() {
    return _userRef.snapshots().map(
      (snap) => snap.docs.map((d) => UserModel.fromFirestore(d)).toList(),
    );
  }
}
