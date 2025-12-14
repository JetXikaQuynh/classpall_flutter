import 'package:flutter/material.dart';

// === PHẦN CỦA BẠN: Auth + Dashboard ===
import 'package:classpall_flutter/screens/splash/splash_screen.dart';
import 'package:classpall_flutter/screens/auth/login_page.dart';
import 'package:classpall_flutter/screens/dashboard/admin_dashboard.dart';
import 'package:classpall_flutter/screens/dashboard/member_dashboard.dart';

import 'app_routes.dart';

class AppPages {
  static final Map<String, WidgetBuilder> routes = {
    // Home (tạm thời dùng splash, sau merge team sẽ có home thật)
    AppRoutes.home: (_) => const SplashScreen(),

    // === PHẦN CỦA BẠN ===
    AppRoutes.splash: (_) => const SplashScreen(),
    AppRoutes.login: (_) => const LoginScreen(),
    AppRoutes.adminDashboard: (_) => const AdminDashboard(),
    AppRoutes.memberDashboard: (_) => const MemberDashboard(),
  };
}