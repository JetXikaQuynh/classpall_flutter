import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int selectedTab = 2; // 0 = tuần, 1 = tháng, 2 = tất cả

  // Fake ranking data (sau này thay bằng Firestore)
  final List<Map<String, dynamic>> leaderboard = [
    {
      "rank": 1,
      "team": "1",
      "points": 95,
      "done": 12,
      "progress": 1,
      "late": 0,
    },
    {
      "rank": 2,
      "team": "3",
      "points": 88,
      "done": 10,
      "progress": 2,
      "late": 1,
    },
    {"rank": 3, "team": "2", "points": 82, "done": 9, "progress": 1, "late": 2},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAF3FF),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Bảng vàng",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TAB BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _tabButton("Tuần", 0),
                const SizedBox(width: 8),
                _tabButton("Tháng", 1),
                const SizedBox(width: 8),
                _tabButton("Tất cả", 2),
              ],
            ),

            const SizedBox(height: 20),

            // TOP 3 BAR CHART
            Center(
              child: SizedBox(
                width: 260,
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, //căn đều khoảng cách
                  crossAxisAlignment:
                      CrossAxisAlignment.end, //căn dưới thẳng hàng
                  children: [
                    _buildTopBar(
                      team: "3",
                      points: 88,
                      height: 80,
                      color: Colors.grey,
                    ),
                    _buildTopBar(
                      team: "1",
                      points: 95,
                      height: 120,
                      color: Colors.amber,
                    ),
                    _buildTopBar(
                      team: "2",
                      points: 82,
                      height: 70,
                      color: const Color.fromARGB(255, 228, 173, 97),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // CHI TIẾT XẾP HẠNG
            const Text(
              "Chi tiết xếp hạng",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            //list team rank cards
            Column(
              children: leaderboard
                  .map(
                    (team) => _teamRankCard(
                      rank: team["rank"],
                      team: team["team"],
                      points: team["points"],
                      done: team["done"],
                      progress: team["progress"],
                      late: team["late"],
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // TAB BUTTON
  Widget _tabButton(String title, int index) {
    final bool isActive = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // TOP 3 BAR ITEM
  Widget _buildTopBar({
    required String team,
    required int points,
    required double height,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(Icons.emoji_events, size: 32, color: color),
        const SizedBox(height: 6),
        Text(
          "Tổ $team",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Container(
          width: 40,
          height: height,
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        Text("$points điểm", style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  // TEAM CARD
  Widget _teamRankCard({
    required int rank,
    required String team,
    required int points,
    required int done,
    required int progress,
    required int late,
  }) {
    Color rankColor = rank == 1
        ? Colors.amber
        : rank == 2
        ? Colors.orange
        : Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.emoji_events, color: rankColor, size: 30),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tổ $team",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Hạng $rank",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Text(
                "$points Điểm",
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // FOOTER STATS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem(done, "Hoàn thành", Colors.green),
              _statItem(progress, "Đang làm", Colors.blue),
              _statItem(late, "Quá hạn", Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  // STAT ITEM (done / in progress / late)
  Widget _statItem(int num, String label, Color color) {
    return Column(
      children: [
        Text(
          "$num",
          style: TextStyle(
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}
