import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _db = FirebaseFirestore.instance;

  /// GỬI THÔNG BÁO
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
    required String type,
    String? targetId,
  }) async {
    await _db.collection('notifications').add({
      'user_id': userId,
      'title': title,
      'body': body,
      'type': type,
      'target_id': targetId,
      'is_read': false,

      'sent_at': Timestamp.now(),
    });
  }

  /// LIST REALTIME
  Stream<QuerySnapshot> listenMyNotifications(String uid) {
    return _db
        .collection('notifications')
        .where('user_id', isEqualTo: uid)
        .snapshots();
  }

  ///New event
  Future<void> notifyNewEvent({
    required String eventId,
    required String eventTitle,
  }) async {
    final users = await _db.collection('users').get();

    for (final user in users.docs) {
      await _db.collection('notifications').add({
        'user_id': user.id,
        'title': 'Sự kiện mới',
        'body': 'Có sự kiện mới: $eventTitle',
        'type': 'event',
        'target_id': eventId,
        'is_read': false,
        'sent_at': Timestamp.now(),
      });
    }
  }

  /// Gửi thông báo cho cả tổ khi có nhiệm vụ mới
  Future<void> notifyNewDutyByTeam({
    required String dutyId,
    required String dutyTitle,
    required List<String> memberIds,
    required String teamName,
  }) async {
    final batch = _db.batch();

    for (final uid in memberIds) {
      final notifRef = _db.collection('notifications').doc();
      batch.set(notifRef, {
        'user_id': uid,
        'title': 'Nhiệm vụ mới cho $teamName',
        'body': 'Tổ của bạn có nhiệm vụ mới: $dutyTitle',
        'type': 'duty',
        'target_id': dutyId,
        'is_read': false,
        'sent_at': Timestamp.now(),
      });
    }

    await batch.commit();
  }

  /// MARK READ
  Future<void> markAsRead(String notifId) async {
    await _db.collection('notifications').doc(notifId).update({
      'is_read': true,
    });
  }
}
