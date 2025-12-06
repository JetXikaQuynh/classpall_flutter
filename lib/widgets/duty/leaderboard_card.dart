import 'package:flutter/material.dart';

class LeaderboardCard extends StatelessWidget {
  final List<Map<String, dynamic>> teams;
  final VoidCallback onViewAll;

  const LeaderboardCard({
    super.key,
    required this.teams,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.yellow.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.emoji_events,
                    color: Color.fromARGB(255, 255, 191, 0),
                    size: 28,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Bảng vàng",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: onViewAll,
              ),
            ],
          ),

          const SizedBox(height: 12),

          Column(
            children: teams.map((team) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: const Color.fromARGB(255, 255, 200, 71),
                      child: Text(
                        team["rank"].toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Tổ ${team['name']}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Text(
                      "${team['points']} điểm",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
