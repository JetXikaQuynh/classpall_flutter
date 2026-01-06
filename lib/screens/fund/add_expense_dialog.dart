import 'package:flutter/material.dart';
import '../../services/fund_services/fund_expense_service.dart';

class AddExpenseDialog extends StatefulWidget {
  final String createdBy;

  const AddExpenseDialog({
    super.key,
    required this.createdBy,
  });

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ghi khoản chi'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tên khoản chi
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Tên khoản chi',
              ),
            ),

            const SizedBox(height: 8),

            // Số tiền
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Số tiền',
              ),
            ),

            const SizedBox(height: 8),

            // Ghi chú
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Ghi chú (không bắt buộc)',
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Text('Lưu'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    final amount = int.tryParse(_amountController.text.trim());
    final note = _noteController.text.trim();

    if (title.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập tên khoản chi và số tiền hợp lệ'),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await FundExpenseService().addExpense(
        title: title,
        amount: amount,
        note: note,
        createdBy: widget.createdBy,
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
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
