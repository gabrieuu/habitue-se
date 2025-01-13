extension DateUtilsExtension on DateTime {
  bool isSameDate(DateTime date) {
    return (this).year == date.year &&
        (this).month == date.month &&
        (this).day == date.day;
  }
}
