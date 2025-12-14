import 'package:flutter/material.dart';

class AssetHistoryScreen extends StatelessWidget {
  const AssetHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text('Lịch sử mượn trả',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _section('Đã trả'),
          _item(
            'Remote điều hòa #1',
            'Nguyễn Văn A',
            '12:00 - 10/11',
            '13:30 - 10/11',
          ),
          _item(
            'Remote máy chiếu',
            'Phạm Văn B',
            '10:00 - 09/11',
            '11:00 - 09/11',
          ),
          _section('Đang mượn'),
          _item(
            'Chìa khóa tủ bảng',
            'Nguyễn Văn A',
            '09:00 - 12/11',
            null,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.blue)),
    );
  }

  Widget _item(
      String name, String user, String borrow, String? back) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.devices),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Người mượn: $user'),
            Text('Mượn: $borrow'),
            if (back != null) Text('Trả: $back'),
          ],
        ),
      ),
    );
  }
}
