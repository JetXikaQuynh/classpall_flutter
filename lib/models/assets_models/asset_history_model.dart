import 'package:cloud_firestore/cloud_firestore.dart';

class AssetHistory {
  final String id;
  final String assetId;
  final String assetName;
  final String action; // borrowed | returned
  final String userName;
  final DateTime createdAt;

  AssetHistory({
    required this.id,
    required this.assetId,
    required this.assetName,
    required this.action,
    required this.userName,
    required this.createdAt,
  });

  factory AssetHistory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AssetHistory(
      id: doc.id,
      assetId: data['assetId'],
      assetName: data['assetName'],
      action: data['action'],
      userName: data['userName'],
      createdAt: (data['time'] as Timestamp).toDate(),
    );
  }
}
