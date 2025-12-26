import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventRegistrationService {
  EventRegistrationService._internal();

  static final EventRegistrationService instance =
      EventRegistrationService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  /// MEMBER – PHẢN HỒI SỰ KIỆN
 
  Future<void> respondEvent({
    required String eventId,
    required bool joined,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User chưa đăng nhập');
    }

    final registrationRef =
        _firestore.collection('event_registrations');

    // kiểm tra đã phản hồi chưa
    final existing = await registrationRef
        .where('event_id', isEqualTo: eventId)
        .where('user_id', isEqualTo: user.uid)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      // đã phản hồi → update
      await existing.docs.first.reference.update({
        'status': joined ? 'joined' : 'declined',
        'updated_at': FieldValue.serverTimestamp(),
      });
    } else {
      // chưa phản hồi → tạo mới
      await registrationRef.add({
        'event_id': eventId,
        'user_id': user.uid,
        'status': joined ? 'joined' : 'declined',
        'created_at': FieldValue.serverTimestamp(),
      });
    }

    // cập nhật tổng đăng ký nếu tham gia
    if (joined) {
      await _firestore.collection('events').doc(eventId).update({
        'total_registered': FieldValue.increment(1),
      });
    }
  }

  /// ADMIN – LẤY DS ĐĂNG KÝ

  Stream<QuerySnapshot> getRegistrationsByEvent(String eventId) {
    return _firestore
        .collection('event_registrations')
        .where('event_id', isEqualTo: eventId)
        .snapshots();
  }

  /// MEMBER – KIỂM TRA ĐÃ PHẢN HỒI
  Future<bool> hasUserResponded(String eventId) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final snap = await _firestore
        .collection('event_registrations')
        .where('event_id', isEqualTo: eventId)
        .where('user_id', isEqualTo: user.uid)
        .limit(1)
        .get();

    return snap.docs.isNotEmpty;
  }
}
