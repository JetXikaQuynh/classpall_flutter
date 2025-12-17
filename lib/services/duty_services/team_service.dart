import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/duty_models/team_model.dart';

class TeamService {
  final _teamRef = FirebaseFirestore.instance.collection('teams');

  /// Lấy tất cả tổ
  Future<List<TeamModel>> getAllTeams() async {
    final snapshot = await _teamRef.get();
    return snapshot.docs.map((e) => TeamModel.fromFirestore(e)).toList();
  }

  /// Lấy tổ theo id
  Future<TeamModel?> getTeamById(String teamId) async {
    final doc = await _teamRef.doc(teamId).get();
    if (!doc.exists) return null;
    return TeamModel.fromFirestore(doc);
  }

  /// Cập nhật tổ trưởng
  Future<void> updateLeader(String teamId, String leaderId) async {
    await _teamRef.doc(teamId).update({'id_leader': leaderId});
  }

  /// Thêm thành viên vào tổ
  Future<void> addUserToTeam(String teamId, String userId) async {
    await _teamRef.doc(teamId).update({
      'id_user': FieldValue.arrayUnion([userId]),
    });
  }

  /// Xóa tổ
  Future<void> deleteTeam(String teamId) async {
    await _teamRef.doc(teamId).delete();
  }
}
