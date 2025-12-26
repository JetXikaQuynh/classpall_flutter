import 'package:flutter/material.dart';
import 'package:classpall_flutter/widgets/custom_bottom_bar.dart';
import 'package:classpall_flutter/widgets/event/event_card_admin.dart';
import 'package:classpall_flutter/routes/app_routes.dart';
import 'package:classpall_flutter/models/event_models/event_model.dart';
import 'package:classpall_flutter/services/auth_service.dart'; 
import 'package:classpall_flutter/services/event_services/event_service.dart';
import 'package:classpall_flutter/screens/events/admin/event_create_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Quản lý Sự kiện'),
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 1),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _openCreateEvent(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Tạo sự kiện mới'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            FutureBuilder<int>(
              future: AuthService.getTotalMembers(), // Lấy tổng từ users 1 lần
              builder: (context, totalSnapshot) {
                final totalMembers = totalSnapshot.data ?? 50; // fallback

                return Expanded(
                  child: StreamBuilder<List<EventModel>>(
                    stream: EventService().getEvents(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Lỗi: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('Chưa có sự kiện nào'));
                      }

                      final events = snapshot.data!;

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];

                          return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('event_registrations')
                                .where('event_id', isEqualTo: event.id)
                                .where('status', isEqualTo: 'joined')
                                .snapshots(),
                            builder: (context, regSnapshot) {
                              final joinedCount = regSnapshot.data?.docs.length ?? event.totalRegistered ?? 0;

                              return EventCardAdmin(
                                title: event.title,
                                description: event.description,
                                date: event.eventDate.toString().split(' ')[0],
                                time: event.eventDate.toString().split(' ')[1].substring(0, 5),
                                location: event.location,
                                registered: joinedCount, // realtime
                                capacity: totalMembers, // từ users
                                isRequired: event.isMandatory,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.adminEventDetail,
                                    arguments: event.id,
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}