class AppRoutes {
  static const home = '/';

  // Duty module
  static const adminDashboardDuty = '/admin-dashboard-duty';
  static const memberDashboardDuty = '/member-dashboard-duty';
  static const createDuty = '/create-duty';
  static const dutyDetail = '/duty-detail';
  static const leaderboard = '/leaderboard';

  // Profile module
  static const personalProfile = '/personal-profile';
  static const editProfile = '/edit-profile';
  static const permission = '/permission';

  // Dialogs (không dùng pushNamed, nhưng vẫn khai báo nếu cần)
  static const addTeamDialog = '/add-team-dialog';
  static const deleteTeamDialog = '/delete-team-dialog';
  static const confirmDutyDialog = '/confirm-duty-dialog';
}
