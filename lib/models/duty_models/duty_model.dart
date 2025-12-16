import 'package:cloud_firestore/cloud_firestore.dart';

class DutyModel {
  final String id;
  final String name;
  final String description;
  final bool isRepeat;
  final int points;
  final String startTeamId;

  DutyModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isRepeat,
    required this.points,
    required this.startTeamId,
  });

  factory DutyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DutyModel(
      id: doc.id,
      name: data['name_duty'],
      description: data['description'],
      isRepeat: data['is_repeat'],
      points: data['points'],
      startTeamId: data['start_team_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name_duty': name,
      'description': description,
      'is_repeat': isRepeat,
      'points': points,
      'start_team_id': startTeamId,
    };
  }
}
