import 'package:flutter/material.dart';
import 'package:classpall_flutter/widgets/duty/duty_detail_card.dart';
import 'package:classpall_flutter/widgets/duty/assignee_card.dart';
import 'package:classpall_flutter/widgets/duty/rotation_history_item.dart';
import 'confirm_duty_dialog.dart';

class DutyDetailScreen extends StatelessWidget {
  const DutyDetailScreen({super.key});

  // Dữ liệu giả định
  final String userRole = "admin"; // "member" | "leader" | "admin"
  final String dutyStatus =
      "pending_approval"; // done | pending_approval | inprogress | late

  final List<Map<String, dynamic>> _assignees = const [
    {
      "name": "Đỗ Phương Quỳnh",
      "isLeader": true,
      "team": "Tổ 2",
      "color": Colors.orange,
    },
    {
      "name": "Đỗ Hải Lam",
      "isLeader": false,
      "team": null,
      "color": Colors.grey,
    },
    {
      "name": "Đỗ Huy Hoàn",
      "isLeader": false,
      "team": null,
      "color": Colors.grey,
    },
  ];

  final List<Map<String, dynamic>> _rotationHistory = const [
    {"week": 12, "team": 3, "status": "Đã xong", "isCurrent": false},
    {"week": 13, "team": 1, "status": "Đã xong", "isCurrent": false},
    {"week": 14, "team": 2, "status": "Hiện tại", "isCurrent": true},
    {"week": 15, "team": 3, "status": "", "isCurrent": false},
    {"week": 16, "team": 1, "status": "", "isCurrent": false},
  ];

  // Dữ liệu nhiệm vụ chính
  final String _dutyName = "Giặt giẻ lau";
  final String _dutyDescription =
      "Giặt sạch giẻ lau bảng trước khi môn học mới bắt đầu";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Chi tiết nhiệm vụ",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      bottomNavigationBar: _buildBottomButton(context, userRole, dutyStatus),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề Nhiệm vụ
            Text(
              _dutyName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Thẻ Chi tiết (Thay thế _buildDetailCard)
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  DutyDetailCard(
                    label: "Trạng thái:",
                    value: "Đang làm",
                    valueColor: Colors.orange,
                  ),
                  DutyDetailCard(
                    label: "Bắt đầu:",
                    value: "02/12/2025",
                    valueColor: Colors.black87,
                  ),
                  DutyDetailCard(
                    label: "Kết thúc:",
                    value: "02/18/2025",
                    valueColor: Colors.black87,
                  ),
                  DutyDetailCard(
                    label: "Điểm thưởng:",
                    value: "10 điểm",
                    valueColor: Colors.black87,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Thẻ Người phụ trách (Thay thế _buildAssigneeCard)
            AssigneeCard(teamName: "Tổ 2", assignees: _assignees),
            const SizedBox(height: 15),

            // Thẻ Mô tả nhiệm vụ (Thay thế _buildDescriptionCard)
            DutyDescriptionCard(description: _dutyDescription),
            const SizedBox(height: 15),

            // Lịch sử xoay vòng
            const Text(
              "Lịch sử xoay vòng",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // List các tuần xoay vòng (Sử dụng RotationHistoryItem)
            ..._rotationHistory
                .map(
                  (item) => RotationHistoryItem(
                    week: item["week"],
                    team: item["team"],
                    status: item["status"],
                    isCurrent: item["isCurrent"],
                  ),
                )
                .toList(),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget? _buildBottomButton(BuildContext context, String role, String status) {
    // MEMBER -> không có nút
    if (role == "member") return null;

    // LEADER -> chỉ được thấy nút khi đang làm
    if (role == "leader" && status == "inprogress") {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              print("Chuyển nhiệm vụ sang pending_approval");
              // TODO: Update Firestore: status = 'pending_approval'
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 33, 44, 243),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Đã hoàn thành",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    // ADMIN -> chỉ được thấy khi đang chờ xác nhận
    if (role == "admin" && status == "pending_approval") {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              final confirm = await ConfirmCompleteDialog.show(
                context,
                teamName: "Tổ 2",
                bonusPoint: 10,
              );

              if (confirm == true) {
                print(">>> ADMIN ĐÃ XÁC NHẬN HOÀN THÀNH");

                // TODO:
                // - Update Firestore status = done
                // - Ghi vào duty_history
                // - Cộng điểm cho tổ
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Xác nhận hoàn thành",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    // Trường hợp khác -> không hiện nút
    return null;
  }
}
