class AuthService {
  // Biến static để lưu trạng thái Role toàn cục
  // false = Member, true = Admin
  static bool isAdmin = false;

  // Hàm này sẽ được gọi ở màn hình Login sau khi kiểm tra tài khoản thành công
  static void setRole(bool adminStatus) {
    isAdmin = adminStatus;
  }
}
