import 'package:flutter/material.dart';
import '../widgets/custom_bottom_bar.dart';
import '../routes/app_routes.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Thông báo",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// -------- HEADER --------
            Row(
              children: const [
                Icon(Icons.notifications, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  "2 thông báo chưa đọc",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// -------- NOTIFICATION LIST --------
            _NotificationCard(
              icon: Icons.calendar_today,
              iconBg: Colors.blue.shade50,
              title: "Nhắc nhở: Tuần này đến lượt tổ bạn trực nhật",
              content: "Nhiệm vụ của tổ bạn là Lau bảng.",
              time: "5 giờ trước",
              actionText: "Xem chi tiết →",
              isUnread: true,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.dutyDetail);
              },
            ),

            _NotificationCard(
              icon: Icons.calendar_today,
              iconBg: Colors.blue.shade100,
              title: "Sự kiện mới: Hội thảo Khoa học Công nghệ 2024",
              content:
                  "Lớp trưởng vừa tạo sự kiện mới. Vui lòng xác nhận tham gia trước ngày 10/12.",
              time: "2 giờ trước",
              actionText: "Xem sự kiện →",
              isUnread: true,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.memberEventList);
              },
            ),

            _NotificationCard(
              icon: Icons.attach_money,
              iconBg: Colors.green.shade100,
              title: "Thông báo đóng quỹ tháng 12",
              content:
                  "Đã đến hạn đóng quỹ lớp tháng 12. Mức đóng: 100,000 VND.",
              time: "2 ngày trước",
              actionText: "Xem chi tiết →",
              isUnread: false,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.fund);
              },
            ),
          ],
        ),
      ),

      bottomNavigationBar: const CustomBottomBar(currentIndex: 1),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String content;
  final String time;
  final String actionText;
  final bool isUnread;
  final VoidCallback? onTap;

  const _NotificationCard({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.content,
    required this.time,
    required this.actionText,
    required this.isUnread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap, // ✅ bắt sự kiện tap
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isUnread
              ? Border.all(color: Colors.blue, width: 1.5)
              : Border.all(color: Colors.transparent),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ICON
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.blue),
            ),

            const SizedBox(width: 12),

            /// CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                      Text(
                        actionText,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
