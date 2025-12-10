import 'package:classpall_flutter/screens/duty/create_duty_screen.dart';
import 'package:classpall_flutter/screens/duty/duty_detail_screen.dart';
import 'package:classpall_flutter/screens/duty/leaderboard_screen.dart';
import 'package:classpall_flutter/screens/duty/member_dashboard_duty.dart';
import 'package:classpall_flutter/screens/profile/personal_profile_screen.dart';
import 'package:flutter/material.dart';
import 'screens/duty/admin_dashboard_duty.dart';
import 'screens/profile/edit_profile_screen.dart';

///
import 'app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PersonalProfileScreen(),
    );
  }
}
