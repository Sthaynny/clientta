import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/utils/result.dart';

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
    return Result.errorDefault(errorAppointmentStartTimeInvalidString);
  }
  final endMinutes = _minutesFromHhMm(endTime);
  if (endMinutes == null) {
    return Result.errorDefault(errorAppointmentEndTimeInvalidString);
  }
  if (endMinutes <= startMinutes) {
    return Result.errorDefault(errorAppointmentEndBeforeStartString);
  }
  return Result.ok();
}

Result<void> validateAppointmentForm({
  required String clientName,
  required String clientPhone,
  required String serviceType,
  required String startTime,
  required String endTime,
}) {
  if (clientName.trim().isEmpty) {
    return Result.errorDefault(errorClientNameRequiredString);
  }
  if (clientPhone.trim().isEmpty) {
    return Result.errorDefault(errorClientPhoneRequiredString);
  }
  if (serviceType.trim().isEmpty) {
    return Result.errorDefault(errorServiceTypeRequiredString);
  }
  return _validateTimeRange(startTime, endTime);
}
