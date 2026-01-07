import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/duty_models/duty_model.dart';
import '../../models/duty_models/duty_assignment_model.dart';
import '../../models/duty_models/team_model.dart';

import '../../services/duty_services/duty_service.dart';
import '../../services/duty_services/duty_assignment_service.dart';
import '../../services/duty_services/team_service.dart';
import '../../services/notification_service.dart';
import '../../utils/date_utils.dart';

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
  TeamModel? selectedTeam;

  final _dutyService = DutyService();
  final _assignmentService = DutyAssignmentService();
  final _teamService = TeamService();

  List<TeamModel> teams = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  /// 🔥 Load danh sách tổ từ Firestore
  Future<void> _loadTeams() async {
    final result = await _teamService.getAllTeams();
    setState(() {
      teams = result;
      selectedTeam = result.isNotEmpty ? result.first : null;
      _loading = false;
    });
  }

  String _buildRotationText() {
    if (selectedTeam == null) return "";

    final startIndex = teams.indexOf(selectedTeam!);

    final rotatedTeams = [
      ...teams.sublist(startIndex),
      ...teams.sublist(0, startIndex),
    ];

    return rotatedTeams.map((t) => "${t.name}").join(" → ");
  }

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

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tên nhiệm vụ:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),

                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Ví dụ: Lau bảng",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Nhiệm vụ lặp lại (xoay vòng)",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
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
                    child: DropdownButton<TeamModel>(
                      value: selectedTeam,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: teams
                          .map(
                            (t) =>
                                DropdownMenuItem(value: t, child: Text(t.name)),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() => selectedTeam = value);
                      },
                    ),
                  ),

                  if (isRepeat) ...[
                    const SizedBox(height: 6),
                    Text(
                      "Nhiệm vụ sẽ được bắt đầu từ tổ này và xoay vòng theo thứ tự: "
                      "${_buildRotationText()}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  const Text(
                    "Điểm thưởng:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),

                  TextField(
                    controller: pointController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Mô tả (Không bắt buộc):",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),

                  TextField(
                    controller: descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

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

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
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
            ),
    );
  }

  ///TẠO NHIỆM VỤ + ASSIGNMENT
  Future<void> _createDuty() async {
    if (nameController.text.isEmpty ||
        pointController.text.isEmpty ||
        selectedTeam == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
      );
      return;
    }

    final now = DateTime.now();
    final week = getCurrentWeekNumber();
    final year = now.year;

    /// TẠO DUTY
    final dutyRef = await FirebaseFirestore.instance.collection('duties').add({
      'name_duty': nameController.text,
      'description': descriptionController.text,
      'is_repeat': isRepeat,
      'points': int.parse(pointController.text),
      'start_team_id': selectedTeam!.id,
    });

    await NotificationService.instance.notifyNewDutyByTeam(
      dutyId: dutyRef.id,
      dutyTitle: nameController.text,
      memberIds: selectedTeam!.userIds,
      teamName: selectedTeam!.name,
    );

    /// 2️⃣ TẠO ASSIGNMENT
    await _assignmentService.createAssignment(
      DutyAssignmentModel(
        id: '',
        dutyId: dutyRef.id,
        teamId: selectedTeam!.id,
        status: 'inprogress',
        weekNumber: week,
        year: now.year,
      ),
    );

    if (mounted) Navigator.pop(context);
  }
}
