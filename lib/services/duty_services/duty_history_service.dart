import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/duty_models/duty_history_model.dart';

class DutyHistoryService {
  final _historyRef = FirebaseFirestore.instance.collection('duty_history');

  /// Thêm lịch sử sau khi admin xác nhận hoàn thành
  Future<void> addHistory(DutyHistoryModel history) async {
    await _historyRef.add(history.toMap());
  }

  /// Lấy lịch sử theo team
  Future<List<DutyHistoryModel>> getHistoryByTeam(String teamId) async {
    final snapshot = await _historyRef
        .where('id_team', isEqualTo: teamId)
        .get();

    return snapshot.docs.map((e) => DutyHistoryModel.fromFirestore(e)).toList();
  }

  /// Lấy lịch sử theo tháng + năm
  Future<List<DutyHistoryModel>> getHistoryByMonth(int month, int year) async {
    final snapshot = await _historyRef
        .where('month', isEqualTo: month)
        .where('year', isEqualTo: year)
        .get();

    return snapshot.docs.map((e) => DutyHistoryModel.fromFirestore(e)).toList();
  }
}
