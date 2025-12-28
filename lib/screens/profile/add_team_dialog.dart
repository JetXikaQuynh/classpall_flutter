import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../services/duty_services/team_service.dart';
import '../../models/user_model.dart';

class AddTeamDialog {
  static void show(BuildContext context) {
    final teamNameController = TextEditingController();
    final searchController = TextEditingController();

    final userService = UserService();
    final teamService = TeamService();

    List<UserModel> availableUsers = [];
    List<UserModel> filteredUsers = [];
    final selectedUserIds = <String>{};

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> loadUsers() async {
              final users = await userService.getAllUsers();
              final noTeamUsers = users.where((u) => u.teamId.isEmpty).toList();

              setState(() {
                availableUsers = noTeamUsers;
                filteredUsers = noTeamUsers;
              });
            }

            if (availableUsers.isEmpty) {
              loadUsers();
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Container(
                width: 420,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 30),
                        const Text(
                          "Thêm tổ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// Tên tổ
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Tên tổ*",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 6),

                    TextField(
                      controller: teamNameController,
                      decoration: InputDecoration(
                        hintText: "VD: team04",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Search
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "Tìm kiếm thành viên...",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) {
                        setState(() {
                          filteredUsers = availableUsers
                              .where(
                                (u) => u.fullName.toLowerCase().contains(
                                  v.toLowerCase(),
                                ),
                              )
                              .toList();
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    /// USER LIST
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        itemCount: filteredUsers.length,
                        itemBuilder: (_, i) {
                          final u = filteredUsers[i];
                          return CheckboxListTile(
                            value: selectedUserIds.contains(u.id),
                            title: Text(u.fullName),
                            onChanged: (v) {
                              setState(() {
                                v == true
                                    ? selectedUserIds.add(u.id)
                                    : selectedUserIds.remove(u.id);
                              });
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// CREATE
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final name = teamNameController.text.trim();
                          if (name.isEmpty || selectedUserIds.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Vui lòng nhập tên tổ và chọn thành viên',
                                ),
                              ),
                            );
                            return;
                          }

                          await teamService.createTeam(
                            teamId: name,
                            userIds: selectedUserIds.toList(),
                          );

                          Navigator.pop(context, true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            0,
                            68,
                            185,
                          ),
                        ),
                        child: const Text(
                          "Tạo tổ",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Hủy"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
