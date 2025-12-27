import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/duty_models/duty_assignment_model.dart';
import '../../models/duty_models/duty_model.dart';
import '../../models/duty_models/team_model.dart';
import '../../models/user_model.dart';

import '../../services/duty_services/duty_assignment_service.dart';
import '../../services/duty_services/duty_service.dart';
import '../../services/duty_services/team_service.dart';
import '../../services/user_service.dart';

import '../../widgets/duty/duty_item.dart';
import '../../widgets/duty/leaderboard_card.dart';
import '../../../widgets/custom_bottom_bar.dart';
import '../../routes/app_routes.dart';

class MemberDashboardDuty extends StatefulWidget {
  const MemberDashboardDuty({super.key});

  @override
  State<MemberDashboardDuty> createState() => _MemberDashboardDutyState();
}

class _MemberDashboardDutyState extends State<MemberDashboardDuty> {
  /// SERVICES
  final _assignmentService = DutyAssignmentService();
  final _dutyService = DutyService();
  final _teamService = TeamService();
  final _userService = UserService();

  /// CACHE
  Map<String, DutyModel> _dutyMap = {};
  Map<String, TeamModel> _teamMap = {};

  final Set<String> _loadingDutyIds = {};
  final Set<String> _loadingTeamIds = {};

  UserModel? _currentUser;
  TeamModel? _myTeam;

