import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'routes/app_pages.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.adminDashboardDuty,
      routes: AppPages.routes,
    );
  }
}
