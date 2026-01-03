import 'package:flutter/material.dart';

import '../../services/fund_services/fund_member_service.dart';
import '../../services/fund_services/fund_expense_service.dart';
import '../../services/fund_services/fund_collection_service.dart';
import '../../models/fund_models/fund_member_model.dart';
import '../../models/fund_models/fund_expense_model.dart';
import '../../models/fund_models/fund_collection_model.dart';

// 2 màn hình tab riêng
// Alias để tránh trùng tên với model FundCollection
import 'fund_collection_screen.dart' as collection_screen;
import 'expense_screen.dart';

class FundScreen extends StatefulWidget {
  const FundScreen({super.key});

  @override
  State<FundScreen> createState() => _FundScreenState();
}

class _FundScreenState extends State<FundScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _memberService = FundMemberService();
  final _expenseService = FundExpenseService();
  final _collectionService = FundCollectionService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          'Quản lý quỹ lớp',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: 'Tổng quan'),
            Tab(text: 'Khoản thu'),
            Tab(text: 'Sổ chi'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _overviewTab(),
          collection_screen.FundCollectionScreen(),
          const ExpenseScreen(),
        ],
      ),
    );
  }

  // =====================================================
  // TAB 1: TỔNG QUAN
  // =====================================================

  Widget _overviewTab() {
    return StreamBuilder<List<FundMember>>(
      stream: _memberService.getMembersByCollectionALL(),
      builder: (context, memberSnap) {
        if (memberSnap.hasError) {
          return Center(child: Text('Lỗi: ${memberSnap.error}'));
        }
        if (!memberSnap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final members = memberSnap.data!;
        final paidMembers = members.where((m) => m.paid).toList();
        final unpaidMembers = members.where((m) => !m.paid).toList();

        final totalIncome =
            paidMembers.fold<int>(0, (sum, m) => sum + m.amount);

        return StreamBuilder<List<FundExpense>>(
          stream: _expenseService.getExpenses(),
          builder: (context, expenseSnap) {
            if (expenseSnap.hasError) {
              return Center(child: Text('Lỗi: ${expenseSnap.error}'));
            }
            if (!expenseSnap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final expenses = expenseSnap.data!;
            final totalExpense =
                expenses.fold<int>(0, (sum, e) => sum + e.amount);

            final balance = totalIncome - totalExpense;

            return StreamBuilder<List<FundCollection>>(
              stream: _collectionService.getCollections(),
              builder: (context, collectionSnap) {
                if (collectionSnap.hasError) {
                  return Center(child: Text('Lỗi: ${collectionSnap.error}'));
                }
                if (!collectionSnap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final collections = collectionSnap.data!;
                // Lấy các collection gần đây (ví dụ 3 cái mới nhất)
                final recentCollections = collections.take(3).toList();

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
                      
                      _recentCollections(recentCollections, members),
                      
                      const SizedBox(height: 16),
                      _unpaidList(unpaidMembers),
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

  // =====================================================
  // UI WIDGETS
  // =====================================================

  Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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

  Widget _recentCollections(List<FundCollection> collections, List<FundMember> members) {
    if (collections.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3C4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tình hình thu nộp gần đây',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Chưa có khoản thu nào'),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3C4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tình hình thu nộp gần đây',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Các khoản thu đang hoạt động'),
          const SizedBox(height: 12),

          ...collections.map(
            (c) => _collectionProgressItem(c, members),
          ),

          const SizedBox(height: 12),
          Center(
            child: OutlinedButton(
              onPressed: () {
                // Chuyển sang tab Khoản thu
                _tabController.animateTo(1);
              },
              child: const Text('Xem tất cả khoản thu'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _collectionProgressItem(
    FundCollection c,
    List<FundMember> members,
  ) {
    final collectionMembers =
        members.where((m) => m.collectionId == c.id).toList();

    final paidCount = collectionMembers.where((m) => m.paid).length;

    final totalMembers = collectionMembers.length;

    final percent = totalMembers == 0 ? 0.0 : paidCount / totalMembers;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                c.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text('Đã nộp: $paidCount/$totalMembers'),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: percent,
            minHeight: 8,
            backgroundColor: Colors.grey.shade300,
            color: Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _unpaidList(List<FundMember> unpaidMembers) {
    if (unpaidMembers.isEmpty) {
      return Card(
        color: const Color(0xFFEAF6FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text(
                'Tất cả sinh viên đã hoàn thành đóng quỹ',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      color: const Color(0xFFFFEAEA),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Danh sách chưa đóng quỹ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            ...unpaidMembers.map(
              (m) => Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.red.shade200,
                          child: Text(
                            m.userName.isNotEmpty ? m.userName[0] : '?',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(m.userName),
                      ],
                    ),
                    Text(
                      '${m.amount} đ',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
