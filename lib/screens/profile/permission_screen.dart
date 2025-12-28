import 'package:flutter/material.dart';
import 'package:classpall_flutter/widgets/profile/user_item.dart';
import '../../services/user_service.dart';
import '../../models/user_model.dart';
import 'add_team_dialog.dart';
import 'delete_team_dialog.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  final _userService = UserService();

  String selectedFilter = "Tất cả";
  String? selectedLeader;
  String _search = '';

  List<String> filters = ["Tất cả"];
  List<String> teamOptions = [];
  final List<String> roleOptions = ["Thành viên", "Admin"];

  List<UserModel> _filteredUsers = [];

  // ===== FILTER =====
  void _applyFilters(List<UserModel> users) {
    List<UserModel> list = List.from(users);

    if (selectedFilter != "Tất cả") {
      list = list.where((u) => u.teamId == selectedFilter).toList();
    }

    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      list = list.where((u) {
        return u.fullName.toLowerCase().contains(q) ||
            u.email.toLowerCase().contains(q);
      }).toList();
    }

    _filteredUsers = list;
  }

  // ===== SET LEADER =====
  Future<void> _setTeamLeader(
    List<UserModel> users,
    String teamId,
    String userId,
  ) async {
    try {
      final previousLeaders = users.where(
        (u) => u.teamId == teamId && u.isLeader,
      );

      for (final p in previousLeaders) {
        if (p.id != userId) {
          await _userService.setLeader(p.id, false);
        }
      }

      await _userService.setLeader(userId, true);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã cập nhật tổ trưởng')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể cập nhật tổ trưởng: $e')),
      );
    }
  }

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
        centerTitle: true,
        title: const Text(
          "Phân quyền",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),

      // ================= STREAM =================
      body: StreamBuilder<List<UserModel>>(
        stream: _userService.streamAllUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!
            ..sort((a, b) => a.fullName.compareTo(b.fullName));

          // ===== BUILD TEAM LIST =====
          final teamSet = <String>{};
          for (final u in users) {
            if (u.teamId.isNotEmpty) teamSet.add(u.teamId);
          }
          teamOptions = teamSet.toList()..sort();
          filters = ["Tất cả", ...teamOptions];

          _applyFilters(users);

          return Column(
            children: [
              /// SEARCH
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    hintText: "Tìm kiếm thành viên...",
                  ),
                  onChanged: (v) {
                    setState(() => _search = v);
                  },
                ),
              ),

              /// STATS
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    Text(
                      "${users.length} thành viên  •  "
                      "${users.where((u) => u.role).length} admin  •  "
                      "${teamOptions.length} tổ",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// BUTTONS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => AddTeamDialog.show(context),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text("Thêm tổ"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 68, 185),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// FILTER TABS
              SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  children: filters.map((teamName) {
                    final isActive = teamName == selectedFilter;
                    final count = teamName == 'Tất cả'
                        ? users.length
                        : users.where((u) => u.teamId == teamName).length;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = teamName;
                          selectedLeader = null;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isActive ? Colors.blue.shade100 : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isActive
                                ? Colors.blue
                                : Colors.grey.shade400,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "$teamName ($count)",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isActive
                                    ? Colors.blue.shade700
                                    : Colors.black87,
                              ),
                            ),
                            if (teamName != "Tất cả") ...[
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () async {
                                  final confirm = await DeleteTeamDialog.show(
                                    context,
                                    teamName,
                                  );
                                  if (confirm == true) {
                                    for (final u in users.where(
                                      (u) => u.teamId == teamName,
                                    )) {
                                      await _userService.updateUserTeam(
                                        u.id,
                                        '',
                                      );
                                    }
                                  }
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 18,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              /// SELECT LEADER
              if (selectedFilter != "Tất cả")
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.workspace_premium, color: Colors.orange),
                      const SizedBox(width: 10),
                      const Text(
                        "Chọn tổ trưởng:",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: selectedLeader,
                        hint: const Text("Chọn"),
                        items: users
                            .where((u) => u.teamId == selectedFilter)
                            .map(
                              (u) => DropdownMenuItem(
                                value: u.id,
                                child: Text(u.fullName),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => selectedLeader = value);
                            _setTeamLeader(users, selectedFilter, value);
                          }
                        },
                      ),
                    ],
                  ),
                ),

              /// USER LIST
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 70),
                  itemCount: _filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = _filteredUsers[index];

                    return UserItem(
                      user: {
                        'id': user.id,
                        'name': user.fullName,
                        'team': user.teamId.isEmpty ? 'Chưa có' : user.teamId,
                        'role': user.role ? 'Admin' : 'Thành viên',
                      },
                      teamOptions: ['Chưa có', ...teamOptions],
                      roleOptions: roleOptions,
                      onTeamChanged: (value) async {
                        await _userService.updateUserTeam(
                          user.id,
                          value == 'Chưa có' ? '' : value!,
                        );
                      },
                      onRoleChanged: (value) async {
                        await _userService.setRole(user.id, value == 'Admin');
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
