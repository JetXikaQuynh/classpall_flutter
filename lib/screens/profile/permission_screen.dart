import 'package:flutter/material.dart';
import 'package:classpall_flutter/widgets/profile/user_item.dart';
import 'add_team_dialog.dart';
import 'delete_team_dialog.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  // danh sách user tĩnh mẫu
  final List<Map<String, dynamic>> users = [
    {"name": "Nguyễn Văn A", "team": "Tổ 1", "role": "Thành viên"},
    {"name": "Nguyễn Thị N", "team": "Tổ 1", "role": "Admin"},
    {"name": "Đỗ Thị C", "team": "Tổ 1", "role": "Thành viên"},
    {"name": "Nguyễn Văn A", "team": "Tổ 1", "role": "Admin"},
    {"name": "Nguyễn Văn A", "team": "Tổ 1", "role": "Thành viên"},
    {"name": "Nguyễn Văn A", "team": "Tổ 1", "role": "Thành viên"},
    {"name": "Đỗ Thị C", "team": "Tổ 1", "role": "Thành viên"},
    {"name": "Nguyễn Văn A", "team": "Tổ 1", "role": "Admin"},
    {"name": "Nguyễn Văn A", "team": "Tổ 1", "role": "Thành viên"},
    {"name": "Nguyễn Văn A", "team": "Tổ 1", "role": "Thành viên"},
  ];

  String selectedFilter = "Tất cả"; // Tổ đang chọn
  String? selectedLeader; // Tổ trưởng đang chọn

  List<String> filters = ["Tất cả", "Tổ 1", "Tổ 2", "Tổ 3"];
  List<String> teamOptions = ["Tổ 1", "Tổ 2", "Tổ 3"];
  List<String> roleOptions = ["Thành viên", "Admin"];

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách user theo tổ
    final filteredUsers = selectedFilter == "Tất cả"
        ? users
        : users.where((u) => u["team"] == selectedFilter).toList();

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
        actions: const [SizedBox(width: 10)],
      ),

      body: Column(
        children: [
          /// Thanh tìm kiếm
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
                hintText: "Tìm kiếm thành viên...",
              ),
            ),
          ),

          /// Thống kê
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              children: [
                Text(
                  "68 thành viên  •  2 admin  •  3 tổ",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          /// Nút thêm tổ + lưu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    AddTeamDialog.show(context);
                  },
                  icon: const Icon(Icons.add, size: 18, color: Colors.white),
                  label: const Text(
                    "Thêm tổ",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 68, 185),
                  ),
                ),

                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.save, size: 18, color: Colors.white),
                  label: const Text(
                    "Lưu",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 68, 185),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          /// Tabs lọc tổ
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: filters.map((teamName) {
                final bool isActive = teamName == selectedFilter;

                int count;
                switch (teamName) {
                  case "Tổ 1":
                    count = 20;
                    break;
                  case "Tổ 2":
                    count = 20;
                    break;
                  case "Tổ 3":
                    count = 30;
                    break;
                  default:
                    count = users.length;
                }

                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = teamName;
                        selectedLeader = null; // reset khi đổi tổ
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.blue.shade100 : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isActive ? Colors.blue : Colors.grey.shade400,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "$teamName ($count)",
                            style: TextStyle(
                              color: isActive
                                  ? Colors.blue.shade700
                                  : Colors.black87,
                              fontWeight: FontWeight.w600,
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
                                  setState(() {
                                    filters.remove(teamName);
                                    teamOptions.remove(teamName);
                                  });
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
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 10),

          ///SELECT TỔ TRƯỞNG (CHỈ HIỆN KHI CHỌN TỔ)
          if (selectedFilter != "Tất cả")
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.yellow.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.workspace_premium, color: Colors.amber.shade800),
                  const SizedBox(width: 10),
                  const Text(
                    "Chọn tổ trưởng:",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  const SizedBox(width: 20),

                  DropdownButton<String>(
                    value: selectedLeader,
                    hint: const Text("Chọn tên"),
                    items: users
                        .where((u) => u["team"] == selectedFilter)
                        .map<DropdownMenuItem<String>>((u) {
                          return DropdownMenuItem<String>(
                            value: u["name"] as String,
                            child: Text(u["name"] as String),
                          );
                        })
                        .toList(),
                    onChanged: (value) {
                      setState(() => selectedLeader = value);
                    },
                  ),
                ],
              ),
            ),

          /// DANH SÁCH USER
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 70),
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return UserItem(
                  user: user,
                  teamOptions: teamOptions,
                  roleOptions: roleOptions,
                  onTeamChanged: (value) {
                    setState(() {
                      user["team"] = value!;
                    });
                  },
                  onRoleChanged: (value) {
                    setState(() {
                      user["role"] = value!;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
