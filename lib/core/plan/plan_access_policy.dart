import 'package:clientta/features/appointments/domain/models/appointment_status.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/billing/domain/entities/user_subscription.dart';

abstract final class PlanAccessPolicy {
  static const int freeMaxActiveAppointments = 50;
  static const int freeMaxActiveSeries = 3;

  static bool hasProAccess(UserSubscription subscription) {
    return subscription.allowsOperationalAccess;
  }

  static bool canAccessOperationalFeatures(UserSubscription subscription) {
    return hasProAccess(subscription);
  }

  static bool canScheduleLocalReminders(UserSubscription subscription) {
    return hasProAccess(subscription);
  }

  static bool canImportDataBackup(UserSubscription subscription) {
    return canExportDataBackup(subscription);
  }

  static bool canExportDataBackup(UserSubscription subscription) {
    return hasProAccess(subscription);
  }

  static bool canAccessCloudSync(UserSubscription subscription) {
    return hasProAccess(subscription);
  }

  static bool shouldShowPlanGate(UserSubscription subscription) {
    return !canAccessOperationalFeatures(subscription);
  }

  static bool canAddAppointment({
    required UserSubscription subscription,
    required List<ServiceAppointment> existingAppointments,
    bool isEdit = false,
    int additionalCount = 1,
  }) {
    if (hasProAccess(subscription)) return true;
    if (isEdit) return true;
    if (additionalCount < 1) return true;

    return countActiveAppointments(existingAppointments) + additionalCount <=
        freeMaxActiveAppointments;
  }

  static bool canCreateSeries({
    required UserSubscription subscription,
    required List<ServiceAppointment> existingAppointments,
  }) {
    if (hasProAccess(subscription)) return true;

    return countActiveSeries(existingAppointments) < freeMaxActiveSeries;
  }

  static int countActiveAppointments(List<ServiceAppointment> appointments) {
    return appointments
        .where(
          (appointment) =>
              appointment.status != AppointmentStatus.cancelado.value,
        )
        .length;
  }

  static int countActiveSeries(List<ServiceAppointment> appointments) {
    final activeSeriesIds = <String>{};
    for (final appointment in appointments) {
      final seriesId = appointment.seriesId;
      if (seriesId == null || seriesId.isEmpty) continue;
      if (appointment.status == AppointmentStatus.cancelado.value) continue;
      activeSeriesIds.add(seriesId);
    }
    return activeSeriesIds.length;
  }
}
