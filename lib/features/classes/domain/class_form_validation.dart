import 'package:university_hub/core/strings/daily_strings.dart';
import 'package:university_hub/core/utils/result.dart';
import 'package:university_hub/features/classes/domain/models/class_day_schedule.dart';

final _timePattern = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');

int? _minutesFromHhMm(String value) {
  final trimmed = value.trim();
  if (!_timePattern.hasMatch(trimmed)) return null;
  final parts = trimmed.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  return hour * 60 + minute;
}

Result<void> _validateTimeRange(String startTime, String endTime) {
  final startMinutes = _minutesFromHhMm(startTime);
  if (startMinutes == null) {
    return Result.errorDefault(errorClassStartTimeInvalidString);
  }
  final endMinutes = _minutesFromHhMm(endTime);
  if (endMinutes == null) {
    return Result.errorDefault(errorClassEndTimeInvalidString);
  }
  if (endMinutes <= startMinutes) {
    return Result.errorDefault(errorClassEndBeforeStartString);
  }
  return Result.ok();
}

Result<void> validateClassForm({
  required Set<int> selectedWeekdays,
  required String subject,
  required bool sameTimeForAllDays,
  required String startTime,
  required String endTime,
  required Map<int, ClassDaySchedule> perDayTimes,
}) {
  if (selectedWeekdays.isEmpty) {
    return Result.errorDefault(errorClassWeekdayRequiredString);
  }
  if (subject.trim().isEmpty) {
    return Result.errorDefault(errorClassSubjectRequiredString);
  }

  if (sameTimeForAllDays) {
    return _validateTimeRange(startTime, endTime);
  }

  for (final weekday in selectedWeekdays) {
    final slot = perDayTimes[weekday];
    if (slot == null) {
      return Result.errorDefault(errorClassPerDayTimeMissingString);
    }
    final result = _validateTimeRange(slot.startTime, slot.endTime);
    if (result.isError) return result;
  }

  return Result.ok();
}
