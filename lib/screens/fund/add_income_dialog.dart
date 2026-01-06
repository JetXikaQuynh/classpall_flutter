import 'package:flutter/material.dart';
import '../../services/fund_services/fund_collection_service.dart';
import '../../services/fund_services/fund_member_service.dart';
import '../../services/user_service.dart';
import '../../models/user_model.dart';

class AddIncomeDialog extends StatefulWidget {
  final String teamId;

  const AddIncomeDialog({
    super.key,
    required this.teamId,
  });

  @override
  State<AddIncomeDialog> createState() => _AddIncomeDialogState();
}

class _AddIncomeDialogState extends State<AddIncomeDialog> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tạo khoản thu mới'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Tên khoản thu'),
          ),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Số tiền mỗi người'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _createCollection,
          child: _loading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Text('Tạo khoản thu'),
        ),
      ],
    );
  }

  Future<void> _createCollection() async {
    final title = _titleController.text.trim();
    final amount = int.tryParse(_amountController.text.trim());
    final List<UserModel> users =
    await UserService().getAllUsers();

    if (title.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      // 1. Tạo khoản thu
      final collectionId = await FundCollectionService().createCollection(
        title: title,
        amountPerUser: amount,
        teamId: widget.teamId,
        createdBy: 'admin', // sau này thay bằng userId thật
      );

      // 3. Tạo fund_members cho tất cả sinh viên
      await FundMemberService().createMembersForCollection(
        collectionId: collectionId,
        users: users,
        amount: amount,
      );
      Navigator.pop(context); // đóng dialog
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }
}
