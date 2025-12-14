import 'package:flutter/material.dart';
import 'package:classpall_flutter/widgets/event_info_row.dart';

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Chi tiết Sự kiện'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TITLE
              const Text(
                'Hội thảo Khoa học Công nghệ 2024',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 6),

              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE0E0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Bắt buộc',
                  style: TextStyle(color: Color(0xFFE91E63), fontSize: 12),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Hội thảo về các xu hướng công nghệ mới nhất trong năm 2024',
              ),

              const SizedBox(height: 16),

              EventInfoRow(
                icon: Icons.calendar_today,
                iconColor: Colors.red,
                text: '15/12/2024',
              ),
              const SizedBox(height: 8),
              EventInfoRow(
                icon: Icons.access_time,
                iconColor: Colors.blue,
                text: '14:00',
              ),
              const SizedBox(height: 8),
              EventInfoRow(
                icon: Icons.location_on,
                iconColor: Colors.green,
                text: 'Hội trường A, Tầng 3',
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download),
                  label: const Text('Xuất danh sách CSV'),
                ),
              ),

              const SizedBox(height: 28),

              /// DASHBOARD
              const Text(
                'Dashboard Điểm danh',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Row(
                children: const [
                  Expanded(
                    child: _DashboardBox(
                      color: Color(0xFFE8F5E9),
                      title: 'Đã đăng ký',
                      value: '30 / 50',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _DashboardBox(
                      color: Color(0xFFFFF3E0),
                      title: 'Chưa đăng ký',
                      value: '20 / 50',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// STUDENT LIST
              const Text(
                'Chưa đăng ký (20)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Tìm kiếm sinh viên...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 8,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.warning, color: Colors.orange),
                    title: Text('Sinh viên ${index + 31}'),
                    subtitle: Text(
                      'SV${index + 31} - sv${index + 31}@university.edu',
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardBox extends StatelessWidget {
  final Color color;
  final String title;
  final String value;

  const _DashboardBox({
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(title),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
