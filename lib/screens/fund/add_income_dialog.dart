import 'package:flutter/material.dart';

class AddIncomeDialog extends StatelessWidget {
  const AddIncomeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tạo khoản thu mới'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          TextField(decoration: InputDecoration(labelText: 'Tên khoản thu')),
          TextField(decoration: InputDecoration(labelText: 'Số tiền mỗi người')),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tạo khoản thu'),
        ),
      ],
    );
  }
}
