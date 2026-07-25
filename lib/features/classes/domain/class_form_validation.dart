import 'package:ufersa_hub/core/strings/daily_strings.dart';
import 'package:ufersa_hub/core/utils/result.dart';

final _timePattern = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');

int? _minutesFromHhMm(String value) {
  final trimmed = value.trim();
  if (!_timePattern.hasMatch(trimmed)) return null;
  final parts = trimmed.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  return hour * 60 + minute;
}

Result<void> validateClassForm({
  required Set<int> selectedWeekdays,
  required String subject,
  required String startTime,
  required String endTime,
}) {
  if (selectedWeekdays.isEmpty) {
    return Result.errorDefault(errorClassWeekdayRequiredString);
  }
  if (subject.trim().isEmpty) {
    return Result.errorDefault(errorClassSubjectRequiredString);
  }
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
