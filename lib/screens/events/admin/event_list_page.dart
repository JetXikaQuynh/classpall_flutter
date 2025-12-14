import 'package:flutter/material.dart';
import 'package:classpall_flutter/widgets/custom_bottom_bar.dart';
import 'package:classpall_flutter/widgets/event_card_admin.dart';


class EventListPage extends StatelessWidget {
  const EventListPage({super.key});

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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Tạo sự kiện mới'),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// EVENT LIST
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
                        '/event-detail-admin',
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
