import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
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
          _buildIcon(
            context,
            Icons.home_outlined,
            0,
            AppRoutes
                .adminDashboard, //tạm thời, sau thay bằng màn home dashboard
          ),
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
          Navigator.pushReplacementNamed(context, route);
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
