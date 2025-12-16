import 'package:flutter/material.dart';
import 'package:classpall_flutter/widgets/custom_bottom_bar.dart';
import 'package:classpall_flutter/routes/app_routes.dart';
import 'logout_confirm_dialog.dart';

class PersonalProfileScreen extends StatelessWidget {
  const PersonalProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Trang cá nhân",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            /// Avatar + Tên + Role
            Column(
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 10),

                const Text(
                  "Đỗ Phương Quỳnh",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const Text(
                  "Admin",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xffF5A623),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// TIÊU ĐỀ: Thông tin cá nhân
            Row(
              children: const [
                Icon(
                  Icons.badge,
                  color: Color.fromARGB(255, 0, 68, 185),
                  size: 26,
                ),
                SizedBox(width: 8),
                Text(
                  "Thông tin cá nhân:",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// Hộp thông tin
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade300, width: 1.5),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Vai trò:  Admin"),
                  SizedBox(height: 4),
                  Text("SĐT:  0123456788"),
                  SizedBox(height: 4),
                  Text("Mail:  abc@gmail.com"),
                  SizedBox(height: 4),
                  Text("Lớp:  64KTPM2"),
                  SizedBox(height: 4),
                  Text("Tổ:  Tổ 2"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Danh sách tùy chọn
            _buildMenuItem(
              icon: Icons.edit,
              text: "Sửa thông tin",
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.editProfile);
              },
            ),
            _buildMenuItem(
              icon: Icons.group,
              text: "Phân quyền",
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.permission);
              },
            ),

            const SizedBox(height: 30),

            /// Nút Đăng xuất
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const LogoutConfirmDialog(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 253, 39, 39),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "Đăng xuất",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 70),
          ],
        ),
      ),

      /// Bottom Navigation, index = 2 =>iconbutton pro5
      bottomNavigationBar: const CustomBottomBar(currentIndex: 2),
    );
  }

  /// Hàm tạo một item menu
  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Color.fromARGB(255, 0, 68, 185)),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
            const Icon(Icons.chevron_right, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
