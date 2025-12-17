import 'package:classpall_flutter/screens/fund/expense_screen.dart';
import 'package:classpall_flutter/screens/fund/fund_collection_screen.dart';
import 'package:classpall_flutter/screens/fund/fund_screen.dart';
import 'package:flutter/material.dart';

// Assets_checkout
import 'package:classpall_flutter/screens/assets_checkout/asset_history_screen.dart';
import 'package:classpall_flutter/screens/assets_checkout/asset_screen.dart';
// Auth + Dashboard ===
import 'package:classpall_flutter/screens/splash/splash_screen.dart';
import 'package:classpall_flutter/screens/auth/login_page.dart';
import 'package:classpall_flutter/screens/dashboard/admin_dashboard.dart';
import 'package:classpall_flutter/screens/dashboard/member_dashboard.dart';

// Event - Admin
import 'package:classpall_flutter/screens/events/admin/event_list_page.dart';
import 'package:classpall_flutter/screens/events/admin/event_detail_page.dart';

// Event - Member
import 'package:classpall_flutter/screens/events/member/member_event_list_page.dart';

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

//Notification
import 'package:classpall_flutter/screens/notifications.dart';

import 'app_routes.dart';

class AppPages {
  static final Map<String, WidgetBuilder> routes = {
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

    // ================= EVENT MODULE =================
    // Admin
    AppRoutes.adminEventList: (_) => const EventListPage(),
    AppRoutes.adminEventDetail: (_) => const EventDetailPage(),

    // Member
    AppRoutes.memberEventList: (_) => const MemberEventListPage(),
    AppRoutes.memberEventDetail: (_) => const MemberEventDetailPage(),

    // =========== Fund ==============
    AppRoutes.fund: (_) => const FundScreen(),
    AppRoutes.fundCollection: (_) => const FundCollection(),
    AppRoutes.expense: (_) => const ExpenseScreen(),


    //Notification
    AppRoutes.notification: (_) => const NotificationsScreen(),

    //Assets
    AppRoutes.assetHistory: (_) => const AssetHistoryScreen(),
    AppRoutes.assets: (_) => const AssetsScreen(),
  };
}
