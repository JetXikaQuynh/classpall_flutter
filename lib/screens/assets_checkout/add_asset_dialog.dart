import 'package:classpall_flutter/services/assets_services/asset_service.dart';
import 'package:flutter/material.dart';

class AddAssetDialog extends StatefulWidget {
  const AddAssetDialog({super.key});

  @override
  State<AddAssetDialog> createState() => _AddAssetDialogState();
}

class _AddAssetDialogState extends State<AddAssetDialog> {
  final controller = TextEditingController();
  final service = AssetService();

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
          child: const Text('Thêm'),
          onPressed: () async {
            if (controller.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tên tài sản không được để trống')),
              );
              return;
            }

            await service.addAsset(controller.text.trim());
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
