import 'package:flutter/material.dart';

class AssigneeCard extends StatelessWidget {
  final String teamName;
  final List<Map<String, dynamic>> assignees;

  const AssigneeCard({
    super.key,
    required this.teamName,
    required this.assignees,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tổ phụ trách",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  teamName,
                  style: const TextStyle(
                    color: Color(0xFF4A7EFF),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...assignees
              .take(3)
              .map((member) => _buildAssigneeItem(member))
              .toList(),

          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            // child: GestureDetector(
            //   onTap: () {
            //     print("Xem thêm người phụ trách");
            //   },
            //   child: const Text(
            //     "Xem thêm",
            //     style: TextStyle(
            //       color: Color(0xFF4A7EFF),
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ),
            // ),
          ),
        ],
      ),
    );
  }

  // Widget item người phụ trách
  Widget _buildAssigneeItem(Map<String, dynamic> member) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: member["color"] as Color,
            ),
          ),
          const SizedBox(width: 10),
          Text(member["name"] as String, style: const TextStyle(fontSize: 15)),
          if (member["isLeader"] == true)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber),
                ),
                child: Text(
                  "Tổ trưởng",
                  style: TextStyle(
                    color: Colors.amber.shade800,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
