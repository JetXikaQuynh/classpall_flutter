import 'package:flutter/material.dart';

import '../../models/duty_models/duty_assignment_model.dart';
import '../../models/duty_models/duty_model.dart';
import '../../models/duty_models/team_model.dart';

import '../../services/duty_services/duty_assignment_service.dart';
import '../../services/duty_services/duty_service.dart';
import '../../services/duty_services/team_service.dart';

import '../../widgets/duty/progress_card.dart';
import '../../widgets/duty/leaderboard_card.dart';
import '../../widgets/duty/duty_item.dart';
import '../../../widgets/custom_bottom_bar.dart';
import '../../routes/app_routes.dart';

class AdminDashboardDuty extends StatefulWidget {
  const AdminDashboardDuty({super.key});

  @override
  State<AdminDashboardDuty> createState() => _AdminDashboardDutyState();
}

class _AdminDashboardDutyState extends State<AdminDashboardDuty> {
  final _assignmentService = DutyAssignmentService();
  final _dutyService = DutyService();
  final _teamService = TeamService();

  /// cache để join
  Map<String, DutyModel> _dutyMap = {};
  Map<String, TeamModel> _teamMap = {};

  // track IDs that are currently being fetched to avoid duplicate network calls
  final Set<String> _loadingDutyIds = {};
  final Set<String> _loadingTeamIds = {};

  @override
  void initState() {
    super.initState();
    _loadStaticData();
    _assignmentService.autoMarkLateAssignments();
  }

  /// 🔥 load duties + teams 1 lần
  Future<void> _loadStaticData() async {
    final duties = await _dutyService.getAllDuties();
    final teams = await _teamService.getAllTeams();

    setState(() {
      _dutyMap = {for (var d in duties) d.id: d};
      _teamMap = {for (var t in teams) t.id: t};
    });
  }

  /// Ensure that every assignment references a loaded duty/team; lazy-load missing ones
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
              setState(() {
                _dutyMap[id] = duty;
              });
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
              setState(() {
                _teamMap[id] = team;
              });
            }
          })
          .whenComplete(() => _loadingTeamIds.remove(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Phân công trực nhật"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 0),

      /// 🔥🔥🔥 REALTIME HERE
      body: StreamBuilder<List<DutyAssignmentModel>>(
        stream: _assignmentService.watchAssignments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final assignments = snapshot.data!;

          // make sure we have duty/team data for any referenced ids (lazy-load if needed)
          _ensureReferencedDataPresent(assignments);

          /// 🔥 JOIN DỮ LIỆU
          final items = assignments.map((a) {
            final duty = _dutyMap[a.dutyId];
            final team = _teamMap[a.teamId];

            return _DutyAssignmentView(
              assignmentId: a.id,
              dutyName: duty?.name ?? 'Không xác định',
              teamName: team?.name ?? 'Không xác định',
              status: a.status,
              week: a.weekNumber,
              year: a.year,
            );
          }).toList();

          final completed = items.where((e) => e.status == 'done').length;
          final inProgress = items
              .where((e) => e.status == 'inprogress')
              .length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProgressCard(
                  total: items.length,
                  completed: completed,
                  inProgress: inProgress,
                  onCreate: () {
                    Navigator.pushNamed(context, AppRoutes.createDuty);
                  },
                ),

                const SizedBox(height: 16),

                // Build leaderboard top 3 from current assignments + duties + teams
                Builder(
                  builder: (context) {
                    final pointsMap = <String, int>{};
                    for (var t in _teamMap.values) pointsMap[t.id] = 0;

                    for (var a in assignments) {
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
                        Navigator.pushNamed(context, AppRoutes.leaderboard);
                      },
                    );
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  "Tất cả nhiệm vụ:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                ...items.map(
                  (item) => DutyItem(
                    title: item.dutyName,
                    team: item.teamName,
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
  final String teamName;
  final String status;
  final int week;
  final int year;

  _DutyAssignmentView({
    required this.assignmentId,
    required this.dutyName,
    required this.teamName,
    required this.status,
    required this.week,
    required this.year,
  });
}
