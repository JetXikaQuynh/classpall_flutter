import 'package:flutter/material.dart';

class AddExpenseDialog extends StatelessWidget {
  const AddExpenseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thêm khoản chi mới'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          TextField(decoration: InputDecoration(labelText: 'Ngày')),
          TextField(decoration: InputDecoration(labelText: 'Số tiền')),
          TextField(decoration: InputDecoration(labelText: 'Ghi chú')),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Thêm'),
        ),
      ],
    );
  }
}
