import 'package:flutter/material.dart';
import 'package:classpall_flutter/widgets/custom_bottom_bar.dart';
import 'package:classpall_flutter/widgets/duty_item.dart';
import 'package:classpall_flutter/widgets/leaderboard_card.dart';

class MemberDashboardDuty extends StatelessWidget {
  const MemberDashboardDuty({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAF3FF),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          "Phân công trực nhật",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomBar(currentIndex: 0, onTap: (index) {}),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // team box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tổ của bạn",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Tổ 2",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            //leaderboard
            LeaderboardCard(
              teams: [
                {"rank": 1, "name": "1", "points": 85},
                {"rank": 2, "name": "3", "points": 80},
                {"rank": 3, "name": "2", "points": 75},
              ],
              onViewAll: () {
                print("View full leaderboard");
              },
            ),

            const SizedBox(height: 20),
            // duty list
            const Text(
              "Nhiệm vụ tổ bạn:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            DutyItem(
              title: "Quét lớp",
              team: "2",
              deadline: "02/12/2025",
              status: "inprogress",
              onTap: () {},
            ),

            DutyItem(
              title: "Đổ rác",
              team: "2",
              deadline: "02/12/2025",
              status: "late",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
