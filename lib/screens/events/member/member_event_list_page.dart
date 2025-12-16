import 'package:flutter/material.dart';
import 'package:classpall_flutter/widgets/custom_bottom_bar.dart';

enum EventStatus { pending, joined }

class MemberEventListPage extends StatefulWidget {
  const MemberEventListPage({super.key});

  @override
  State<MemberEventListPage> createState() => _MemberEventListPageState();
}

class _MemberEventListPageState extends State<MemberEventListPage> {
  EventStatus _currentStatus = EventStatus.pending;

  final List<Map<String, dynamic>> events = [
    {
      'title': 'Sinh nhật lớp',
      'description': 'Tổ chức sinh nhật tập thể tháng 12',
      'date': '20/12/2025',
      'time': '18:00',
      'location': 'Nhà hàng ABC',
      'registered': '39/50 sinh viên đã đăng ký',
      'status': EventStatus.pending,
    },
    {
      'title': 'Tham quan doanh nghiệp FPT Software',
      'description':
          'Chuyến tham quan tìm hiểu môi trường làm việc thực tế tại FPT Software',
      'date': '25/12/2025',
      'time': '08:00',
      'location': 'Tập trung tại cổng trường',
      'registered': '30/50 sinh viên đã đăng ký',
      'status': EventStatus.joined,
    },
  ];

  List<Map<String, dynamic>> get filteredEvents {
    return events
        .where((e) => e['status'] == _currentStatus)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sự kiện lớp học'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 16),
            child: Text(
              'Quản lý đăng ký sự kiện',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // ===== FILTER HEADER =====
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentStatus = EventStatus.pending;
                      });
                    },
                    child: _buildFilterChip(
                      label: 'Cần phản hồi',
                      count: events
                          .where((e) => e['status'] == EventStatus.pending)
                          .length,
                      isActive: _currentStatus == EventStatus.pending,
                      color: Colors.orange,
                      icon: Icons.warning_amber,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentStatus = EventStatus.joined;
                      });
                    },
                    child: _buildFilterChip(
                      label: 'Đã đăng ký',
                      count: events
                          .where((e) => e['status'] == EventStatus.joined)
                          .length,
                      isActive: _currentStatus == EventStatus.joined,
                      color: Colors.green,
                      icon: Icons.check_circle,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===== EVENT LIST =====
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                return _buildEventCard(event);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 0),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    final bool isPending = event['status'] == EventStatus.pending;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event['title'],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(event['description'],
                style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.red),
                const SizedBox(width: 6),
                Text(event['date']),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 6),
                Text(event['time']),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.red),
                const SizedBox(width: 6),
                Text(event['location']),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.people, size: 16, color: Colors.blue),
                const SizedBox(width: 6),
                Text(event['registered']),
              ],
            ),
            const SizedBox(height: 16),

            // ===== ACTION BUTTON =====
            if (isPending)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          event['status'] = EventStatus.joined;
                        });
                      },
                      child: const Text('Tham gia'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Không tham gia'),
                    ),
                  ),
                ],
              )
            else
              const Text(
                '✔ Bạn đã đăng ký sự kiện này',
                style: TextStyle(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required int count,
    required bool isActive,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.15) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isActive ? color : Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isActive ? color : Colors.grey),
          const SizedBox(width: 8),
          Text(label),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 10,
            backgroundColor: isActive ? color : Colors.grey,
            child: Text(
              '$count',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
