import 'package:flutter/material.dart';
import 'package:classpall_flutter/screens/splash/splash_screen.dart';
import 'package:classpall_flutter/screens/auth/login_page.dart';
// THÊM 2 DÒNG NÀY
import 'package:classpall_flutter/screens/dashboard/admin_dashboard.dart';
import 'package:classpall_flutter/screens/dashboard/member_dashboard.dart';

class ClassPalApp extends StatelessWidget {
  const ClassPalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class Pal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          // THÊM 2 CASE NÀY
          case '/admin_dashboard':
            return MaterialPageRoute(builder: (_) => const AdminDashboard());
          case '/member_dashboard':
            return MaterialPageRoute(builder: (_) => const MemberDashboard());
          default:
            return MaterialPageRoute(builder: (_) => const SplashScreen());
        }
      },
    );
  }
}