import 'package:flutter/material.dart';

// Auth + Dashboard ===
import 'package:classpall_flutter/screens/splash/splash_screen.dart';
import 'package:classpall_flutter/screens/auth/login_page.dart';
import 'package:classpall_flutter/screens/dashboard/admin_dashboard.dart';
import 'package:classpall_flutter/screens/dashboard/member_dashboard.dart';
// Duty screens
import 'package:classpall_flutter/screens/duty/admin_dashboard_duty.dart';
import 'package:classpall_flutter/screens/duty/member_dashboard_duty.dart';
import 'package:classpall_flutter/screens/duty/create_duty_screen.dart';
import 'package:classpall_flutter/screens/duty/duty_detail_screen.dart';
import 'package:classpall_flutter/screens/duty/leaderboard_screen.dart';

// Profile screens
import 'package:classpall_flutter/screens/profile/personal_profile_screen.dart';
import 'package:classpall_flutter/screens/profile/edit_profile_screen.dart';
import 'package:classpall_flutter/screens/profile/permission_screen.dart';

// Dialogs
import 'package:classpall_flutter/screens/duty/confirm_duty_dialog.dart';
import 'package:classpall_flutter/screens/profile/add_team_dialog.dart';
import 'package:classpall_flutter/screens/profile/delete_team_dialog.dart';

import 'app_routes.dart';

class AppPages {
  static final Map<String, WidgetBuilder> routes = {
    // Home (tạm thời dùng splash, sau merge team sẽ có home thật)
    AppRoutes.home: (_) => const SplashScreen(),

    //
    AppRoutes.splash: (_) => const SplashScreen(),
    AppRoutes.login: (_) => const LoginScreen(),
    AppRoutes.adminDashboard: (_) => const AdminDashboard(),
    AppRoutes.memberDashboard: (_) => const MemberDashboard(),
    // Duty
    AppRoutes.adminDashboardDuty: (_) => const AdminDashboardDuty(),
    AppRoutes.memberDashboardDuty: (_) => const MemberDashboardDuty(),
    AppRoutes.createDuty: (_) => const CreateDutyScreen(),
    AppRoutes.dutyDetail: (_) => const DutyDetailScreen(),
    AppRoutes.leaderboard: (_) => const LeaderboardScreen(),

    // Profile
    AppRoutes.personalProfile: (_) => const PersonalProfileScreen(),
    AppRoutes.editProfile: (_) => const EditProfileScreen(),
    AppRoutes.permission: (_) => const PermissionScreen(),
  };
}
