import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/duty_models/duty_assignment_model.dart';

class DutyAssignmentService {
  final _assignmentRef = FirebaseFirestore.instance.collection(
    'duty_assignments',
  );

  /// Lấy nhiệm vụ theo tuần + năm
  Future<List<DutyAssignmentModel>> getAssignmentsByWeek(
    int week,
    int year,
  ) async {
    final snapshot = await _assignmentRef
        .where('week_number', isEqualTo: week)
        .where('year', isEqualTo: year)
        .get();

    return snapshot.docs
        .map((e) => DutyAssignmentModel.fromFirestore(e))
        .toList();
  }

  /// Lấy nhiệm vụ của 1 team
  Future<List<DutyAssignmentModel>> getAssignmentsByTeam(String teamId) async {
    final snapshot = await _assignmentRef
        .where('id_team', isEqualTo: teamId)
        .get();

    return snapshot.docs
        .map((e) => DutyAssignmentModel.fromFirestore(e))
        .toList();
  }

  /// Cập nhật trạng thái nhiệm vụ
  Future<void> updateStatus(String assignmentId, String status) async {
    await _assignmentRef.doc(assignmentId).update({'status': status});
  }

  /// Tạo assignment mới
  Future<void> createAssignment(DutyAssignmentModel assignment) async {
    await _assignmentRef.add(assignment.toMap());
  }

  /// Lấy assignment theo id
  Future<DutyAssignmentModel?> getAssignmentById(String id) async {
    final doc = await _assignmentRef.doc(id).get();
    if (!doc.exists) return null;
    return DutyAssignmentModel.fromFirestore(doc);
  }

  /// Lấy tất cả assignment
  Future<List<DutyAssignmentModel>> getAllAssignments() async {
    final snapshot = await _assignmentRef.get();

    return snapshot.docs
        .map((e) => DutyAssignmentModel.fromFirestore(e))
        .toList();
  }

  /// LẮNG NGHE THAY ĐỔI TRONG COLLECTION
  Stream<List<DutyAssignmentModel>> watchAssignments() {
    return _assignmentRef.snapshots().map(
      (snapshot) => snapshot.docs
          .map((e) => DutyAssignmentModel.fromFirestore(e))
          .toList(),
    );
  }
}
