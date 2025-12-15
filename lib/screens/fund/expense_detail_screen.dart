import 'package:flutter/material.dart';

class ExpenseDetailScreen extends StatelessWidget {
  const ExpenseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sổ ghi chép chi tiêu')),
      body: ListView(
        children: const [
          ListTile(
            title: Text('In tài liệu'),
            trailing: Text('-120.000đ'),
          ),
          ListTile(
            title: Text('Mua nước'),
            trailing: Text('-80.000đ'),
          ),
        ],
      ),
    );
  }
}
