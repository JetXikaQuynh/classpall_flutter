int getCurrentWeekNumber() {
  DateTime date = DateTime.now();
  int dayOfWeek = date.weekday;
  DateTime thursday = date.add(Duration(days: 4 - dayOfWeek));

  // Lấy ngày 1/1 của năm chứa ngày Thứ Năm
  DateTime firstDayOfYear = DateTime(thursday.year, 1, 1);

  // Tính số ngày chênh lệch giữa Thứ Năm hiện tại và ngày đầu năm
  int diffInDays = thursday.difference(firstDayOfYear).inDays;

  // Công thức: (Số ngày chênh lệch / 7) làm tròn xuống + 1
  int weekNumber = (diffInDays / 7).floor() + 1;

  return weekNumber;
}
