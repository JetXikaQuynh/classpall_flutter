import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type;
  final String? targetId;
  final bool isRead;
  final Timestamp sentAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.targetId,
    required this.isRead,
    required this.sentAt,
  });

  factory NotificationModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      title: data['title'],
      body: data['body'],
      type: data['type'],
      targetId: data['target_id'],
      isRead: data['is_read'] ?? false,
      sentAt: data['sent_at'],
    );
  }
}
