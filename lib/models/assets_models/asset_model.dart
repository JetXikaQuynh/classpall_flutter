import 'package:cloud_firestore/cloud_firestore.dart';

class Asset {
  final String id;
  final String name;
  final String status; // available | borrowed
  final String? borrowedById;
  final String? borrowedByName;
  final DateTime? borrowedAt;
  final DateTime createdAt;

  Asset({
    required this.id,
    required this.name,
    required this.status,
    this.borrowedById,
    this.borrowedByName,
    this.borrowedAt,
    required this.createdAt,
  });

  factory Asset.fromFirestore(String id, Map<String, dynamic> data) {
    return Asset(
      id: id,
      name: data['name'] ?? '',
      status: data['status'] ?? 'available',
      borrowedById: data['borrowedById'],
      borrowedByName: data['borrowedByName'],
      borrowedAt: data['borrowedAt'] != null
          ? (data['borrowedAt'] as Timestamp).toDate()
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'status': status,
      'borrowedById': borrowedById,
      'borrowedByName': borrowedByName,
      'borrowedAt': borrowedAt != null
          ? Timestamp.fromDate(borrowedAt!)
          : null,
      'createdAt': Timestamp.now(),
    };
  }
}
