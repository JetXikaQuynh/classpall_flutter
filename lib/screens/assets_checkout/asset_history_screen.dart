import 'package:flutter/material.dart';
import '/models/assets_models/asset_history_model.dart';
import '/services/assets/asset_history_service.dart';

class AssetHistoryScreen extends StatefulWidget {
  const AssetHistoryScreen({super.key});

  @override
  State<AssetHistoryScreen> createState() => _AssetHistoryScreenState();
}

class _AssetHistoryScreenState extends State<AssetHistoryScreen> {
  final AssetHistoryService historyService = AssetHistoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Lịch sử tài sản',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<List<AssetHistory>>(
        stream: historyService.getHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<AssetHistory> histories = snapshot.data ?? [];

          final borrowed = histories
              .where((e) => e.action == 'borrowed')
              .toList();

          final returned = histories
              .where((e) => e.action == 'returned')
              .toList();

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _buildSection(
                title: 'Đang mượn',
                color: Colors.orange,
                items: borrowed,
              ),
              const SizedBox(height: 16),
              _buildSection(
                title: 'Đã trả',
                color: Colors.blue,
                items: returned,
              ),
            ],
          );
        },
      ),
    );
  }

  // ================= UI =================

  Widget _buildSection({
    required String title,
    required Color color,
    required List<AssetHistory> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 6,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$title (${items.length})',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (items.isEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Không có dữ liệu',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ...items.map(_buildItem),
      ],
    );
  }

  Widget _buildItem(AssetHistory item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: item.action == 'borrowed'
                ? Colors.orange.shade100
                : Colors.blue.shade100,
            child: Icon(
              item.action == 'borrowed'
                  ? Icons.vpn_key
                  : Icons.check_circle,
              color: item.action == 'borrowed'
                  ? Colors.orange
                  : Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.assetName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  'Người ${item.action == 'borrowed' ? 'mượn' : 'trả'}: ${item.userName}',
                ),
                const SizedBox(height: 2),
                Text(
                  'Thời gian: ${_formatDate(item.createdAt)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}
