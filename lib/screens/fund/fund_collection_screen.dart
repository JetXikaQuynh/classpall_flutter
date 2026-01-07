import 'package:flutter/material.dart';

import '../../services/fund_services/fund_collection_service.dart';
import '../../services/fund_services/fund_member_service.dart';
import '../../services/fund_services/fund_expense_service.dart';

import '../../models/fund_models/fund_collection_model.dart';
import '../../models/fund_models/fund_member_model.dart';
import '../../models/fund_models/fund_expense_model.dart';

import 'add_income_dialog.dart';

class FundCollectionScreen extends StatelessWidget {
  final bool role;

  FundCollectionScreen({
    super.key,
    required this.role,
  });

  final _collectionService = FundCollectionService();
  final _memberService = FundMemberService();
  final _expenseService = FundExpenseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FundCollection>>(
      stream: _collectionService.getCollections(),
      builder: (context, colSnap) {
        if (!colSnap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final collections = colSnap.data!;

        return StreamBuilder<List<FundMember>>(
          stream: _memberService.getAllMembers(),
          builder: (context, memSnap) {
            if (!memSnap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final members = memSnap.data!;

            return StreamBuilder<List<FundExpense>>(
              stream: _expenseService.getExpenses(),
              builder: (context, expSnap) {
                if (!expSnap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final expenses = expSnap.data!;

                /// ===== TÍNH TOÁN =====
                final totalIncome = members
                    .where((m) => m.paid)
                    .fold<int>(0, (sum, m) => sum + m.amount);

                final totalExpense = expenses
                    .fold<int>(0, (sum, e) => sum + e.amount);

                final balance = totalIncome - totalExpense;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      _summaryCard(
                        icon: Icons.account_balance_wallet,
                        title: 'Tổng quỹ hiện có',
                        value: '$balance đ',
                        color: Colors.blue,
                      ),
                      _summaryCard(
                        icon: Icons.trending_up,
                        title: 'Tổng thu (đã nộp)',
                        value: '$totalIncome đ',
                        color: Colors.green,
                      ),
                      _summaryCard(
                        icon: Icons.trending_down,
                        title: 'Tổng chi tiêu',
                        value: '$totalExpense đ',
                        color: Colors.red,
                      ),

                      const SizedBox(height: 12),

                      /// ===== NÚT TẠO KHOẢN THU =====
                      if (role)
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text('Tạo khoản thu'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2F80ED),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => const AddIncomeDialog(
                                  teamId: "team02",
                                ),
                              );
                            },
                          ),
                        ),

                      const SizedBox(height: 12),

                      /// ===== DANH SÁCH KHOẢN THU =====
                      if (collections.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Chưa có khoản thu nào',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),

                      ...collections.map(
                            (c) => _collectionCard(c, members),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  /// ================= CARD TỔNG QUAN =================
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
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  /// ================= CARD KHOẢN THU =================
  Widget _collectionCard(
      FundCollection collection,
      List<FundMember> members,
      ) {
    final collectionMembers =
    members.where((m) => m.collectionId == collection.id).toList();

    return Card(
      color: const Color(0xFFFFF3C4),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  collection.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${collection.amountPerUser * collectionMembers.where((m) => m.paid).length}đ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text('${collection.amountPerUser}đ / người'),

            const Divider(),

            /// DANH SÁCH SINH VIÊN
            ...collectionMembers.map(
                  (m) => _memberItem(m),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= ITEM SINH VIÊN =================
  Widget _memberItem(FundMember m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(m.userName),
          GestureDetector(
            onTap: (!role || m.paid)
                ? null
                : () => _memberService.markAsPaid(m.id),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: m.paid ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                m.paid ? 'Đã nộp' : 'Chưa nộp',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
