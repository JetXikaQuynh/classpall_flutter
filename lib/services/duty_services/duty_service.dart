import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/duty_models/duty_model.dart';

class DutyService {
  final _dutyRef = FirebaseFirestore.instance.collection('duties');

  /// Lấy tất cả nhiệm vụ
  Future<List<DutyModel>> getAllDuties() async {
    final snapshot = await _dutyRef.get();
    return snapshot.docs.map((e) => DutyModel.fromFirestore(e)).toList();
  }

  /// Lấy 1 nhiệm vụ theo id
  Future<DutyModel?> getDutyById(String dutyId) async {
    final doc = await _dutyRef.doc(dutyId).get();
    if (!doc.exists) return null;
    return DutyModel.fromFirestore(doc);
  }

  /// Tạo nhiệm vụ mới
  Future<void> createDuty(DutyModel duty) async {
    await _dutyRef.add(duty.toMap());
  }

  /// Xóa nhiệm vụ
  Future<void> deleteDuty(String dutyId) async {
    await _dutyRef.doc(dutyId).delete();
  }
}
