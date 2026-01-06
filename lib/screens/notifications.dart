import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/custom_bottom_bar.dart';
import '../routes/app_routes.dart';
import '../services/notification_service.dart';
import '../models/notification_model.dart';
import '../widgets/notification/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Chưa đăng nhập')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.blue.shade50,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Thông báo",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: const BackButton(color: Colors.black),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: NotificationService.instance
            .listenMyNotifications(user.uid),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Không có thông báo'));
          }

          final notifications = snapshot.data!.docs
              .map((e) => NotificationModel.fromDoc(e))
              .toList();

          final unreadCount =
              notifications.where((n) => !n.isRead).length;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              /// HEADER
              Row(
                children: [
                  const Icon(Icons.notifications, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    '$unreadCount thông báo chưa đọc',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              ...notifications.map((n) {
                return NotificationCard(
                  icon: _iconByType(n.type),
                  iconBg: Colors.blue.shade50,
                  title: n.title,
                  content: n.body,
                  time: _timeAgo(n.sentAt),
                  actionText: 'Xem chi tiết →',
                  isUnread: !n.isRead,
                  onTap: () async {
                    await NotificationService.instance.markAsRead(n.id);

                    if (n.type == 'event' || n.type == 'reminder') {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.memberEventList,
                        arguments: n.targetId,
                      );
                    }
                  },
                );
              }),
            ],
          );
        },
      ),

      bottomNavigationBar: const CustomBottomBar(currentIndex: 1),
    );
  }

  IconData _iconByType(String? type) {
    switch (type) {
      case 'event':
      case 'reminder':
        return Icons.calendar_today;
      case 'fund':
        return Icons.attach_money;
      default:
        return Icons.notifications;
    }
  }

  String _timeAgo(Timestamp ts) {
    final diff = DateTime.now().difference(ts.toDate());

    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }
}
