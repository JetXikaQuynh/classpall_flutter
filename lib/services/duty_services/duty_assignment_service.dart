import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/duty_models/duty_assignment_model.dart';
import '../../utils/date_utils.dart';

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

  /// TỰ ĐỘNG MARK CÁC NHIỆM VỤ QUÁ HẠN LÀ LATE
  Future<void> autoMarkLateAssignments() async {
    final now = DateTime.now();
    final currentWeek = getCurrentWeekNumber();
    final currentYear = now.year;

    final snapshot = await _assignmentRef
        .where('status', whereIn: ['inprogress', 'pending_approval'])
        .get();

    for (final doc in snapshot.docs) {
      final assignment = DutyAssignmentModel.fromFirestore(doc);

      final isPastWeek =
          assignment.year < currentYear ||
          (assignment.year == currentYear &&
              assignment.weekNumber < currentWeek);

      if (isPastWeek) {
        await _assignmentRef.doc(assignment.id).update({'status': 'late'});
      }
    }
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

  /// LẮNG NGHE ASSIGNMENT THEO TỔ (realtime)
  Stream<List<DutyAssignmentModel>> watchAssignmentsByTeam(String teamKey) {
    return FirebaseFirestore.instance
        .collection('duty_assignments')
        .where('id_team', isEqualTo: teamKey) // teamKey = "team02"
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => DutyAssignmentModel.fromFirestore(doc))
              .toList(),
        );
  }
}
