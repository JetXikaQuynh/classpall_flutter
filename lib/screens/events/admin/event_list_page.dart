import 'package:flutter/material.dart';
import 'package:classpall_flutter/widgets/custom_bottom_bar.dart';
import 'package:classpall_flutter/widgets/event/event_card_admin.dart';
import 'package:classpall_flutter/routes/app_routes.dart';



import 'event_create_form.dart';

class EventListPage extends StatelessWidget {
  const EventListPage({super.key});

  void _openCreateEvent(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const EventCreateForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Quản lý Sự kiện'),
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 1),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Danh sách sự kiện lớp học',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ===== BUTTON TẠO SỰ KIỆN =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _openCreateEvent(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Tạo sự kiện mới'),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// ===== EVENT LIST =====
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return EventCardAdmin(
                    title: 'Hội thảo Khoa học Công nghệ 2024',
                    description:
                        'Hội thảo về các xu hướng công nghệ mới nhất trong năm 2024',
                    date: '15/12/2024',
                    time: '14:00',
                    location: 'Hội trường A, Tầng 3',
                    registered: 30,
                    capacity: 50,
                    isRequired: true,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                          AppRoutes.adminEventDetail,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
