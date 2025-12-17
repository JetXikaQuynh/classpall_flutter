import 'package:flutter/material.dart';
import 'screens/dashboard/admin_dashboard.dart';
import 'app.dart';

void main() {
  runApp(const App());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminDashboard(), // 👈 chạy thẳng màn hình này
    );
  }
}
