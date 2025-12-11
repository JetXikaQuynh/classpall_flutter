// lib/screens/permission/add_team_dialog.dart

import 'package:flutter/material.dart';

class AddTeamDialog {
  static void show(BuildContext context) {
    TextEditingController teamNameController = TextEditingController();
    TextEditingController searchController = TextEditingController();

    // Danh sách mẫu - sau này bạn thay Firebase
    List<Map<String, dynamic>> availableUsers = [
      {"name": "Nguyễn Văn A", "selected": false},
      {"name": "Đỗ Thị C", "selected": false},
      {"name": "Đỗ Thị C", "selected": false},
    ];

    List<Map<String, dynamic>> filteredUsers = List.from(availableUsers);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Container(
                width: 400,
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
                        "Tên tổ*: ",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    TextField(
                      controller: teamNameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Chọn thành viên
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Chọn thành viên:",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// Tìm kiếm
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: "Tìm kiếm thành viên...",
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        onChanged: (value) {
                          setState(() {
                            filteredUsers = availableUsers
                                .where(
                                  (u) => u["name"].toLowerCase().contains(
                                    value.toLowerCase(),
                                  ),
                                )
                                .toList();
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// Danh sách checkbox
                    Container(
                      height: 160,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Checkbox(
                                value: filteredUsers[index]["selected"],
                                onChanged: (val) {
                                  setState(() {
                                    filteredUsers[index]["selected"] = val!;
                                    // Đồng bộ lại
                                    final name = filteredUsers[index]["name"];
                                    final idx = availableUsers.indexWhere(
                                      (u) => u["name"] == name,
                                    );
                                    availableUsers[idx]["selected"] = val;
                                  });
                                },
                              ),
                              Text(filteredUsers[index]["name"]),
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Lưu ý: Bạn chỉ có thể chọn những thành viên chưa có tổ.",
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                      textAlign: TextAlign.left,
                    ),

                    const SizedBox(height: 18),

                    /// Tạo tổ
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Ghi Firestore
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 0, 68, 185),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          "Tạo tổ",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Hủy
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Hủy",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
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
