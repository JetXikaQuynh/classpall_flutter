class AppRoutes {
  static const home = '/';

  // Duty module (giữ nguyên của team)
  static const adminDashboardDuty = '/admin-dashboard-duty';
  static const memberDashboardDuty = '/member-dashboard-duty';
  static const createDuty = '/create-duty';
  static const dutyDetail = '/duty-detail';
  static const leaderboard = '/leaderboard';

  // Profile module (giữ nguyên)
  static const personalProfile = '/personal-profile';
  static const editProfile = '/edit-profile';
  static const permission = '/permission';

  // Dialogs
  static const addTeamDialog = '/add-team-dialog';
  static const deleteTeamDialog = '/delete-team-dialog';
  static const confirmDutyDialog = '/confirm-duty-dialog';

  // === PHẦN CỦA BẠN: Auth + Dashboard ===
  static const splash = '/splash';
  static const login = '/login';
  static const adminDashboard = '/admin-dashboard';
  static const memberDashboard = '/member-dashboard';
}