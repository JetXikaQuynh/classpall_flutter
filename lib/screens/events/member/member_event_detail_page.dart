import 'package:flutter/material.dart';
import 'package:classpall_flutter/widgets/custom_bottom_bar.dart'; // Import bottom bar

class MemberEventDetailPage extends StatelessWidget {
  const MemberEventDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        title: const Text('Sự kiện lớp học'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: const Text('Hội thảo Khoa học Công nghệ 2025', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFFFFE0E0), borderRadius: BorderRadius.circular(20)),
                  child: const Text('Bắt buộc', style: TextStyle(color: Color(0xFFE91E63))),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Đã xác nhận', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            const Text('Hội thảo về các xu hướng công nghệ mới nhất trong năm 2025'),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: Colors.red),
                const SizedBox(width: 8),
                const Text('15/12/2025'),
                const SizedBox(width: 20),
                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                const Text('14:00'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on, size: 18, color: Colors.red),
                const SizedBox(width: 8),
                const Text('Hội trường A, Tầng 3'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.people, size: 18, color: Colors.blue),
                const SizedBox(width: 8),
                const Text('30/50 sinh viên đã đăng ký'),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green)),
              child: const Center(
                child: Text('Bạn đã đăng ký tham gia sự kiện này', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 0), // Dùng bottom bar của bạn
    );
  }
}