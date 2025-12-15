import 'package:flutter/material.dart';
import '../../widgets/duty/progress_card.dart';
import '../../widgets/duty/leaderboard_card.dart';
import '../../widgets/duty/duty_item.dart';
import '../../../widgets/custom_bottom_bar.dart';
import '../../routes/app_routes.dart';

class AdminDashboardDuty extends StatelessWidget {
  const AdminDashboardDuty({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Phân công trực nhật"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            //Dùng Navigator.pop để quay lại màn hình AdminDashboard
            Navigator.pop(context);
          },
        ),
      ),
      //tạm thời
      bottomNavigationBar: const CustomBottomBar(currentIndex: 0),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressCard(
              total: 3,
              completed: 1,
              inProgress: 1,
              onCreate: () {},
            ),

            const SizedBox(height: 16),

            LeaderboardCard(
              teams: [
                {"rank": 1, "name": "1", "points": 85},
                {"rank": 2, "name": "3", "points": 80},
                {"rank": 3, "name": "2", "points": 75},
              ],
              onViewAll: () {
                Navigator.pushNamed(context, AppRoutes.leaderboard);
              },
            ),

            const SizedBox(height: 20),
            const Text(
              "Nhiệm vụ tuần này:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            DutyItem(
              title: "Giặt giẻ lau",
              team: "1",
              deadline: "02/12/2025",
              status: "done",
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.dutyDetail);
              },
            ),

            DutyItem(
              title: "Lau bảng",
              team: "1",
              deadline: "02/12/2025",
              status: "pending_approval",
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.dutyDetail);
              },
            ),

            DutyItem(
              title: "Quét lớp",
              team: "2",
              deadline: "02/12/2025",
              status: "late",
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.dutyDetail);
              },
            ),

            DutyItem(
              title: "Đổ rác",
              team: "3",
              deadline: "02/12/2025",
              status: "inprogress",
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.dutyDetail);
              },
            ),
          ],
        ),
      ),
    );
  }
}
