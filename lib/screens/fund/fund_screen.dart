import 'package:classpall_flutter/routes/app_routes.dart';
import 'package:classpall_flutter/widgets/custom_bottom_bar.dart';
import 'package:flutter/material.dart';

class FundScreen extends StatefulWidget {
  const FundScreen({super.key});

  @override
  State<FundScreen> createState() => _TongQuanScreenState();
}

class _TongQuanScreenState extends State<FundScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Tổng quan – Khoản thu – Sổ chi
      child: Scaffold(
        backgroundColor: const Color(0xFFEFF6FB),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("Quản lý quỹ lớp"),
          bottom: TabBar(
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.green,
            onTap: (index) {
              if (index == 0) {
                // đang ở Tổng quan → không làm gì
                return;
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
              _buildRecentCollectionCard(),
              const SizedBox(height: 12),
              _buildUnpaidListCard(),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomBar(
          currentIndex: 0,
        ),
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

  // ================= RECENT COLLECTION =================

  Widget _buildRecentCollectionCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3B0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tình hình thu nộp gần đây",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Các khoản thu đang hoạt động",
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 12),
          _buildProgressItem(
            title: "Quỹ lớp học kỳ 1",
            progress: 0.6,
            text: "Đã nộp: 6/10",
          ),
          const SizedBox(height: 10),
          _buildProgressItem(
            title: "Áo đồng phục lớp",
            progress: 0.4,
            text: "Đã nộp: 4/10",
          ),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              onPressed: () {},
              child: const Text("Xem tất cả khoản thu"),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProgressItem({
    required String title,
    required double progress,
    required String text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(text),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          minHeight: 8,
          backgroundColor: Colors.grey.shade300,
          valueColor: const AlwaysStoppedAnimation(Colors.blue),
        ),
      ],
    );
  }

  // ================= UNPAID LIST =================

  Widget _buildUnpaidListCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3B0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 6),
              Text(
                "Danh sách chưa hoàn thành",
                style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text("Cần nhắc nhở nộp tiền • 10 tài khoản chưa nộp"),
          const SizedBox(height: 10),

          SizedBox(
            height: 220,
            child: ListView.separated(
              itemCount: unpaidMembers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final m = unpaidMembers[index];
                return _buildUnpaidRow(m);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildUnpaidRow(UnpaidMember m) {
    return Container(
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
                backgroundColor: Colors.teal,
                child: Text(
                  m.initials,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Text(m.name),
            ],
          ),
          Text(
            m.amount,
            style: const TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold),
          ),
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

class UnpaidMember {
  final String name;
  final String initials;
  final String amount;

  const UnpaidMember({
    required this.name,
    required this.initials,
    required this.amount,
  });
}

const unpaidMembers = [
  UnpaidMember(name: "Lê Hoàng Cường", initials: "LC", amount: "250.000đ"),
  UnpaidMember(name: "Phạm Minh Duy", initials: "PD", amount: "150.000đ"),
  UnpaidMember(name: "Hoàng Thị Minh", initials: "HM", amount: "100.000đ"),
  UnpaidMember(name: "Vũ Văn Giang", initials: "VG", amount: "150.000đ"),
  UnpaidMember(name: "Ngô Quang Huy", initials: "NH", amount: "150.000đ"),
  UnpaidMember(name: "Đặng Thu Hà", initials: "ĐH", amount: "100.000"),
  UnpaidMember(name: "Vũ Đức Long", initials: "VL", amount: "150.000"),
  UnpaidMember(name: "Phan Thảo My", initials: "PM", amount: "250.000"),
];
