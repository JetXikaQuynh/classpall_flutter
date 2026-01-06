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

  //Notification
  static const notification = '/notification';

  // Auth + Dashboard + resetpassword
  static const splash = '/splash';
  static const login = '/login';
  static const adminDashboard = '/admin-dashboard';
  static const memberDashboard = '/member-dashboard';
  static const changePassword = '/change-password';


  // ================= EVENT MODULE =================

  // Admin
  static const adminEventList = '/admin-event-list';
  static const adminEventDetail = '/admin-event-detail';
  static const adminEventCreate = '/admin-event-create';

  // Member
  static const memberEventList = '/member-event-list';

  // ============== Fund ================
  static const fund = '/fund';
  static const fundCollection = '/fund-collection';
  static const expense = '/expense';
  // ================ ASSETS CHECKOUT ================
  static const assetHistory = '/asset-history';
  static const assets = '/assets';
}
