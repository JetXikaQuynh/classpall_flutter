import 'package:flutter/material.dart';
import 'package:classpall_flutter/widgets/event/event_info_row.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({super.key});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _exportCsv(BuildContext context) {
    // TODO: Export CSV
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Xuất danh sách CSV (UI demo)')),
    );
  }

  void _sendReminder(BuildContext context) {
    // TODO: Send notification to unregistered students
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã gửi nhắc nhở tới sinh viên chưa đăng ký'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết Sự kiện'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===== TITLE =====
            const Text(
              'Hội thảo Khoa học Công nghệ 2024',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

            /// ===== CSV EXPORT =====
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text('Xuất danh sách CSV'),
                onPressed: () => _exportCsv(context),
              ),
            ),

            /// ===== DASHBOARD =====
            const SizedBox(height: 28),
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

            /// ===== REMINDER BUTTON =====
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.notifications_active),
                label: const Text('Gửi nhắc nhở'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                onPressed: () => _sendReminder(context),
              ),
            ),

            /// ===== TABS =====
            const SizedBox(height: 24),
            TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Chưa đăng ký (20)'),
                Tab(text: 'Đã đăng ký (30)'),
              ],
            ),

            /// ===== TAB CONTENT =====
            SizedBox(
              height: 420,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _StudentList(
                    count: 20,
                    warning: true,
                  ),
                  _StudentList(
                    count: 30,
                    warning: false,
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

/// ===== DASHBOARD BOX =====
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/// ===== STUDENT LIST =====
class _StudentList extends StatelessWidget {
  final int count;
  final bool warning;

  const _StudentList({
    required this.count,
    required this.warning,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: count,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(child: Text('${index + 1}')),
          title: Text('Sinh viên ${index + 1}'),
          subtitle: Text('sv${index + 1}@university.edu'),
          trailing: warning
              ? const Icon(Icons.warning, color: Colors.orange)
              : const Icon(Icons.check_circle, color: Colors.green),
        );
      },
    );
  }
}
