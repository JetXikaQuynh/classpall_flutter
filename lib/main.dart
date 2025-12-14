import 'package:flutter/material.dart';
import 'screens/fund/fund_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FundScreen(), // 👈 chạy thẳng màn hình này
    );
  }
}
