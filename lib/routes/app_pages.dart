import 'package:flutter/material.dart';

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

import 'app_routes.dart';

class AppPages {
  static final Map<String, WidgetBuilder> routes = {
    // Home
    AppRoutes.home: (_) => const AdminDashboardDuty(), // tạm thời
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
