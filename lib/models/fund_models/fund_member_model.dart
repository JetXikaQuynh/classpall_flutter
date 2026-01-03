import 'package:cloud_firestore/cloud_firestore.dart';

class FundMember {
  final String id;
  final String collectionId;
  final String userId;
  final String userName;
  final int amount;
  final bool paid;
  final DateTime? paidAt;

  FundMember({
    required this.id,
    required this.collectionId,
    required this.userId,
    required this.userName,
    required this.amount,
    required this.paid,
    this.paidAt,
  });

  factory FundMember.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data()!;
    return FundMember(
      id: doc.id,
      collectionId: data['collectionId'],
      userId: data['userId'],
      userName: data['userName'],
      amount: data['amount'] ?? 0,
      paid: data['paid'],
      paidAt: data['paidAt'] != null
          ? (data['paidAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'collectionId': collectionId,
      'userId': userId,
      'userName': userName,
      'amount': amount,
      'paid': paid,
      'paidAt':
      paidAt != null ? Timestamp.fromDate(paidAt!) : null,
    };
  }
}
