import 'package:cloud_firestore/cloud_firestore.dart';

class EventRegistrationModel {
  final String id;
  final String userId;
  final String eventId;
  final String status;
  final DateTime registeredAt;
  final String note;

  EventRegistrationModel({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.status,
    required this.registeredAt,
    required this.note,
  });

  factory EventRegistrationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventRegistrationModel(
      id: doc.id,
      userId: data['user_id'],
      eventId: data['event_id'],
      status: data['status'],
      registeredAt: (data['registered_at'] as Timestamp).toDate(),
      note: data['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'event_id': eventId,
      'status': status,
      'registered_at': Timestamp.fromDate(registeredAt),
      'note': note,
    };
  }
}
