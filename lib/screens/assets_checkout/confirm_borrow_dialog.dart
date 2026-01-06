import 'package:flutter/material.dart';

class ConfirmBorrowDialog extends StatelessWidget {
  final String assetName;

  const ConfirmBorrowDialog({
    super.key,
    required this.assetName,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Xác nhận mượn $assetName'),
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
