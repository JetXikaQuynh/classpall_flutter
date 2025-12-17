import 'package:flutter/material.dart';
import 'package:classpall_flutter/widgets/custom_bottom_bar.dart';

class AssetHistoryScreen extends StatelessWidget {
  const AssetHistoryScreen({super.key});

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
        title: const Text("Lịch sử mượn trả"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Search box
            TextField(
              decoration: InputDecoration(
                hintText: "Tìm kiếm tài sản...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      title: "Đã trả",
                      titleColor: Colors.blue,
                      items: returnedItems,
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      title: "Đang mượn",
                      titleColor: Colors.orange,
                      items: borrowingItems,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(currentIndex: 0),
    );
  }

  // ================= SECTION =================

  Widget _buildSection({
    required String title,
    required Color titleColor,
    required List<BorrowItem> items,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: titleColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: items.map(_buildItem).toList(),
          ),
        ],
      ),
    );
  }

  // ================= ITEM =================

  Widget _buildItem(BorrowItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(item.icon, size: 28, color: Colors.black54),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text("Người giữ: ${item.user}"),
                Text("Mượn: ${item.borrowTime}"),
                if (item.returnTime != null)
                  Text("Trả: ${item.returnTime}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= MODEL =================

class BorrowItem {
  final String name;
  final String user;
  final String borrowTime;
  final String? returnTime;
  final IconData icon;

  const BorrowItem({
    required this.name,
    required this.user,
    required this.borrowTime,
    this.returnTime,
    required this.icon,
  });
}

// ================= DATA MOCK =================

const returnedItems = [
  BorrowItem(
    name: "Remote điều hòa #1",
    user: "Nguyễn Văn A",
    borrowTime: "12:00 - 10/11",
    returnTime: "13:30 - 10/11",
    icon: Icons.settings_remote,
  ),
  BorrowItem(
    name: "Remote máy chiếu",
    user: "Phạm Văn B",
    borrowTime: "10:00 - 09/11",
    returnTime: "11:10 - 09/11",
    icon: Icons.tv,
  ),
];

const borrowingItems = [
  BorrowItem(
    name: "Chìa khóa tủ bảng",
    user: "Nguyễn Văn A",
    borrowTime: "09:00 - 12/11",
    icon: Icons.vpn_key,
  ),
];
