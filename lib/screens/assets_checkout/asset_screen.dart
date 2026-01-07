import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/services/assets_services/asset_service.dart';
import '/models/assets_models/asset_model.dart';
import 'add_asset_dialog.dart';
import 'confirm_borrow_dialog.dart';
import 'confirm_return_dialog.dart';
import 'asset_history_screen.dart';
import 'package:classpall_flutter/widgets/custom_bottom_bar.dart';
import '/services/user_service.dart';

class AssetsScreen extends StatefulWidget {
  const AssetsScreen({super.key});

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  final AssetService assetService = AssetService();
  final currentUser = FirebaseAuth.instance.currentUser;

  bool expandTotal = false;
  bool expandAvailable = false;
  bool expandBorrowed = false;
  bool role = false;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final user = await UserService().getUserById(uid);

    if (mounted) {
      setState(() {
        role = user?.role == true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
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
            Text(
              'Danh sách tài sản chung',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),

      // ================= BODY =================
      body: Column(
        children: [
          // ===== TOP ACTION =====
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                if (role)
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Thêm tài sản'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F80ED),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => const AddAssetDialog(),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (value){
                    setState(() {
                      searchText = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm tài sản...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ===== LIST FIREBASE =====
          Expanded(
            child: StreamBuilder<List<Asset>>(
              stream: assetService.getAssets(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                final assets = snapshot.data ?? [];

                final filteredAssets = assets.where((a) {
                  return a.name.toLowerCase().contains(searchText);
                }).toList();

                final total = filteredAssets.length;
                final available = filteredAssets
                    .where((e) => e.status == 'available')
                    .toList();
                final borrowed = filteredAssets
                    .where((e) => e.status == 'borrowed')
                    .toList();

                return ListView(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _sectionHeader(
                      icon: Icons.inventory_2_outlined,
                      iconColor: Colors.blue,
                      title: 'Tổng tài sản',
                      count: total,
                      expanded: expandTotal,
                      onTap: () =>
                          setState(() => expandTotal = !expandTotal),
                    ),
                    if (expandTotal)
                      ...assets
                          .map((e) => _assetRow(asset: e))
                          .toList(),

                    _sectionHeader(
                      icon: Icons.check_circle_outline,
                      iconColor: Colors.green,
                      title: 'Có sẵn',
                      count: available.length,
                      expanded: expandAvailable,
                      onTap: () => setState(
                              () => expandAvailable = !expandAvailable),
                    ),
                    if (expandAvailable)
                      ...available
                          .map(
                            (e) => _assetRow(
                          asset: e,
                          actionLabel: 'Mượn',
                          onAction: () => borrowAsset(e),
                        ),
                      )
                          .toList(),

                    _sectionHeader(
                      icon: Icons.person_outline,
                      iconColor: Colors.red,
                      title: 'Đang mượn',
                      count: borrowed.length,
                      expanded: expandBorrowed,
                      onTap: () => setState(
                              () => expandBorrowed = !expandBorrowed),
                    ),
                    if (expandBorrowed)
                      ...borrowed.map(
                            (e) {
                          final isMine =
                              e.borrowedById == currentUser?.uid;
                          return _assetRow(
                            asset: e,
                            actionLabel: isMine ? 'Trả' : null,
                            actionColor: Colors.blue,
                            onAction:
                            isMine ? () => returnAsset(e) : null,
                            subtitle:
                            'Người mượn: ${e.borrowedByName}',
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ),

          // ===== HISTORY BUTTON =====
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.history),
                label: const Text('Lịch sử'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F80ED),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AssetHistoryScreen()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 0,
      ),
    );
  }

  // ================= COMPONENTS =================

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
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)),
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

  Widget _assetRow({
    required Asset asset,
    String? actionLabel,
    Color actionColor = Colors.blue,
    VoidCallback? onAction,
    String? subtitle,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(asset.name),
                if (subtitle != null)
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(actionLabel,
                    style: TextStyle(
                        fontSize: 12, color: actionColor)),
              ),
            ),
          const SizedBox(width: 8),
          if (role)
            GestureDetector(
              onTap: () => deleteAsset(context, asset),
              child: const Icon(Icons.delete_outline, color: Colors.grey),
            ),
        ],
      ),
    );
  }

  // ================= ACTIONS =================

  Future<void> borrowAsset(Asset asset) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) =>
          ConfirmBorrowDialog(assetName: asset.name),
    );

    if (ok == true) {
      await assetService.borrowAsset(assetId: asset.id, assetName: asset.name);
    }
  }

  Future<void> returnAsset(Asset asset) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) =>
          ConfirmReturnDialog(assetName: asset.name),
    );

    if (ok == true) {
      await assetService.returnAsset(assetId: asset.id, assetName: asset.name);
    }
  }

  Future<void> deleteAsset(
      BuildContext context,
      Asset asset,
      ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: const Text('Xóa tài sản'),
            content: Text('Bạn có chắc muốn xóa "${asset.name}" không?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Xóa'),
              ),
            ],
          ),
    );

    if (ok == true) {
      await assetService.deleteAsset(asset.id);
    }
  }
}


