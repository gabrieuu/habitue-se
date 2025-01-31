extension DateUtilsExtension on DateTime {
  bool isSameDate(DateTime date) {
    return (this).year == date.year &&
        (this).month == date.month &&
        (this).day == date.day;
  }

  DateTime toFullYear() {
    return DateTime((this).year, (this).month, (this).day);
  }

  String get formatDateString{
    var date = (this).toIso8601String().split('T')[0].split('-');
    return date.reversed.join('/');

  }
}
