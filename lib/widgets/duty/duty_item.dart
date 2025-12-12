import 'package:flutter/material.dart';

class DutyItem extends StatelessWidget {
  final String title;
  final String team;
  final String deadline;
  final String status; // "done", "late", "inprogress","pending_approval"
  final VoidCallback onTap;

  const DutyItem({
    super.key,
    required this.title,
    required this.team,
    required this.deadline,
    required this.status,
    required this.onTap,
  });

  Color _getColor() {
    switch (status) {
      case "done":
        return Colors.green.shade200;
      case "late":
        return Colors.red.shade200;
      case "pending_approval":
        return Colors.purple.shade200;
      default:
        return Colors.orange.shade200;
    }
  }

  String _getLabel() {
    switch (status) {
      case "done":
        return "Hoàn thành";
      case "late":
        return "Quá hạn";
      case "pending_approval":
        return "Chờ duyệt";
      default:
        return "Đang làm";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _getColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Tổ $team   Hạn: $deadline",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_getLabel(), style: const TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}
