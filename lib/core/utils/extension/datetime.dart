extension DatetimeExt on DateTime {
  String get toDateAt {
    final String day = this.day.toString().padLeft(2, '0');
    final String month = this.month.toString().padLeft(2, '0');
    final String year = this.year.toString();
    return '$day/$month/$year';
  }
}
