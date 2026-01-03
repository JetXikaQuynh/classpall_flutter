import 'package:cloud_firestore/cloud_firestore.dart';

class FundExpense {
  final String id;
  final String title;
  final int amount;
  final String note;
  final String createdBy;
  final DateTime createdAt;

  FundExpense({
    required this.id,
    required this.title,
    required this.amount,
    required this.note,
    required this.createdBy,
    required this.createdAt,
  });

  factory FundExpense.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data()!;
    return FundExpense(
      id: doc.id,
      title: data['title'],
      amount: data['amount'],
      note: data['note'],
      createdBy: data['createdBy'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'note': note,
      'createdBy': createdBy,
      'createdAt': Timestamp.now(),
    };
  }
}
