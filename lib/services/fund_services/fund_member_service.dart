import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/fund_models/fund_member_model.dart';
import '../../models/user_model.dart';

class FundMemberService {
  final _db = FirebaseFirestore.instance;
  final _memberRef =
  FirebaseFirestore.instance.collection('fund_members');

  /// Tạo fund_members cho 1 khoản thu (toàn bộ sinh viên)
  Future<void> createMembersForCollection({
    required String collectionId,
    required List<UserModel> users,
    required int amount,
  }) async {
    final batch = FirebaseFirestore.instance.batch();

    for (final user in users) {
      final doc = FirebaseFirestore.instance
          .collection('fund_members')
          .doc();

      batch.set(doc, {
        'collectionId': collectionId, // 🔥 BẮT BUỘC
        'userId': user.id,            // 🔥 ID THẬT (docId users)
        'userName': user.fullName,    // 🔥 KHÔNG ĐỂ RỖNG
        'amount': amount,
        'paid': false,
        'paidAt': null,
      });
    }
    await batch.commit();
  }

  /// Lấy danh sách sinh viên theo khoản thu
  Stream<List<FundMember>> getMembersByCollection(String collectionId) {
    return _memberRef
        .where('collectionId', isEqualTo: collectionId)
        .snapshots()
        .map(
          (snap) =>
          snap.docs.map((d) => FundMember.fromFirestore(d)).toList(),
    );
  }

  /// Lấy TẤT CẢ fund_members (dùng cho Tổng quan)
  Stream<List<FundMember>> getMembersByCollectionALL() {
    return _memberRef.snapshots().map(
          (snap) =>
          snap.docs.map((d) => FundMember.fromFirestore(d)).toList(),
    );
  }

  /// Xác nhận sinh viên đã nộp tiền
  Future<void> confirmPaid(String memberId) async {
    await _memberRef.doc(memberId).update({
      'paid': true,
      'paidAt': Timestamp.now(),
    });
  }

  Future<void> markAsPaid(String memberId) async {
    await _db
        .collection('fund_members')
        .doc(memberId)
        .update({'paid': true});
  }

  Stream<List<FundMember>> getAllMembers() {
    return _db
        .collection('fund_members')
        .snapshots()
        .map(
          (snap) => snap.docs
          .map((d) => FundMember.fromFirestore(d))
          .toList(),
    );
  }
}
