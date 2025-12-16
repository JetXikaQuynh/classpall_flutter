import 'package:cloud_firestore/cloud_firestore.dart';

class DutyHistoryModel {
  final String id;
  final String dutyId;
  final String teamId;
  final int weekNumber;
  final int month;
  final int year;
  final int points;

  DutyHistoryModel({
    required this.id,
    required this.dutyId,
    required this.teamId,
    required this.weekNumber,
    required this.month,
    required this.year,
    required this.points,
  });

  factory DutyHistoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DutyHistoryModel(
      id: doc.id,
      dutyId: data['id_duty'],
      teamId: data['id_team'],
      weekNumber: data['week_number'],
      month: data['month'],
      year: data['year'],
      points: data['points'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_duty': dutyId,
      'id_team': teamId,
      'week_number': weekNumber,
      'month': month,
      'year': year,
      'points': points,
    };
  }
}
