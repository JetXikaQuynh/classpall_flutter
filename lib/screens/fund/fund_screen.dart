import 'package:flutter/material.dart';
import 'add_income_dialog.dart';
import 'add_expense_dialog.dart';

class FundScreen extends StatefulWidget {
  const FundScreen({super.key});

  @override
  State<FundScreen> createState() => _FundScreenState();
}

class _FundScreenState extends State<FundScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> students = [
    {'name': 'Nguyễn Văn An', 'paid': true},
    {'name': 'Trần Thị Bích', 'paid': true},
    {'name': 'Lê Hoàng Cường', 'paid': false},
    {'name': 'Phạm Minh Duy', 'paid': false},
    {'name': 'Hoàng Thị Minh', 'paid': true},
    {'name': 'Vũ Văn Giang', 'paid': false},
    {'name': 'Đỗ Thị Lan', 'paid': true},
    {'name': 'Nguyễn Quốc Huy', 'paid': false},
    {'name': 'Bùi Minh Tuấn', 'paid': true},
    {'name': 'Phan Thị Ngọc', 'paid': false},
  ];

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
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Quản lý quỹ lớp',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
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
          _incomeTab(),
          _expenseTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }

  // ================= TỔNG QUAN =================

  Widget _overviewTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _summaryCard(Icons.account_balance_wallet, 'Tổng quỹ hiện có',
            '680.000đ', Colors.blue),
        _summaryCard(Icons.trending_up, 'Tổng thu (đã nộp)', '1.200.000đ',
            Colors.green),
        _summaryCard(Icons.trending_down, 'Tổng chi tiêu', '520.000đ',
            Colors.red),
        const SizedBox(height: 12),
        _recentStatus(),
        const SizedBox(height: 12),
        _unpaidList(),
      ],
    );
  }

  Widget _recentStatus() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3C4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tình hình thu nộp gần đây',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Quỹ lớp học kỳ 1: Đã nộp 6/10'),
          LinearProgressIndicator(value: 0.6),
          SizedBox(height: 8),
          Text('Áo đồng phục lớp: Đã nộp 4/10'),
          LinearProgressIndicator(value: 0.4),
        ],
      ),
    );
  }

  Widget _unpaidList() {
    final unpaid = students.where((e) => !e['paid']).toList();

    return Card(
      color: const Color(0xFFFFEAEA),
      child: Column(
        children: [
          const ListTile(
            title: Text(
              'Danh sách chưa hoàn thành',
              style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            subtitle: Text('Cần nhắc nhở nộp tiền'),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: unpaid.length,
              itemBuilder: (_, i) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red.shade100,
                    child: Text(unpaid[i]['name'][0]),
                  ),
                  title: Text(unpaid[i]['name']),
                  trailing: const Text(
                    '150.000đ',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= KHOẢN THU =================

  Widget _incomeTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Tạo khoản thu'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const AddIncomeDialog(),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        _incomeGroup('Quỹ lớp học kỳ 1', '600.000đ'),
        _incomeGroup('Áo đồng phục lớp', '600.000đ'),
      ],
    );
  }

  Widget _incomeGroup(String title, String amount) {
    return Card(
      color: const Color(0xFFFFF3C4),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          ListTile(
            title: Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('100.000đ / người'),
            trailing: Text(amount,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 250,
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (_, i) {
                final s = students[i];
                return ListTile(
                  leading: CircleAvatar(child: Text(s['name'][0])),
                  title: Text(s['name']),
                  trailing: Chip(
                    label: Text(s['paid'] ? 'Đã nộp' : 'Chưa nộp'),
                    backgroundColor: s['paid']
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= SỔ CHI =================

  Widget _expenseTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _summaryCard(Icons.account_balance_wallet, 'Tổng quỹ hiện có',
            '680.000 đ', Colors.blue),
        _summaryCard(Icons.trending_up, 'Tổng thu (đã nộp)',
            '1.200.000 đ', Colors.green),
        _summaryCard(Icons.trending_down, 'Tổng chi tiêu', '520.000 đ',
            Colors.red),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text('Ghi khoản chi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2F80ED),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const AddExpenseDialog(),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _expenseBook(),
      ],
    );
  }

  Widget _expenseBook() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3C4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Sổ ghi chép chi tiêu',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Tổng chi\n520.000đ',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          _expenseHeader(),
          const Divider(),
          _expenseRow(
              date: '10/09/2025',
              title: 'Photo tài liệu môn toán',
              amount: '50.000đ'),
          _expenseRow(
              date: '20/10/2025',
              title: 'Hoa chúc mừng 20/11',
              amount: '350.000đ'),
          _expenseRow(
              date: '25/11/2025',
              title: 'Uống nước dã ngoại',
              amount: '120.000đ'),
        ],
      ),
    );
  }

  // ================= COMMON =================

  Widget _summaryCard(
      IconData icon, String title, String value, Color color) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        trailing: Text(
          value,
          style:
          TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _expenseHeader() {
    return const Row(
      children: [
        Expanded(
          flex: 2,
          child:
          Text('Ngày', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 4,
          child: Text('Nội dung',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 2,
          child: Text('Số tiền',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        SizedBox(width: 28),
      ],
    );
  }

  Widget _expenseRow({
    required String date,
    required String title,
    required String amount,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(date)),
          Expanded(flex: 4, child: Text(title)),
          Expanded(
            flex: 2,
            child: Text(amount,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          const Icon(Icons.attach_file, size: 18),
        ],
      ),
    );
  }
}
