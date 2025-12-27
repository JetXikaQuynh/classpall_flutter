import 'package:flutter/material.dart';

import '../../models/duty_models/duty_assignment_model.dart';
import '../../models/duty_models/duty_model.dart';
import '../../models/duty_models/team_model.dart';
import '../../models/user_model.dart';

import '../../services/duty_services/duty_assignment_service.dart';
import '../../services/duty_services/duty_service.dart';
import '../../services/duty_services/team_service.dart';
import '../../services/user_service.dart';
import '../../services/auth_service.dart';

import '../../widgets/duty/duty_detail_card.dart';
import '../../widgets/duty/assignee_card.dart';
import '../../widgets/duty/rotation_history_item.dart';
import 'confirm_duty_dialog.dart';

class DutyDetailScreen extends StatefulWidget {
  const DutyDetailScreen({super.key});

  @override
  State<DutyDetailScreen> createState() => _DutyDetailScreenState();
}

class _DutyDetailScreenState extends State<DutyDetailScreen> {
  final _assignmentService = DutyAssignmentService();
  final _dutyService = DutyService();
  final _teamService = TeamService();
  final _userService = UserService();

  bool _loading = true;

  DutyAssignmentModel? _assignment;
  DutyModel? _duty;
  TeamModel? _team;
  List<UserModel> _members = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final assignmentId = ModalRoute.of(context)!.settings.arguments as String;

    _loadDetail(assignmentId);
  }

  // LOAD + JOIN DỮ LIỆU CHI TIẾT
  Future<void> _loadDetail(String assignmentId) async {
    setState(() => _loading = true);

    // 1️⃣ Assignment
    final assignment = await _assignmentService.getAssignmentById(assignmentId);
    if (assignment == null) return;

    // 2️⃣ Duty
    final duty = await _dutyService.getDutyById(assignment.dutyId);

    // 3️⃣ Team
    final team = await _teamService.getTeamById(assignment.teamId);

    // 4️⃣ Users trong team
    final members = await _userService.getUsersByTeam(assignment.teamId);

    setState(() {
      _assignment = assignment;
      _duty = duty;
      _team = team;
      _members = members;
      _loading = false;
    });
  }

  // 🔥 UPDATE STATUS
  Future<void> _updateStatus(String status) async {
    await _assignmentService.updateStatus(_assignment!.id, status);
    _loadDetail(_assignment!.id);
  }

  bool _isEndOfWeek(DutyAssignmentModel assignment) {
    final now = DateTime.now();

    // Chỉ CHỦ NHẬT mới được coi là cuối tuần (để tổ trưởng bấm "Đã hoàn thành").
    final isSunday = now.weekday == DateTime.sunday;

    return isSunday;
  }

  /// ISO week number
  int _weekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysOffset = firstDayOfYear.weekday == DateTime.monday
        ? 0
        : 8 - firstDayOfYear.weekday;

    final firstMonday = firstDayOfYear.add(Duration(days: daysOffset));

    return ((date.difference(firstMonday).inDays) / 7).floor() + 1;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_assignment == null || _duty == null || _team == null) {
      return const Scaffold(
        body: Center(child: Text("Không tìm thấy dữ liệu nhiệm vụ")),
      );
    }

    final isAdmin = AuthService.isAdmin;

    UserModel? currentUser;
    try {
      currentUser = _members.firstWhere(
        (u) => u.id == AuthService.currentUserId,
      );
    } catch (e) {
      // ignore: avoid_print
      print('DutyDetail: current user not in team members: $e');
      currentUser = null;
    }

    final isLeader = currentUser?.isLeader ?? false;
    final isEndOfWeek = _isEndOfWeek(_assignment!);

    return Scaffold(
      backgroundColor: Colors.blue.shade50,

      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Chi tiết nhiệm vụ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      bottomNavigationBar: _buildBottomButton(
        isAdmin,
        isLeader,
        _assignment!.status,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TÊN NHIỆM VỤ
            Text(
              _duty!.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            /// THÔNG TIN CHÍNH
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  DutyDetailCard(
                    label: "Trạng thái:",
                    value: _assignment!.status,
                    valueColor: Colors.orange,
                  ),
                  DutyDetailCard(
                    label: "Tuần:",
                    value: "${_assignment!.weekNumber}/${_assignment!.year}",
                    valueColor: Colors.black,
                  ),
                  DutyDetailCard(
                    label: "Điểm thưởng:",
                    value: "${_duty!.points} điểm",
                    valueColor: Colors.black,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// TỔ PHỤ TRÁCH
            AssigneeCard(
              teamName: _team!.name,
              assignees: _members
                  .map(
                    (u) => {
                      "name": u.fullName,
                      "isLeader": u.isLeader,
                      "team": _team!.name,
                      "color": u.isLeader ? Colors.orange : Colors.grey,
                    },
                  )
                  .toList(),
            ),

            const SizedBox(height: 16),

            /// MÔ TẢ
            DutyDescriptionCard(description: _duty!.description),

            const SizedBox(height: 16),

            const Text(
              "Lịch sử xoay vòng",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            /// (Tạm dùng UI – có thể load Firestore sau)
            RotationHistoryItem(
              week: _assignment!.weekNumber,
              team: _team!.name,
              status: "Hiện tại",
              isCurrent: true,
            ),
          ],
        ),
      ),
    );
  }

  //BOTTOM ACTION BUTTON
  Widget? _buildBottomButton(bool isAdmin, bool isLeader, String status) {
    // MEMBER thường → không có nút
    if (!isAdmin && !isLeader) return null;

    // LEADER: chỉ CUỐI TUẦN + inprogress
    if (isLeader && status == 'inprogress' && _isEndOfWeek(_assignment!)) {
      return _buildButton(
        "Đã hoàn thành",
        Colors.blue,
        () => _updateStatus('pending_approval'),
      );
    }

    // ADMIN xác nhận
    if (isAdmin && status == 'pending_approval') {
      return _buildButton("Xác nhận hoàn thành", Colors.green, () async {
        final confirm = await ConfirmCompleteDialog.show(
          context,
          teamName: _team!.name,
          bonusPoint: _duty!.points,
        );

        if (confirm == true) {
          _updateStatus('done');
        }
      });
    }

    return null;
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
