import 'package:flutter/material.dart';

class ConfirmBorrowDialog extends StatelessWidget {
  const ConfirmBorrowDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Xác nhận mượn chia khóa tủ bảng'),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Xác nhận'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Hủy'),
        ),
      ],
    );
  }
}
