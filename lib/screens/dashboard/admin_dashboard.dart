import 'package:classpall_flutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:classpall_flutter/widgets/custom_bottom_bar.dart'; 
import 'package:classpall_flutter/routes/app_routes.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        toolbarHeight: 90,
        automaticallyImplyLeading: false, 
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
              () {
                Navigator.pushNamed(context, AppRoutes.adminEventList);                
              },
            ),
            const SizedBox(height: 16),
            _buildCard(
              Icons.assignment_turned_in_rounded,
              Colors.orangeAccent,
              'Phân công trực nhật',
              'Quản lý trực nhật và nhiệm vụ',
              () {
                Navigator.pushNamed(context, AppRoutes.adminDashboardDuty);
              },
            ),
            const SizedBox(height: 16),
            _buildCard(
              Icons.inventory_rounded,
              Colors.brown,
              'Quản lý Tài sản',
              'Theo dõi tài sản lớp',
              () {
                Navigator.pushNamed(context, AppRoutes.assets);
              },
            ),
            const SizedBox(height: 16),
            _buildCard(
              Icons.account_balance_wallet_rounded,
              Colors.green,
              'Quản lý Quỹ lớp',
              'Quản lý thu chi tài chính',
              () {
                Navigator.pushNamed(context, AppRoutes.fund);
              },
            ),
            const SizedBox(
              height: 100,
            ), 
          ],
        ),
      ),
      
      bottomNavigationBar: const CustomBottomBar(currentIndex: 0),
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
              const Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 255, 255, 255), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
