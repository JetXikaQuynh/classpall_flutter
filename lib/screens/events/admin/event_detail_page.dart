import 'package:flutter/material.dart';
import 'package:classpall_flutter/widgets/event/event_info_row.dart';
import 'package:classpall_flutter/services/event_services/event_service.dart';
import 'package:classpall_flutter/services/event_services/event_registration_service.dart';
import 'package:classpall_flutter/models/event_models/event_model.dart';
import 'package:classpall_flutter/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:classpall_flutter/services/event_services/event_export_service.dart';
import 'package:classpall_flutter/services/notification_service.dart';
import 'package:classpall_flutter/widgets/custom_bottom_bar.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({super.key});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _exportCsv(BuildContext context, String eventId) async {
    try {
      await EventExportService.exportEventParticipants(eventId);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Xuất file thành công')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _sendReminder(EventModel event) async {
    final users = await FirebaseFirestore.instance.collection('users').get();
    final regs = await FirebaseFirestore.instance
        .collection('event_registrations')
        .where('event_id', isEqualTo: event.id)
        .get();

    final registered = regs.docs
        .map((e) => (e.data() as Map)['user_id'])
        .toSet();

    final targets = users.docs.where((u) => !registered.contains(u.id));

    for (final user in targets) {
      await NotificationService.instance.sendNotification(
        userId: user.id,
        title: 'Nhắc nhở sự kiện',
        body: 'Vui lòng phản hồi sự kiện "${event.title}"',
        type: 'event',
        targetId: event.id,
      );
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã gửi nhắc nhở')));
  }

  @override
  Widget build(BuildContext context) {
    final String eventId =
        ModalRoute.of(context)?.settings.arguments as String? ??
        'hardcode_event_id_for_test';

    return Scaffold(
      bottomNavigationBar: const CustomBottomBar(currentIndex: 1),
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('Chi tiết Sự kiện'),
        leading: const BackButton(),
      ),
      body: FutureBuilder<EventModel>(
        future: EventService().getEventById(eventId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Không tìm thấy sự kiện'));
          }

          final event = snapshot.data!;

          final tabLength = event.isMandatory ? 2 : 3;
          if (_tabController == null || _tabController!.length != tabLength) {
            _tabController?.dispose();
            _tabController = TabController(length: tabLength, vsync: this);
          }

          return StreamBuilder<QuerySnapshot>(
            stream: EventRegistrationService.instance.getRegistrationsByEvent(
              eventId,
            ),
            builder: (context, regSnapshot) {
              if (regSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final registrations = regSnapshot.data?.docs ?? [];

              final joinedUids = <String>{};
              final declinedUids = <String>{};
              final registeredUids = <String>{}; // All responded

              registrations.forEach((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final userId = data['user_id'] as String? ?? '';
                if (userId.isNotEmpty) {
                  final status = data['status'] as String? ?? 'pending';
                  registeredUids.add(userId);
                  if (status == 'joined') {
                    joinedUids.add(userId);
                  } else if (status == 'declined') {
                    declinedUids.add(userId);
                  }
                }
              });

              final joinedCount = joinedUids.length;
              final declinedCount = declinedUids.length;

              return FutureBuilder<int>(
                future: AuthService.getTotalMembers(), // Lấy tổng từ users
                builder: (context, totalSnapshot) {
                  final totalMembers = totalSnapshot.data ?? event.totalClass;
                  final pendingCount =
                      totalMembers -
                      registeredUids
                          .length; // Chưa phản hồi = total - registered

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (event.isMandatory)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE0E0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Bắt buộc',
                              style: TextStyle(
                                color: Color(0xFFE91E63),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(height: 12),
                        Text(event.description),
                        const SizedBox(height: 16),

                        EventInfoRow(
                          icon: Icons.calendar_today,
                          iconColor: Colors.red,
                          text: event.eventDate.toString().split(' ')[0],
                        ),
                        const SizedBox(height: 8),
                        EventInfoRow(
                          icon: Icons.access_time,
                          iconColor: Colors.blue,
                          text: event.eventDate
                              .toString()
                              .split(' ')[1]
                              .substring(0, 5),
                        ),
                        const SizedBox(height: 8),
                        EventInfoRow(
                          icon: Icons.location_on,
                          iconColor: Colors.green,
                          text: event.location,
                        ),

                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.download),
                            label: const Text('Xuất danh sách CSV'),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => _exportCsv(context, eventId),
                          ),
                        ),

                        const SizedBox(height: 28),
                        const Text(
                          'Dashboard Điểm danh',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _DashboardBox(
                                color: const Color.fromARGB(255, 107, 115, 222),
                                title: 'Đã đăng ký',
                                value: '$joinedCount / $totalMembers',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _DashboardBox(
                                color: const Color(0xFFFFF3E0),
                                title: 'Chưa đăng ký',
                                value: '$pendingCount / $totalMembers',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.notifications_active),
                            label: const Text('Gửi nhắc nhở'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            onPressed: () => _sendReminder(event),
                          ),
                        ),

                        const SizedBox(height: 24),
                        TabBar(
                          controller: _tabController,
                          labelColor: Theme.of(context).primaryColor,
                          unselectedLabelColor: const Color.fromARGB(
                            255,
                            255,
                            255,
                            255,
                          ),
                          tabs: event.isMandatory
                              ? [
                                  Tab(text: 'Chưa đăng ký ($pendingCount)'),
                                  Tab(text: 'Đã đăng ký ($joinedCount)'),
                                ]
                              : [
                                  Tab(text: 'Chưa đăng ký ($pendingCount)'),
                                  Tab(text: 'Đã đăng ký ($joinedCount)'),
                                  Tab(text: 'Đã từ chối ($declinedCount)'),
                                ],
                        ),

                        SizedBox(
                          height: 420,
                          child: TabBarView(
                            controller: _tabController,
                            children: event.isMandatory
                                ? [
                                    _StudentList(
                                      registrations: registrations,
                                      statusFilter: 'pending',
                                      warning: true,
                                      totalMembers: totalMembers,
                                    ),
                                    _StudentList(
                                      registrations: registrations,
                                      statusFilter: 'joined',
                                      warning: false,
                                      totalMembers: totalMembers,
                                    ),
                                  ]
                                : [
                                    _StudentList(
                                      registrations: registrations,
                                      statusFilter: 'pending',
                                      warning: true,
                                      totalMembers: totalMembers,
                                    ),
                                    _StudentList(
                                      registrations: registrations,
                                      statusFilter: 'joined',
                                      warning: false,
                                      totalMembers: totalMembers,
                                    ),
                                    _StudentList(
                                      registrations: registrations,
                                      statusFilter: 'declined',
                                      warning: true,
                                      totalMembers: totalMembers,
                                    ),
                                  ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// _DashboardBox 
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

// _StudentList (tên/email thật từ users, unique UID, hỗ trợ pending bằng all users - registered)
class _StudentList extends StatelessWidget {
  final List<QueryDocumentSnapshot> registrations;
  final String statusFilter;
  final bool warning;
  final int totalMembers;

  const _StudentList({
    required this.registrations,
    required this.statusFilter,
    required this.warning,
    required this.totalMembers,
  });

  @override
  Widget build(BuildContext context) {
    if (statusFilter == 'pending') {
      // Cho pending: Lấy tất cả user trừ registered
      return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('users').get(),
        builder: (context, usersSnapshot) {
          if (usersSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allUsers = usersSnapshot.data?.docs ?? [];
          final registeredUids = <String>{};

          registrations.forEach((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final userId = data['user_id'] as String? ?? '';
            if (userId.isNotEmpty) {
              registeredUids.add(userId);
            }
          });

          final pendingUsers = allUsers.where((userDoc) {
            final userId = userDoc.id;
            return !registeredUids.contains(userId);
          }).toList();

          return ListView.separated(
            itemCount: pendingUsers.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final userDoc = pendingUsers[index];
              final userData = userDoc.data() as Map<String, dynamic>;

              final name =
                  userData['fullName'] as String? ??
                  userData['fullname'] as String? ??
                  userData['name'] as String? ??
                  'Sinh viên ${index + 1}';
              final email =
                  userData['email'] as String? ??
                  'sv${index + 1}@university.edu.vn';

              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(name),
                subtitle: Text(email),
                trailing: warning
                    ? const Icon(Icons.warning, color: Colors.orange)
                    : const Icon(Icons.check_circle, color: Colors.green),
              );
            },
          );
        },
      );
    } else {
      // Cho joined/declined: Lấy từ registrations
      final filteredUids = <String>{};
      for (var doc in registrations) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['status'] == statusFilter) {
          final userId = data['user_id'] as String? ?? '';
          if (userId.isNotEmpty) {
            filteredUids.add(userId);
          }
        }
      }

      return ListView.separated(
        itemCount: filteredUids.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final userId = filteredUids.elementAt(index);

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const ListTile(
                  leading: CircleAvatar(child: Text('...')),
                  title: Text('Đang tải...'),
                  subtitle: Text('...'),
                );
              }

              final userData =
                  userSnapshot.data?.data() as Map<String, dynamic>?;

              final name =
                  userData?['fullName'] as String? ?? 'Sinh viên ${index + 1}';
              final email =
                  userData?['email'] as String? ??
                  'sv${index + 1}@university.edu.vn';

              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(name),
                subtitle: Text(email),
                trailing: warning
                    ? const Icon(Icons.warning, color: Colors.orange)
                    : const Icon(Icons.check_circle, color: Colors.green),
              );
            },
          );
        },
      );
    }
  }
}
