import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart'; 

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    // === Bọc toàn bộ build trong ValueListenableBuilder để lắng nghe role ===
    return ValueListenableBuilder<bool?>(
      valueListenable: AuthService.isAdminNotifier,
      builder: (context, isAdmin, child) {
        if (isAdmin == null) {
          return const SizedBox(height: 70); // tránh layout nhảy khi chưa tải role
        }

        final String homeRoute = isAdmin
            ? AppRoutes.adminDashboard
            : AppRoutes.memberDashboard;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIcon(context, Icons.home_outlined, 0, homeRoute),
              _buildIcon(
                context,
                Icons.notifications_outlined,
                1,
                AppRoutes.notification,
              ),
              _buildIcon(
                context,
                Icons.person_outline,
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
    IconData icon,
    int index,
    String route, {
    int badge = 0,
  }) {
    return GestureDetector(
      onTap: () {
        if (currentIndex != index) {
          // === Dùng pushNamedAndRemoveUntil để reset stack về dashboard đúng role ===
          Navigator.pushNamedAndRemoveUntil(
            context,
            route,
            ModalRoute.withName(AuthService.isAdmin ? AppRoutes.adminDashboard : AppRoutes.memberDashboard),
          );
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            icon,
            size: 32,
            color: currentIndex == index ? Colors.blue : Colors.grey,
          ),
          if (badge > 0)
            Positioned(
              right: -6,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "$badge",
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
        ],
      ),
    );
  }
}