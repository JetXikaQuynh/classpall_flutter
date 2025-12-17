import 'package:cloud_firestore/cloud_firestore.dart';

class DutyAssignmentModel {
  final String id;
  final String dutyId;
  final String teamId;
  final String status; // late | done | inprogress | pending_approval
  final int weekNumber;
  final int year;

  DutyAssignmentModel({
    required this.id,
    required this.dutyId,
    required this.teamId,
    required this.status,
    required this.weekNumber,
    required this.year,
  });

  factory DutyAssignmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DutyAssignmentModel(
      id: doc.id,
      dutyId: data['id_duty'],
      teamId: data['id_team'],
      status: data['status'],
      weekNumber: data['week_number'],
      year: data['year'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_duty': dutyId,
      'id_team': teamId,
      'status': status,
      'week_number': weekNumber,
      'year': year,
    };
  }
}
