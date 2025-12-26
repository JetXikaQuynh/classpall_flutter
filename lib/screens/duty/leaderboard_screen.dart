import 'package:flutter/material.dart';

import '../../models/duty_models/duty_assignment_model.dart';
import '../../models/duty_models/duty_model.dart';
import '../../models/duty_models/team_model.dart';

import '../../services/duty_services/duty_assignment_service.dart';
import '../../services/duty_services/duty_service.dart';
import '../../services/duty_services/team_service.dart';

/// 🔥 Stateful vì load dữ liệu Firestore
class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int selectedTab = 2; // 0 = tuần, 1 = tháng, 2 = tất cả

  /// 🔥 SERVICES
  final _assignmentService = DutyAssignmentService();
  final _dutyService = DutyService();
  final _teamService = TeamService();

  bool _loading = true;

  /// 🔥 DATA SAU KHI TÍNH
  List<_LeaderboardItem> _leaderboard = [];

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  /// 🔥 LOAD + TÍNH ĐIỂM
  Future<void> _loadLeaderboard() async {
    setState(() => _loading = true);

    // 1️⃣ Load data
    final assignments = await _assignmentService.getAllAssignments();
    final duties = await _dutyService.getAllDuties();
    final teams = await _teamService.getAllTeams();

    // 2️⃣ Map nhanh
    final dutyMap = {for (var d in duties) d.id: d};
    final teamMap = {for (var t in teams) t.id: t};

    // 3️⃣ Khởi tạo bảng điểm
    final Map<String, _LeaderboardItem> scoreMap = {};

    for (var team in teams) {
      scoreMap[team.id] = _LeaderboardItem(
        teamName: team.name,
        points: 0,
        done: 0,
        progress: 0,
        late: 0,
      );
    }

    // 4️⃣ TÍNH TOÁN
    for (var a in assignments) {
      final team = scoreMap[a.teamId];
      final duty = dutyMap[a.dutyId];

      if (team == null || duty == null) continue;

      switch (a.status) {
        case 'done':
          team.done++;
          team.points += duty.points;
          break;
        case 'inprogress':
          team.progress++;
          break;
        case 'late':
          team.late++;
          break;
      }
    }

    // 5️⃣ SORT THEO ĐIỂM
    final result = scoreMap.values.toList()
      ..sort((a, b) => b.points.compareTo(a.points));

    // Gán thứ hạng
    for (int i = 0; i < result.length; i++) {
      result[i].rank = i + 1;
    }

    setState(() {
      _leaderboard = result;
      _loading = false;
    });
  }

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

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 TAB
                  Row(
                    children: [
                      _tabButton("Tuần", 0),
                      const SizedBox(width: 8),
                      _tabButton("Tháng", 1),
                      const SizedBox(width: 8),
                      _tabButton("Tất cả", 2),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// 🔥 TOP 3
                  if (_leaderboard.length >= 3)
                    Center(
                      child: SizedBox(
                        width: 260,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildTopBar(
                              _leaderboard[1],
                              80,
                              const Color.fromARGB(255, 228, 173, 97),
                            ),
                            _buildTopBar(_leaderboard[0], 120, Colors.amber),
                            _buildTopBar(_leaderboard[2], 50, Colors.grey),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 30),

                  const Text(
                    "Chi tiết xếp hạng",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  Column(
                    children: _leaderboard
                        .map((e) => _teamRankCard(e))
                        .toList(),
                  ),
                ],
              ),
            ),
    );
  }

  /// ================= UI =================

  Widget _tabButton(String title, int index) {
    final isActive = selectedTab == index;

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

  Widget _buildTopBar(_LeaderboardItem item, double height, Color color) {
    return Column(
      children: [
        Icon(Icons.emoji_events, size: 32, color: color),
        const SizedBox(height: 6),
        Text(
          item.teamName,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
        Text("${item.points} điểm", style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _teamRankCard(_LeaderboardItem team) {
    Color rankColor = team.rank == 1
        ? Colors.amber
        : team.rank == 2
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
          Row(
            children: [
              Icon(Icons.emoji_events, color: rankColor, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  team.teamName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                "${team.points} điểm",
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem(team.done, "Hoàn thành", Colors.green),
              _statItem(team.progress, "Đang làm", Colors.blue),
              _statItem(team.late, "Quá hạn", Colors.red),
            ],
          ),
        ],
      ),
    );
  }

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

/// 🔥 VIEW MODEL
class _LeaderboardItem {
  int rank = 0;
  final String teamName;
  int points;
  int done;
  int progress;
  int late;

  _LeaderboardItem({
    required this.teamName,
    required this.points,
    required this.done,
    required this.progress,
    required this.late,
  });
}
