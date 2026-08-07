import 'package:clientta/core/plan/plan_access_policy.dart';
import 'package:clientta/core/storage/app_profile_repository.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/appointments/domain/reminders/appointment_reminder_policy.dart';
import 'package:clientta/features/appointments/domain/reminders/appointment_reminder_scheduler.dart';
import 'package:clientta/features/billing/domain/repositories/billing_repository.dart';

/// Sincroniza alarmes do SO com a agenda local — somente Pro.
class AppointmentReminderCoordinator {
  AppointmentReminderCoordinator({
    required AppointmentReminderScheduler scheduler,
    required BillingRepository billingRepository,
    required AppProfileRepository appProfileRepository,
  }) : _scheduler = scheduler,
       _billingRepository = billingRepository,
       _appProfileRepository = appProfileRepository;

  final AppointmentReminderScheduler _scheduler;
  final BillingRepository _billingRepository;
  final AppProfileRepository _appProfileRepository;

  bool _initialized = false;

  Future<void> ensureReady() async {
    if (_initialized) return;
    await _scheduler.initialize();
    _initialized = true;
  }

  /// Reconcilia todos os lembretes com a lista atual de atendimentos.
  Future<void> syncForAppointments(List<ServiceAppointment> appointments) async {
    await ensureReady();

    final subscription = await _billingRepository.getSubscription();
    if (!PlanAccessPolicy.canScheduleLocalReminders(subscription)) {
      await _scheduler.cancelAll();
      return;
    }

    final profile = await _appProfileRepository.load();
    final settings = profile.appointmentReminders;
    if (!settings.enabled) {
      await _scheduler.cancelAll();
      return;
    }

    await _scheduler.requestPermissionsIfNeeded();

    await _scheduler.cancelAll();

    for (final appointment in appointments) {
      final fireAt = AppointmentReminderPolicy.fireAt(
        appointment: appointment,
        leadMinutes: settings.leadMinutes,
      );
      if (fireAt == null) continue;

      await _scheduler.scheduleAppointmentReminder(
        appointment: appointment,
        fireAt: fireAt,
        title: appointmentReminderTitleString,
        body: appointmentReminderBody(
          clientName: appointment.clientName,
          serviceType: appointment.serviceType,
          startTime: appointment.startTime,
        ),
      );
    }
  }

  /// Atualiza um único atendimento após save local.
  Future<void> syncForAppointment(
    ServiceAppointment appointment, {
    List<ServiceAppointment>? allAppointments,
  }) async {
    if (allAppointments != null) {
      await syncForAppointments(allAppointments);
      return;
    }
    await syncForAppointments([appointment]);
  }

  /// Mensagem para exibir quando Free tenta habilitar lembrete.
  static String proRequiredMessage() => planReminderProRequiredString;
}
