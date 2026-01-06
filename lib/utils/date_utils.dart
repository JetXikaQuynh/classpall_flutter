//hàm lấy số tuần trong năm hiện tại và trả về số tuần đó
int getCurrentWeekNumber() {
  final now = DateTime.now();
  final firstDayOfYear = DateTime(now.year, 1, 1);
  final days = now.difference(firstDayOfYear).inDays;
  return ((days + firstDayOfYear.weekday) / 7).ceil();
}
