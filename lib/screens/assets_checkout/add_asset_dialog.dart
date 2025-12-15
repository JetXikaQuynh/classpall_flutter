import 'package:flutter/material.dart';

class AddAssetDialog extends StatefulWidget {
  const AddAssetDialog({super.key});

  @override
  State<AddAssetDialog> createState() => _AddAssetDialogState();
}

class _AddAssetDialogState extends State<AddAssetDialog> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thêm tài sản mới'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Tên tài sản',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () =>
              Navigator.pop(context, controller.text.trim()),
          child: const Text('Thêm'),
        ),
      ],
    );
  }
}
