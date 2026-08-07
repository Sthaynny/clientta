import 'package:clientta/core/utils/commands.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/appointments/data/appointment_sync_service.dart';
import 'package:clientta/features/appointments/domain/appointment_list_grouping.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/appointments/domain/repositories/appointment_repository.dart';

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
    AppointmentSyncService? syncService,
  }) : _repository = repository,
       _syncService = syncService {
    load = CommandBase(_load);
    deleteEntry = CommandAction<void, DeleteAppointmentRequest>(_deleteEntry);
  }

  final AppointmentRepository _repository;
  final AppointmentSyncService? _syncService;
  late final CommandBase<void> load;
  late final CommandAction<void, DeleteAppointmentRequest> deleteEntry;

  List<ServiceAppointment> entries = [];

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
      entries = await _repository.getAll();
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
