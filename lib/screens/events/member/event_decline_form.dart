import 'package:flutter/material.dart';

Future<void> showRequiredEventDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Sự kiện bắt buộc'),
      content: const Text(
        'Đây là sự kiện bắt buộc.\n'
        'Bạn không thể từ chối tham gia.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Đã hiểu'),
          
        ),
      ],
    ),
  );
}
