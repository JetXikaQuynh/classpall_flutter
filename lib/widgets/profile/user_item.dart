import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  final Map<String, dynamic> user;
  final List<String> teamOptions;
  final List<String> roleOptions;
  final Function(String? newValue) onTeamChanged;
  final Function(String? newValue) onRoleChanged;

  const UserItem({
    super.key,
    required this.user,
    required this.teamOptions,
    required this.roleOptions,
    required this.onTeamChanged,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      margin: const EdgeInsets.only(bottom: 2),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          /// Avatar
          const CircleAvatar(radius: 20, backgroundColor: Colors.grey),

          const SizedBox(width: 10),

          /// Tên
          Expanded(
            child: Text(user["name"], style: const TextStyle(fontSize: 16)),
          ),

          /// Dropdown Tổ
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.green.shade100,
            ),
            child: DropdownButton<String>(
              value: user["team"],
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down),
              items: teamOptions.map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
              onChanged: onTeamChanged,
            ),
          ),

          const SizedBox(width: 8),

          /// Dropdown Vai trò
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.yellow.shade300,
            ),
            child: DropdownButton<String>(
              value: user["role"],
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down),
              items: roleOptions.map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
              onChanged: onRoleChanged,
            ),
          ),
        ],
      ),
    );
  }
}
