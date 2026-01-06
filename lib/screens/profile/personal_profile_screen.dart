import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:classpall_flutter/widgets/custom_bottom_bar.dart';
import 'package:classpall_flutter/routes/app_routes.dart';
import 'logout_confirm_dialog.dart';

import '../../models/user_model.dart';
import '../../models/duty_models/team_model.dart';

import '../../services/user_service.dart';
import '../../services/duty_services/team_service.dart';
import '../../services/auth_service.dart';

class PersonalProfileScreen extends StatefulWidget {
  const PersonalProfileScreen({super.key});

  @override
  State<PersonalProfileScreen> createState() => _PersonalProfileScreenState();
}

class _PersonalProfileScreenState extends State<PersonalProfileScreen> {
  final _userService = UserService();
  final _teamService = TeamService();

  UserModel? _user;
  TeamModel? _team;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);

    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      setState(() => _loading = false);
      return;
    }

    final user = await _userService.getUserById(firebaseUser.uid);
    if (user == null) {
      setState(() => _loading = false);
      return;
    }

    TeamModel? team;
    if (user.teamId.isNotEmpty) {
      team = await _teamService.getTeamById(user.teamId);
    }

    setState(() {
      _user = user;
      _team = team;
      _loading = false;
    });
  }

  String _roleText() {
    if (AuthService.isAdmin) return "Admin";
    return "Thành viên";
  }

  Color _roleColor() {
    if (AuthService.isAdmin) return const Color(0xffF5A623);
    if (_user?.isLeader == true) return Colors.blue;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_user == null) {
      return const Scaffold(
        body: Center(child: Text("Không thể tải thông tin người dùng")),
      );
    }

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
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey.shade400,
                  backgroundImage: _user!.avatar.isNotEmpty
                      ? NetworkImage(_user!.avatar)
                      : null,
                  child: _user!.avatar.isEmpty
                      ? const Icon(Icons.person, size: 50, color: Colors.white)
                      : null,
                ),
                const SizedBox(height: 10),

                Text(
                  _user!.fullName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  _roleText(),
                  style: TextStyle(
                    fontSize: 16,
                    color: _roleColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// TIÊU ĐỀ
            Row(
              children: const [
                Icon(Icons.badge, color: Color(0xff0044B9), size: 26),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Vai trò:  ${_roleText()}"),
                  const SizedBox(height: 4),
                  Text("SĐT:  ${_user!.phone}"),
                  const SizedBox(height: 4),
                  Text("Mail:  ${_user!.email}"),
                  const SizedBox(height: 4),
                  Text("Lớp:  ${_user!.className}"),
                  const SizedBox(height: 4),
                  Text("Tổ:  ${_team?.name ?? 'Chưa có'}"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Menu
            _buildMenuItem(
              icon: Icons.edit,
              text: "Sửa thông tin",
              onTap: () async {
                final result = await Navigator.pushNamed(
                  context,
                  AppRoutes.editProfile,
                );
                if (result == true) {
                  // reload profile after successful edit
                  _loadProfile();
                }
              },
            ),

            if (AuthService.isAdmin)
              _buildMenuItem(
                icon: Icons.group,
                text: "Phân quyền",
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.permission);
                },
              ),
            _buildMenuItem(
              icon: Icons.lock,
              text: "Đổi mật khẩu",
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.changePassword);
              },
            ),

            const SizedBox(height: 30),
            
            /// Logout
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
                  backgroundColor: const Color(0xffFD2727),
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

      bottomNavigationBar: const CustomBottomBar(currentIndex: 2),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
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
            Icon(icon, size: 22, color: const Color(0xff0044B9)),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
