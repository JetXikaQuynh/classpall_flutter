import 'package:flutter/material.dart';
import 'package:classpall_flutter/widgets/custom_bottom_bar.dart';
import 'package:classpall_flutter/screens/events/member/event_decline_form.dart';
import 'package:classpall_flutter/services/event_services/event_service.dart';
import 'package:classpall_flutter/services/event_services/event_registration_service.dart';
import 'package:classpall_flutter/models/event_models/event_model.dart';
import 'package:classpall_flutter/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum EventStatus { pending, joined }

class MemberEventListPage extends StatefulWidget {
  const MemberEventListPage({super.key});

  @override
  State<MemberEventListPage> createState() => _MemberEventListPageState();
}

class _MemberEventListPageState extends State<MemberEventListPage> {
  EventStatus _currentStatus = EventStatus.pending;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('Sự kiện lớp học'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8, left: 16),
            child: Text(
              'Quản lý phản hồi sự kiện',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      body: FutureBuilder<int>(
        future: AuthService.getTotalMembers(),
        builder: (context, totalSnapshot) {
          final totalMembers = totalSnapshot.data ?? 0;

          return StreamBuilder<List<EventModel>>(
            stream: EventService().getEvents(),
            builder: (context, eventSnapshot) {
              if (eventSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!eventSnapshot.hasData || eventSnapshot.data!.isEmpty) {
                return const Center(child: Text('Chưa có sự kiện nào'));
              }

              final events = eventSnapshot.data!;

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('event_registrations')
                    .where('user_id', isEqualTo: AuthService.currentUser?.uid)
                    .snapshots(),
                builder: (context, regSnapshot) {
                  final registrations = regSnapshot.data?.docs ?? [];

                  int pendingCount = 0;
                  int respondedCount = 0;

                  final List<Map<String, dynamic>> filteredEvents = [];

                  for (var event in events) {
                    QueryDocumentSnapshot? userRegDoc;

                    for (var doc in registrations) {
                      final data = doc.data() as Map<String, dynamic>;
                      if (data['event_id'] == event.id) {
                        userRegDoc = doc;
                        break;
                      }
                    }

                    final userReg = userRegDoc?.data() as Map<String, dynamic>?;
                    final status = userReg?['status'] as String? ?? 'pending';

                    if (status == 'pending') pendingCount++;
                    if (status == 'joined' || status == 'declined') {
                      respondedCount++;
                    }

                    if ((_currentStatus == EventStatus.pending &&
                            status == 'pending') ||
                        (_currentStatus == EventStatus.joined &&
                            (status == 'joined' || status == 'declined'))) {
                      filteredEvents.add({'event': event, 'status': status});
                    }
                  }

                  return Column(
                    children: [
                      _buildFilterBar(pendingCount, respondedCount),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredEvents.length,
                          itemBuilder: (context, index) {
                            final item = filteredEvents[index];
                            final EventModel event = item['event'];
                            final String status = item['status'];

                            return StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('event_registrations')
                                  .where('event_id', isEqualTo: event.id)
                                  .where('status', isEqualTo: 'joined')
                                  .snapshots(),
                              builder: (context, joinedSnapshot) {
                                final joinedCount =
                                    joinedSnapshot.data?.docs.length ??
                                    event.totalRegistered;

                                return _buildEventCard(
                                  event: event,
                                  status: status,
                                  joinedCount: joinedCount,
                                  totalMembers: totalMembers,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 0),
    );
  }

  // ================= FILTER BAR =================

  Widget _buildFilterBar(int pending, int responded) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentStatus = EventStatus.pending),
              child: _buildFilterChip(
                label: 'Cần phản hồi',
                count: pending,
                isActive: _currentStatus == EventStatus.pending,
                color: Colors.orange,
                icon: Icons.warning_amber,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentStatus = EventStatus.joined),
              child: _buildFilterChip(
                label: 'Đã phản hồi',
                count: responded,
                isActive: _currentStatus == EventStatus.joined,
                color: Colors.green,
                icon: Icons.check_circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= EVENT CARD =================

  Widget _buildEventCard({
    required EventModel event,
    required String status,
    required int joinedCount,
    required int totalMembers,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (event.isMandatory)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Bắt buộc',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(event.description),
            const SizedBox(height: 12),
            _infoRow(
              Icons.calendar_today,
              event.eventDate.toString().split(' ')[0],
            ),
            _infoRow(
              Icons.access_time,
              event.eventDate.toString().split(' ')[1].substring(0, 5),
            ),
            _infoRow(Icons.location_on, event.location),
            _infoRow(
              Icons.people,
              '$joinedCount/$totalMembers sinh viên đã đăng ký',
            ),
            const SizedBox(height: 16),

            /// ===== RESPONSE UI =====
            if (status == 'pending') _buildActionButtons(event),
            if (status == 'joined')
              _statusText(
                Icons.check_circle,
                Colors.green,
                'Bạn đã tham gia sự kiện này',
              ),
            if (status == 'declined')
              _statusText(
                Icons.cancel,
                Colors.red,
                'Bạn đã từ chối tham gia sự kiện này',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(EventModel event) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              EventRegistrationService.instance.respondEvent(
                eventId: event.id!,
                joined: true,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Tham gia'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              if (event.isMandatory) {
                showRequiredEventDialog(context);
                return;
              }
              EventRegistrationService.instance.respondEvent(
                eventId: event.id!,
                joined: false,
              );
            },
            child: const Text('Không tham gia'),
          ),
        ),
      ],
    );
  }

  Widget _statusText(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [Icon(icon, size: 16), const SizedBox(width: 6), Text(text)],
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
