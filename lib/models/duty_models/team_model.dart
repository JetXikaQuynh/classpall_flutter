import 'package:cloud_firestore/cloud_firestore.dart';

class TeamModel {
  final String id;
  final String name;
  final String leaderId;
  final List<String> userIds;

  TeamModel({
    required this.id,
    required this.name,
    required this.leaderId,
    required this.userIds,
  });

  factory TeamModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TeamModel(
      id: doc.id,
      name: data['name_team'],
      leaderId: data['id_leader'],
      userIds: List<String>.from(data['id_user']),
    );
  }

  //lấy dữ liệu từ form tạo team
  Map<String, dynamic> toMap() {
    return {'name_team': name, 'id_leader': leaderId, 'id_user': userIds};
  }
}
