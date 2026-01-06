import 'package:flutter/material.dart';
import 'package:classpall_flutter/services/auth_service.dart'; 
import 'package:classpall_flutter/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp(); // 
  }


  Future<void> _initializeApp() async {
    
    await Future.delayed(const Duration(seconds: 2));

    // Khởi tạo role nếu đã đăng nhập
    await AuthService.initialize();

    if (!mounted) return;

    final user = AuthService.currentUser;
    if (user != null) {
      final isAdmin = AuthService.isAdmin;
      Navigator.pushReplacementNamed(
        context,
        isAdmin ? AppRoutes.adminDashboard : AppRoutes.memberDashboard,
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.school_rounded, size: 80, color: Color(0xFF1976D2)),
              SizedBox(height: 20),
              Text(
                "Class Pal",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                ),
              ),
              SizedBox(height: 10),
              CircularProgressIndicator(color: Color(0xFF1976D2)),
            ],
          ),
        ),
      ),
    );
  }
}