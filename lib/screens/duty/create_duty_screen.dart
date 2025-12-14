import 'package:flutter/material.dart';

class CreateDutyScreen extends StatefulWidget {
  const CreateDutyScreen({super.key});

  @override
  State<CreateDutyScreen> createState() => _CreateDutyScreenState();
}

class _CreateDutyScreenState extends State<CreateDutyScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController pointController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isRepeat = false;
  String? selectedTeam = "1";

  /// Danh sách tổ (sau này load từ Firestore)
  List<String> teams = ["1", "2", "3"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAF3FF),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Tạo nhiệm vụ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //name duty
            const Text(
              "Tên nhiệm vụ:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Ví dụ: Lau bảng,...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            //checkbox lặp lại
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Nhiệm vụ lặp lại",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Nhiệm vụ sẽ tự động xoay vòng giữa các tổ",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Checkbox(
                    value: isRepeat,
                    onChanged: (v) => setState(() => isRepeat = v!),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            //chọn tổ bắt đầu
            const Text(
              "Tổ bắt đầu:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButton<String>(
                value: selectedTeam,
                items: teams
                    .map(
                      (t) => DropdownMenuItem<String>(
                        value: t,
                        child: Text("Tổ $t"),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedTeam = value);
                },
                isExpanded: true,
                underline: const SizedBox(),
              ),
            ),

            const SizedBox(height: 6),
            Text(
              "Nhiệm vụ sẽ được bắt đầu từ tổ này và xoay vòng với thứ tự: Tổ 1 → Tổ 2 → Tổ 3",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),

            const SizedBox(height: 20),

            // points
            const Text(
              "Điểm thưởng:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            TextField(
              controller: pointController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "10",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            //description
            const Text(
              "Mô tả (Không bắt buộc):",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Mô tả chi tiết về nhiệm vụ...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Lưu ý:\n"
                "- Hệ thống sẽ tự động gửi thông báo cho tổ được phân công\n"
                "- Tổ trưởng có thể xác nhận hoàn thành nhiệm vụ vào cuối tuần\n"
                "- Điểm thưởng sẽ được cộng tự động vào bảng vàng",
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 0, 106, 255),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // BUTTONS
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      "Hủy",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _createDuty,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color.fromARGB(255, 33, 44, 243),
                    ),
                    child: const Text(
                      "Tạo nhiệm vụ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // XỬ LÝ TẠO NHIỆM VỤ (CHƯA GÁN FIRESTORE)
  void _createDuty() {
    if (nameController.text.isEmpty || pointController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng nhập đầy đủ tên nhiệm vụ và điểm thưởng."),
        ),
      );
      return;
    }

    // TODO: Gọi Firestore để tạo nhiệm vụ thật
    print("Tên nhiệm vụ: ${nameController.text}");
    print("Điểm: ${pointController.text}");
    print("Lặp lại: $isRepeat");
    print("Tổ bắt đầu: $selectedTeam");
    print("Mô tả: ${descriptionController.text}");

    Navigator.pop(context);
  }
}
