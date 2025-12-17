import 'package:classpall_flutter/widgets/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:classpall_flutter/routes/app_routes.dart';
import 'package:classpall_flutter/screens/fund/add_income_dialog.dart';

class FundCollection extends StatefulWidget {
  const FundCollection({super.key});

  @override
  State<FundCollection> createState() => _KhoanThuScreenState();
}

class _KhoanThuScreenState extends State<FundCollection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void _showAddIncomeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // bấm ngoài không tắt (tuỳ bạn)
      builder: (_) => const AddIncomeDialog(),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }
        ),
        title: const Text("Quản lý quỹ lớp"),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.grey,
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
            _buildAddIncomeButton(context),
            const SizedBox(height: 12),
            _buildFundCard(
              title: "Quỹ lớp học kỳ 1",
              subtitle: "100.000đ/người",
              total: "600.000đ",
              members: membersHK1,
            ),
            const SizedBox(height: 12),
            _buildFundCard(
              title: "Áo đồng phục lớp",
              subtitle: "150.000đ/người",
              total: "600.000đ",
              members: membersUniform,
            ),
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
            value: "680.000đ",
            color: Colors.blue,
          ),
          Divider(),
          SummaryRow(
            icon: Icons.check_circle,
            title: "Tổng thu (Đã nộp)",
            value: "1.200.000đ",
            color: Colors.green,
          ),
          Divider(),
          SummaryRow(
            icon: Icons.shopping_cart,
            title: "Tổng chi tiêu",
            value: "520.000đ",
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  // ================= Add Fund ================
  Widget _buildAddIncomeButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        onPressed: () {
          _showAddIncomeDialog(context);
        },
        icon: const Icon(Icons.add),
        label: const Text("Tạo khoản thu"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  // ================= FUND CARD =================

  Widget _buildFundCard({
    required String title,
    required String subtitle,
    required String total,
    required List<Member> members,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(subtitle,
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
              Text(
                total,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.orange),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Search
          TextField(
            decoration: InputDecoration(
              hintText: "Tìm kiếm sinh viên...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFF3F4F6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // MEMBER LIST (SCROLL)
          SizedBox(
            height: 240,
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.separated(
                itemCount: members.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (context, index) {
                  return _buildMemberRow(members[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= MEMBER ROW =================

  Widget _buildMemberRow(Member member) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: member.paid
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(member.name),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: member.paid ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              member.paid ? "Đã nộp" : "Chưa nộp",
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= DATA =================

const membersHK1 = [
  Member(name: "Nguyễn Văn An", paid: true),
  Member(name: "Trần Thị Bích", paid: true),
  Member(name: "Lê Hoàng Cường", paid: false),
  Member(name: "Phạm Minh Duy", paid: false),
  Member(name: "Hoàng Thị Minh", paid: true),
  Member(name: "Ngô Quang Huy", paid: true),
  Member(name: "Đặng Thu Hà", paid: false),
  Member(name: "Vũ Đức Long", paid: true),
  Member(name: "Phan Thảo My", paid: false),
  Member(name: "Bùi Anh Tuấn", paid: true),
];

const membersUniform = [
  Member(name: "Lê Hoàng Cường", paid: false),
  Member(name: "Phạm Minh Duy", paid: false),
  Member(name: "Hoàng Thị Minh", paid: true),
  Member(name: "Nguyễn Văn An", paid: true),
  Member(name: "Trần Thị Bích", paid: true),
  Member(name: "Ngô Quang Huy", paid: false),
  Member(name: "Đặng Thu Hà", paid: true),
  Member(name: "Vũ Đức Long", paid: false),
  Member(name: "Phan Thảo My", paid: false),
  Member(name: "Bùi Anh Tuấn", paid: true),
];

// ================= MODELS =================

class Member {
  final String name;
  final bool paid;

  const Member({required this.name, required this.paid});
}

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
