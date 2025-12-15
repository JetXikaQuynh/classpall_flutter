import 'package:flutter/material.dart';
import 'package:classpall_flutter/widgets/custom_bottom_bar.dart'; // import bottom bar
import 'package:classpall_flutter/routes/app_routes.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0; // để quản lý index cho bottom bar

  void _onBottomTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Sau này xử lý navigation ở đây (ví dụ chuyển sang Notification, Profile)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FDFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE1F5FE),
        elevation: 0,
        toolbarHeight: 90,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Class Pal',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Xin chào, Nguyễn Văn A - Lớp trưởng',
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        // THÊM SCROLL Ở ĐÂY
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quản lý lớp học',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildCard(
              Icons.calendar_today_rounded,
              Colors.redAccent,
              'Đăng ký Sự kiện',
              'Tạo sự kiện, quản lý điểm danh',
              () {},
            ),
            const SizedBox(height: 16),
            _buildCard(
              Icons.assignment_turned_in_rounded,
              Colors.orangeAccent,
              'Phân công trực nhật',
              'Quản lý trực nhật và nhiệm vụ',
              () {
                Navigator.pushNamed(context, AppRoutes.memberDashboardDuty);
              },
            ),
            const SizedBox(height: 16),
            _buildCard(
              Icons.inventory_rounded,
              Colors.brown,
              'Quản lý Tài sản',
              'Theo dõi tài sản lớp',
              () {},
            ),
            const SizedBox(height: 16),
            _buildCard(
              Icons.account_balance_wallet_rounded,
              Colors.green,
              'Quản lý Quỹ lớp',
              'Quản lý thu chi tài chính',
              () {},
            ),
            const SizedBox(
              height: 100,
            ), // thêm khoảng trống dưới để scroll đẹp khi có nhiều card
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(currentIndex: _currentIndex),
    );
  }

  Widget _buildCard(
    IconData icon,
    Color color,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 36, color: color),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