  bool _loadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadUserAndStaticData();
    _assignmentService.autoMarkLateAssignments();
  }

  /// 🔥 Load user + teams + duties
  Future<void> _loadUserAndStaticData() async {
    setState(() => _loadingUser = true);

    try {
      // debug trace
      // ignore: avoid_print
      print('MemberDashboard: start loading user and static data');

      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        setState(() => _loadingUser = false);
        // ignore: avoid_print
        print('MemberDashboard: no firebase user');
        return;
      }

      final uid = currentUser.uid;

      final user = await _userService.getUserById(uid);
      // ignore: avoid_print
      print('MemberDashboard: user fetched: ${user?.id}');
      if (user == null) {
        setState(() => _loadingUser = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Người dùng không tồn tại')),
        );
        return;
      }

      final duties = await _dutyService.getAllDuties();
      final teams = await _teamService.getAllTeams();
      // ignore: avoid_print
      print(
        'MemberDashboard: loaded ${duties.length} duties and ${teams.length} teams',
      );

      // try to find team by id
      TeamModel? foundTeam;
      for (var t in teams) {
        if (t.id == user.teamId) {
          foundTeam = t;
          break;
        }
      }

      // fallback: maybe user.teamId actually stores the TEAM NAME
      if (foundTeam == null) {
        for (var t in teams) {
          if (t.name.toLowerCase() == user.teamId.toLowerCase()) {
            foundTeam = t;
            // try to auto-fix the user's teamId to the real id
            try {
              await _userService.updateUserTeam(user.id, t.id);
              // ignore: avoid_print
              print(
                'Auto-fixed user ${user.id} teamId from name "${user.teamId}" to id "${t.id}"',
              );
            } catch (e) {
              // ignore: avoid_print
              print('Auto-fix failed: $e');
            }
            break;
          }
        }
      }

      setState(() {
        _currentUser = user;
        _myTeam = foundTeam; // may be null

        _dutyMap = {for (var d in duties) d.id: d};
        _teamMap = {for (var t in teams) t.id: t};

        _loadingUser = false;
      });

      if (foundTeam == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Tổ "${user.teamId}" không tìm thấy. Vui lòng liên hệ admin.',
            ),
          ),
        );

        print(
          'MemberDashboard: user ${user.id} teamId=${user.teamId} not found',
        );
      }
    } catch (e, st) {
      setState(() => _loadingUser = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải dữ liệu: ${e.toString()}')),
      );
      // ignore: avoid_print
      print('Error loading user/static data: $e\n$st');
    }
  }

  /// Lazy-load nếu thiếu duty / team
  void _ensureReferencedDataPresent(List<DutyAssignmentModel> assignments) {
    final missingDutyIds = assignments
        .map((a) => a.dutyId)
        .where(
          (id) => !_dutyMap.containsKey(id) && !_loadingDutyIds.contains(id),
        )
        .toSet();

    final missingTeamIds = assignments
        .map((a) => a.teamId)
        .where(
          (id) => !_teamMap.containsKey(id) && !_loadingTeamIds.contains(id),
        )
        .toSet();

    for (final id in missingDutyIds) {
      _loadingDutyIds.add(id);
      _dutyService
          .getDutyById(id)
          .then((duty) {
            if (duty != null) {
              setState(() => _dutyMap[id] = duty);
            }
          })
          .whenComplete(() => _loadingDutyIds.remove(id));
    }

    for (final id in missingTeamIds) {
      _loadingTeamIds.add(id);
      _teamService
          .getTeamById(id)
          .then((team) {
            if (team != null) {
              setState(() => _teamMap[id] = team);
            }
          })
          .whenComplete(() => _loadingTeamIds.remove(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingUser) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
          "Phân công trực nhật",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      bottomNavigationBar: const CustomBottomBar(currentIndex: 0),

      /// REALTIME ASSIGNMENTS CỦA TỔ
      body: (_myTeam == null)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Tổ của bạn chưa được cấu hình.'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _loadUserAndStaticData,
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            )
          : StreamBuilder<List<DutyAssignmentModel>>(
              stream: _assignmentService.watchAssignmentsByTeam(_myTeam!.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  // ignore: avoid_print
                  print('MemberDashboard: assignments snapshot no data yet');
                  return const Center(child: CircularProgressIndicator());
                }

                final assignments = snapshot.data!;
                // ignore: avoid_print
                print(
                  'MemberDashboard: assignments count=${assignments.length}',
                );
                _ensureReferencedDataPresent(assignments);

                final items = assignments.map((a) {
                  final duty = _dutyMap[a.dutyId];
                  return _DutyAssignmentView(
                    assignmentId: a.id,
                    dutyName: duty?.name ?? 'Không xác định',
                    status: a.status,
                    week: a.weekNumber,
                    year: a.year,
                  );
                }).toList();

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🔵 BOX TỔ CỦA BẠN
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade600,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Tổ của bạn",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  _myTeam!.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// 🏆 LEADERBOARD (DÙNG CHUNG)
                      StreamBuilder<List<DutyAssignmentModel>>(
                        stream: _assignmentService.watchAssignments(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox(
                              height: 120,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final allAssignments = snapshot.data!;

                          // make sure we have duty/team data for referenced ids
                          _ensureReferencedDataPresent(allAssignments);

                          final pointsMap = <String, int>{};
                          for (var t in _teamMap.values) pointsMap[t.id] = 0;

                          for (var a in allAssignments) {
                            if (a.status == 'done') {
                              final duty = _dutyMap[a.dutyId];
                              if (duty != null) {
                                pointsMap[a.teamId] =
                                    (pointsMap[a.teamId] ?? 0) + duty.points;
                              }
                            }
                          }

                          final leaderboardList =
                              pointsMap.entries.map((e) {
                                final team = _teamMap[e.key];
                                return {
                                  "id": e.key,
                                  "name": team?.name ?? 'Không xác định',
                                  "points": e.value,
                                };
                              }).toList()..sort(
                                (a, b) => (b['points'] as int? ?? 0).compareTo(
                                  a['points'] as int? ?? 0,
                                ),
                              );

                          final top3 = leaderboardList.take(3).toList();
                          for (int i = 0; i < top3.length; i++)
                            top3[i]['rank'] = i + 1;

                          return LeaderboardCard(
                            teams: top3,
                            onViewAll: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.leaderboard,
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Nhiệm vụ tổ bạn:",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// 🔥 DUTY LIST
                      ...items.map(
                        (item) => DutyItem(
                          title: item.dutyName,
                          team: _myTeam!.name,
                          deadline: "Tuần ${item.week}/${item.year}",
                          status: item.status,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.dutyDetail,
                              arguments: item.assignmentId,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

/// VIEW MODEL
class _DutyAssignmentView {
  final String assignmentId;
  final String dutyName;
  final String status;
  final int week;
  final int year;

  _DutyAssignmentView({
    required this.assignmentId,
    required this.dutyName,
    required this.status,
    required this.week,
    required this.year,
  });
}
