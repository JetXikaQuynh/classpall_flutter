import 'package:flutter/material.dart';
import '../../services/fund_services/fund_expense_service.dart';
import '../../services/fund_services/fund_member_service.dart';
import '../../models/fund_models/fund_expense_model.dart';
import 'add_expense_dialog.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseService = FundExpenseService();
    final memberService = FundMemberService();

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // ===== SUMMARY =====
        StreamBuilder<int>(
          stream: expenseService.getTotalExpense(),
          builder: (context, snapExpense) {
            final totalExpense = snapExpense.data ?? 0;

            return StreamBuilder<List>(
              stream: memberService.getAllMembers(),
              builder: (context, snapMembers) {
                final members = snapMembers.data ?? [];
                final totalIncome = members
                    .where((m) => m.paid == true)
                    .fold<num>(0, (sum, m) => sum + m.amount);

                final currentFund = totalIncome - totalExpense;

                return Column(
                  children: [
                    _summaryCard(
                      icon: Icons.account_balance_wallet,
                      title: 'Tổng quỹ hiện có',
                      value: '${currentFund.toString()} đ',
                      color: Colors.blue,
                    ),
                    _summaryCard(
                      icon: Icons.trending_up,
                      title: 'Tổng thu (đã nộp)',
                      value: '${totalIncome.toString()} đ',
                      color: Colors.green,
                    ),
                    _summaryCard(
                      icon: Icons.trending_down,
                      title: 'Tổng chi tiêu',
                      value: '${totalExpense.toString()} đ',
                      color: Colors.red,
                    ),
                  ],
                );
              },
            );
          },
        ),

        const SizedBox(height: 12),

        // ===== BUTTON GHI KHOẢN CHI =====
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text('Ghi khoản chi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2F80ED),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const AddExpenseDialog(
                  createdBy: 'admin',
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // ===== SỔ CHI =====
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3C4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sổ ghi chép chi tiêu',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Lịch sử chi tiêu công khai của lớp',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 12),

              StreamBuilder<List<FundExpense>>(
                stream: expenseService.getExpenses(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  final expenses = snapshot.data!;

                  if (expenses.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Chưa có khoản chi nào',
                        style: TextStyle(color: Colors.black54),
                      ),
                    );
                  }

                  return Column(
                    children: expenses.map((e) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(e.title),
                            subtitle: Text(e.note),
                            trailing: Text(
                              '- ${e.amount} đ',
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===== SUMMARY CARD =====
  Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        trailing: Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
