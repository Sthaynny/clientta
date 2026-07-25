/// Start/end times for one weekday slot in the class form.
class ClassDaySchedule {
  const ClassDaySchedule({
    required this.startTime,
    required this.endTime,
  });

  final String startTime;
  final String endTime;

  ClassDaySchedule copyWith({String? startTime, String? endTime}) {
    return ClassDaySchedule(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
