import 'package:flutter/material.dart';

class RotationHistoryItem extends StatelessWidget {
  final int week;
  final String team;
  final String status;
  final bool isCurrent;

  const RotationHistoryItem({
    super.key,
    required this.week,
    required this.team,
    required this.status,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.transparent;
    Color statusTextColor = Colors.white;

    if (status == "Đã xong") {
      statusColor = Colors.green;
    } else if (status == "Hiện tại") {
      statusColor = Colors.blue;
      statusTextColor = Colors.white;
    }

    IconData leadingIcon = status == "Đã xong"
        ? Icons.check_circle
        : Icons.circle_outlined;
    Color iconColor = status == "Đã xong"
        ? Colors.green
        : (isCurrent ? Colors.blue : Colors.grey);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: isCurrent
            ? Border.all(color: Colors.blue, width: 2)
            : Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(leadingIcon, color: iconColor, size: 20),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tuần $week",
                    style: TextStyle(
                      fontWeight: isCurrent
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "$team",
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),

          if (status.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
