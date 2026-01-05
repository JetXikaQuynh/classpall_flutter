import 'package:cloud_firestore/cloud_firestore.dart';

class FundCollection {
  final String id;
  final String title;
  final int amountPerUser;
  final String teamId;
  final String createdBy;
  final DateTime createdAt;
  final int totalCollected;

  FundCollection({
    required this.id,
    required this.title,
    required this.amountPerUser,
    required this.teamId,
    required this.createdBy,
    required this.createdAt,
    this.totalCollected = 0,
  });

  factory FundCollection.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data()!;
    return FundCollection(
      id: doc.id,
      title: data['title'],
      amountPerUser: data['amountPerUser'],
      teamId: data['teamId'],
      createdBy: data['createdBy'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      totalCollected: data['totalCollected'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amountPerUser': amountPerUser,
      'teamId': teamId,
      'createdBy': createdBy,
      'createdAt': Timestamp.now(),
      'totalCollected': totalCollected,
    };
  }
}
