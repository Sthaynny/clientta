import 'package:clientta/core/plan/plan_access_policy.dart';
import 'package:clientta/core/utils/commands.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/appointments/data/appointment_reminder_coordinator.dart';
import 'package:clientta/features/appointments/data/appointment_sync_service.dart';
import 'package:clientta/features/appointments/domain/appointment_list_grouping.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:clientta/features/billing/domain/entities/user_subscription.dart';
import 'package:clientta/features/billing/domain/repositories/billing_repository.dart';

class DeleteAppointmentRequest {
  const DeleteAppointmentRequest({
    required this.id,
    this.seriesId,
    this.deleteEntireSeries = false,
  });

  final String id;
  final String? seriesId;
  final bool deleteEntireSeries;
}

class AppointmentsViewModel {
  AppointmentsViewModel({
    required AppointmentRepository repository,
    required BillingRepository billingRepository,
    AppointmentSyncService? syncService,
    AppointmentReminderCoordinator? reminderCoordinator,
  }) : _repository = repository,
       _billingRepository = billingRepository,
       _syncService = syncService,
       _reminderCoordinator = reminderCoordinator {
    load = CommandBase(_load);
    deleteEntry = CommandAction<void, DeleteAppointmentRequest>(_deleteEntry);
  }

  final AppointmentRepository _repository;
  final BillingRepository _billingRepository;
  final AppointmentSyncService? _syncService;
  final AppointmentReminderCoordinator? _reminderCoordinator;
  late final CommandBase<void> load;
  late final CommandAction<void, DeleteAppointmentRequest> deleteEntry;

  List<ServiceAppointment> entries = [];
  UserSubscription subscription = UserSubscription.inactive;

  bool get showPlanUsageBanner =>
      PlanAccessPolicy.shouldShowPlanGate(subscription);

  int get activeAppointmentsCount =>
      PlanAccessPolicy.countActiveAppointments(entries);

  int get activeSeriesCount => PlanAccessPolicy.countActiveSeries(entries);

  bool get isAtAppointmentLimit => !PlanAccessPolicy.canAddAppointment(
    subscription: subscription,
    existingAppointments: entries,
  );

  List<ServiceAppointment> sortedEntries() {
    final sorted = List<ServiceAppointment>.from(entries)
      ..sort((a, b) {
        final date = b.appointmentDate.compareTo(a.appointmentDate);
        if (date != 0) return date;
        return b.startTime.compareTo(a.startTime);
      });
    return sorted;
  }

  List<ServiceAppointment> filteredEntries(String? serviceTypeFilter) {
    final sorted = sortedEntries();
    if (serviceTypeFilter == null || serviceTypeFilter.isEmpty) {
      return sorted;
    }
    return sorted
        .where((entry) => entry.serviceType == serviceTypeFilter)
        .toList();
  }

  List<AppointmentListGroup> groupedEntries(String? serviceTypeFilter) {
    return groupAppointments(filteredEntries(serviceTypeFilter));
  }

  List<String> availableServiceTypes() {
    final types = entries.map((entry) => entry.serviceType).toSet().toList()
      ..sort();
    return types;
  }

  Future<Result<void>> _load() async {
    try {
      final sync = _syncService;
      if (sync != null && await sync.canSync()) {
        await sync.sync();
      }
      subscription = await _billingRepository.getSubscription();
      entries = await _repository.getAll();
      await _reminderCoordinator?.syncForAppointments(entries);
      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }

  Future<Result<void>> _deleteEntry(DeleteAppointmentRequest request) async {
    try {
      if (request.deleteEntireSeries &&
          request.seriesId != null &&
          request.seriesId!.isNotEmpty) {
        final all = await _repository.getAll();
        final ids =
            all
                .where((entry) => entry.seriesId == request.seriesId)
                .map((entry) => entry.id)
                .toList();
        await _repository.saveAll(const [], deleteIds: ids);
        for (final id in ids) {
          _syncService?.queueDelete(id);
        }
      } else {
        await _repository.delete(request.id);
        _syncService?.queueDelete(request.id);
      }
      _syncService?.scheduleSync();
      await load.execute();
      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }
}
