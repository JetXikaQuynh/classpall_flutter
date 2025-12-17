import 'package:classpall_flutter/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'add_asset_dialog.dart';
import 'confirm_borrow_dialog.dart';
import 'confirm_return_dialog.dart';
import 'package:classpall_flutter/widgets/custom_bottom_bar.dart';

class AssetsScreen extends StatefulWidget {
  const AssetsScreen({super.key});

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  final List<Map<String, dynamic>> assets = [
    {'name': 'Remote điều hòa #1', 'borrowed': false},
    {'name': 'Remote máy chiếu', 'borrowed': false},
    {'name': 'Chìa khóa tủ bảng', 'borrowed': false},
  ];

  bool expandTotal = false;
  bool expandAvailable = false;
  bool expandBorrowed = false;

  // ===== ACTIONS =====

  Future<void> _addAsset() async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const AddAssetDialog(),
    );

    if (name != null && name.isNotEmpty) {
      setState(() {
        assets.add({'name': name, 'borrowed': false});
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thêm tài sản thành công'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _borrowAsset(int index) async {
    final assetName = assets[index]['name'];

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmBorrowDialog(
        assetName: assetName,
      ),
    );

    if (ok == true) {
      setState(() {
        assets[index]['borrowed'] = true;
      });
    }
  }

  Future<void> _returnAsset(int index) async {
    final assetName = assets[index]['name'];

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmReturnDialog(
        assetName: assetName,
      ),
    );

    if (ok == true) {
      setState(() {
        assets[index]['borrowed'] = false;
      });
    }
  }

  int _currentIndex = 0;

  // ===== BUILD =====

  @override
  Widget build(BuildContext context) {
    final total = assets.length;
    final available = assets.where((e) => !e['borrowed']).length;
    final borrowed = assets.where((e) => e['borrowed']).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quản lý tài sản',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 2),
            Text('Danh sách tài sản chung',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),

      body: Column(
        children: [
          _topAction(),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _sectionHeader(
                  icon: Icons.inventory_2_outlined,
                  iconColor: Colors.blue,
                  title: 'Tổng tài sản',
                  count: total,
                  expanded: expandTotal,
                  onTap: () => setState(() => expandTotal = !expandTotal),
                ),
                if (expandTotal)
                  ...assets.map((e) => _assetRow(e)).toList(),

                _sectionHeader(
                  icon: Icons.check_circle_outline,
                  iconColor: Colors.green,
                  title: 'Có sẵn',
                  count: available,
                  expanded: expandAvailable,
                  onTap: () =>
                      setState(() => expandAvailable = !expandAvailable),
                ),
                if (expandAvailable)
                  ...assets
                      .asMap()
                      .entries
                      .where((e) => !e.value['borrowed'])
                      .map((e) => _assetRow(
                    e.value,
                    onBorrow: () => _borrowAsset(e.key),
                  ))
                      .toList(),

                _sectionHeader(
                  icon: Icons.person_outline,
                  iconColor: Colors.red,
                  title: 'Đang mượn',
                  count: borrowed,
                  expanded: expandBorrowed,
                  onTap: () =>
                      setState(() => expandBorrowed = !expandBorrowed),
                ),
                if (expandBorrowed)
                  ...assets
                      .asMap()
                      .entries
                      .where((e) => e.value['borrowed'])
                      .map((e) => _assetRow(
                      e.value,
                      borrowedView: true,
                      onReturn: () => _returnAsset(e.key),
                  ))
                      .toList(),
              ],
            ),
          ),

          _historyButton(),
        ],
      ),

      bottomNavigationBar: CustomBottomBar(currentIndex: _currentIndex),
    );
  }

  // ===== UI PARTS =====

  Widget _topAction() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Thêm tài sản'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F80ED),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _addAsset,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              hintText: 'Tìm kiếm tài sản...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader({
    required IconData icon,
    required Color iconColor,
    required String title,
    required int count,
    required bool expanded,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(top: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title:
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('$count'),
        trailing:
        Icon(expanded ? Icons.expand_less : Icons.expand_more),
        onTap: onTap,
      ),
    );
  }

  Widget _assetRow(
      Map<String, dynamic> asset, {
        VoidCallback? onBorrow,
        VoidCallback? onReturn,
        bool borrowedView = false,
      }) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F4FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.vpn_key, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(asset['name'])),
          if (onBorrow != null)
            GestureDetector(
              onTap: onBorrow,
              child: _badge('Mượn'),
            ),
          if (borrowedView)
            GestureDetector(
              onTap: onReturn,
              child: _badge('Trả',color: Colors.blue),
            ),
          const SizedBox(width: 8),
          const Icon(Icons.delete_outline, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _badge(String text, {Color color = Colors.blue}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child:
      Text(text, style: TextStyle(fontSize: 12, color: color)),
    );
  }

  Widget _historyButton() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: GestureDetector(
        onTap: () {
          Navigator.of(
            context, rootNavigator : true).pushNamed(
          AppRoutes.assetHistory,
          );
        },
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF2F80ED),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Lịch sử',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
