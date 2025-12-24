import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String? id; 
  final String title;
  final String description;
  final String location;
  final DateTime eventDate;
  final bool isMandatory;
  final String status;
  final int totalRegistered;
  final int totalClass;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventModel({
    this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.eventDate,
    required this.isMandatory,
    required this.status,
    required this.totalRegistered,
    required this.totalClass,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 🔹 Ghi lên Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'event_date': Timestamp.fromDate(eventDate),
      'is_mandatory': isMandatory,
      'status': status,
      'total_registered': totalRegistered,
      'total_class': totalClass,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }

  /// 🔹 Đọc từ Firestore
  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return EventModel(
      id: doc.id, 
      title: data['title'],
      description: data['description'],
      location: data['location'],
      eventDate: (data['event_date'] as Timestamp).toDate(),
      isMandatory: data['is_mandatory'],
      status: data['status'],
      totalRegistered: data['total_registered'],
      totalClass: data['total_class'],
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }
}
