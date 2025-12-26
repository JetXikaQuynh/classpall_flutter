import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../routes/app_routes.dart';
import '../services/auth_service.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool?>(
      valueListenable: AuthService.isAdminNotifier,
      builder: (context, isAdmin, child) {
        if (isAdmin == null) {
          return const SizedBox(height: 70);
        }

        final String homeRoute = isAdmin
            ? AppRoutes.adminDashboard
            : AppRoutes.memberDashboard;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIcon(
                context,
                const Icon(Icons.home_outlined, size: 32),
                0,
                homeRoute,
              ),

              _buildIcon(
                context,
                const NotificationBottomIcon(),
                1,
                AppRoutes.notification,
              ),

              _buildIcon(
                context,
                const Icon(Icons.person_outline, size: 32),
                2,
                AppRoutes.personalProfile,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIcon(
    BuildContext context,
    Widget iconWidget,
    int index,
    String route,
  ) {
    final color = currentIndex == index ? Colors.blue : Colors.grey;

    return GestureDetector(
      onTap: () {
        if (currentIndex != index) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            route,
            ModalRoute.withName(
              AuthService.isAdmin
                  ? AppRoutes.adminDashboard
                  : AppRoutes.memberDashboard,
            ),
          );
        }
      },
      child: IconTheme(
        data: IconThemeData(color: color),
        child: iconWidget,
      ),
    );
  }
}

/// ===============================
/// ICON THÔNG BÁO + BADGE CHƯA ĐỌC
/// ===============================
class NotificationBottomIcon extends StatelessWidget {
  const NotificationBottomIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Icon(Icons.notifications_outlined, size: 32);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notifications')
          .where('user_id', isEqualTo: user.uid)
          .where('is_read', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        final unreadCount = snapshot.data?.docs.length ?? 0;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.notifications_outlined, size: 32),

            if (unreadCount > 0)
              Positioned(
                right: -6,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      unreadCount > 9 ? '9+' : '$unreadCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
