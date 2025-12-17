import 'package:classpall_flutter/widgets/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:classpall_flutter/routes/app_routes.dart';
import 'package:classpall_flutter/screens/fund/add_expense_dialog.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _SoChiScreenState();
}

class _SoChiScreenState extends State<ExpenseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void _showAddExpenseDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // bấm ngoài không tắt (tuỳ bạn)
      builder: (_) => const AddExpenseDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FB),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Quản lý quỹ lớp"),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.black54,
          indicatorColor: Colors.green,
          onTap: (index) {
            if (index == 0) {
              Navigator.of(context, rootNavigator: true)
                  .pushReplacementNamed(AppRoutes.fund);
            } else if (index == 1) {
              Navigator.of(context, rootNavigator: true)
                  .pushReplacementNamed(AppRoutes.fundCollection);
            } else if (index == 2) {
              Navigator.of(context, rootNavigator: true)
                  .pushReplacementNamed(AppRoutes.expense);
            }
          },
          tabs: const [
            Tab(text: "Tổng quan"),
            Tab(text: "Khoản thu"),
            Tab(text: "Sổ chi"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildSummaryCard(),
            const SizedBox(height: 12),
            _buildAddExpenseButton(),
            const SizedBox(height: 12),
            _buildExpenseLog(),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 0,
      ),
    );
  }

  // ================= SUMMARY =================

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: const [
          SummaryRow(
            icon: Icons.account_balance_wallet,
            title: "Tổng quỹ hiện có",
            value: "680.000 đ",
            color: Colors.blue,
          ),
          Divider(),
          SummaryRow(
            icon: Icons.check_circle,
            title: "Tổng thu (Đã nộp)",
            value: "1.200.000 đ",
            color: Colors.green,
          ),
          Divider(),
          SummaryRow(
            icon: Icons.shopping_cart,
            title: "Tổng chi tiêu",
            value: "520.000 đ",
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  // ================= ADD EXPENSE =================

  Widget _buildAddExpenseButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        onPressed: () {
          _showAddExpenseDialog(context);
        },
        icon: const Icon(Icons.edit),
        label: const Text("Ghi khoản chi"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  // ================= EXPENSE LOG =================

  Widget _buildExpenseLog() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3B0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sổ ghi chép chi tiêu",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Lịch sử chi tiêu công khai của lớp",
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
              Text(
                "Tổng chi\n520.000đ",
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Table header
          _buildTableHeader(),

          const Divider(height: 1),

          // List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: expenses.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _buildExpenseRow(expenses[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text("Ngày")),
          Expanded(flex: 4, child: Text("Nội dung")),
          Expanded(
            flex: 2,
            child: Text("Số tiền", textAlign: TextAlign.right),
          ),
          SizedBox(width: 30),
          Expanded(flex: 2, child: Text("Đính kèm")),
        ],
      ),
    );
  }

  Widget _buildExpenseRow(Expense e) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(e.date)),
          Expanded(flex: 4, child: Text(e.content)),
          Expanded(
            flex: 2,
            child: Text(
              e.amount,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.image, size: 20),
          )
        ],
      ),
    );
  }
}

// ================= MODELS =================

class SummaryRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const SummaryRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 10),
        Expanded(child: Text(title)),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}

class Expense {
  final String date;
  final String content;
  final String amount;

  const Expense({
    required this.date,
    required this.content,
    required this.amount,
  });
}

const expenses = [
  Expense(
      date: "10/09/2025",
      content: "Photo tài liệu môn toán",
      amount: "50.000đ"),
  Expense(
      date: "20/10/2025",
      content: "Hoa chúc mừng 20/11",
      amount: "350.000đ"),
  Expense(
      date: "25/11/2025",
      content: "Uống nước dã ngoại",
      amount: "120.000đ"),
];
