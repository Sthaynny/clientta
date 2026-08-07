import 'package:clientta/core/network/network_status_port.dart';
import 'package:clientta/core/utils/commands.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/appointments/data/appointment_sync_service.dart';
import 'package:clientta/features/appointments/domain/models/appointment_status.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:clientta/features/appointments/domain/sync/sync_state.dart';
import 'package:clientta/features/client_care/domain/models/encounter_note.dart';
import 'package:clientta/features/client_care/domain/repositories/encounter_note_repository.dart';

class QuickNotesInput {
  const QuickNotesInput({required this.appointment, required this.notes});

  final ServiceAppointment appointment;
  final String notes;
}

enum HomeSyncBannerState { hidden, offline, syncPending, syncing }

class HomeViewModel {
  HomeViewModel({
    required AppointmentRepository appointmentRepository,
    EncounterNoteRepository? encounterNoteRepository,
    NetworkStatusPort? networkStatus,
    AppointmentSyncService? syncService,
    Future<bool> Function()? hasProSync,
  }) : _appointmentRepository = appointmentRepository,
       _encounterNoteRepository = encounterNoteRepository,
       _networkStatus = networkStatus ?? const _AlwaysOnlineNetworkStatus(),
       _syncService = syncService,
       _hasProSync = hasProSync ?? (() async => false) {
    load = CommandBase(_load);
    markComplete = CommandAction<void, ServiceAppointment>(_markComplete);
    updateNotes = CommandAction<void, QuickNotesInput>(_updateNotes);
    cancelAppointment = CommandAction<void, ServiceAppointment>(_cancelAppointment);
  }

  final AppointmentRepository _appointmentRepository;
  final EncounterNoteRepository? _encounterNoteRepository;
  final NetworkStatusPort _networkStatus;
  final AppointmentSyncService? _syncService;
  final Future<bool> Function() _hasProSync;

  late final CommandBase<void> load;
  late final CommandAction<void, ServiceAppointment> markComplete;
  late final CommandAction<void, QuickNotesInput> updateNotes;
  late final CommandAction<void, ServiceAppointment> cancelAppointment;

  List<ServiceAppointment> todayAppointments = [];
  HomeSyncBannerState syncBannerState = HomeSyncBannerState.hidden;
  DateTime? lastSyncedAt;
  bool showSyncIndicator = false;

  AppointmentSyncService? get syncService => _syncService;

  Future<Result<void>> _load() async {
    try {
      final sync = _syncService;
      if (sync != null) {
        await sync.loadPersistedState();
        final isPro = await _hasProSync();
        if (isPro) {
          await sync.sync();
        }
        lastSyncedAt = sync.state.lastSyncedAt;
        showSyncIndicator = isPro;
      }

      final now = DateTime.now();
      final appointments = await _appointmentRepository.getAll();
      todayAppointments = filterTodayAppointments(appointments, reference: now);

      await _refreshSyncBanner();

      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }

  Future<void> _refreshSyncBanner() async {
    final online = await _networkStatus.isOnline();
    final sync = _syncService;
    final isPro = await _hasProSync();

    if (sync != null && sync.state.isSyncing) {
      syncBannerState = HomeSyncBannerState.syncing;
      return;
    }

    if (!online) {
      syncBannerState =
          isPro ? HomeSyncBannerState.syncPending : HomeSyncBannerState.offline;
      return;
    }

    if (isPro &&
        sync != null &&
        (sync.state.hasPendingChanges || sync.state.phase == SyncPhase.error)) {
      syncBannerState = HomeSyncBannerState.syncPending;
      return;
    }

    syncBannerState = HomeSyncBannerState.hidden;
  }

  void _scheduleSync() => _syncService?.scheduleSync();

  Future<Result<void>> _markComplete(ServiceAppointment entry) async {
    try {
      final updated = entry.copyWith(
        status: AppointmentStatus.concluido.value,
      );
      await _appointmentRepository.save(updated);
      _scheduleSync();
      await load.execute();
      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }

  Future<Result<void>> _updateNotes(QuickNotesInput input) async {
    try {
      final trimmed = input.notes.trim();
      if (trimmed.isEmpty) {
        return Result.errorDefault('empty');
      }

      final encounterRepo = _encounterNoteRepository;
      if (encounterRepo != null) {
        final note = EncounterNote(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          clientPhone: input.appointment.clientPhone,
          clientName: input.appointment.clientName,
          serviceType: input.appointment.serviceType,
          appointmentId: input.appointment.id,
          body: trimmed,
          createdAt: DateTime.now(),
        );
        await encounterRepo.save(note);
      }

      final updated = input.appointment.copyWith(notes: trimmed);
      await _appointmentRepository.save(updated);
      _scheduleSync();
      await load.execute();
      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }

  Future<Result<void>> _cancelAppointment(ServiceAppointment entry) async {
    try {
      final updated = entry.copyWith(
        status: AppointmentStatus.cancelado.value,
      );
      await _appointmentRepository.save(updated);
      _scheduleSync();
      await load.execute();
      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }

  /// Filtra atendimentos do dia corrente, excluindo cancelados.
  static List<ServiceAppointment> filterTodayAppointments(
    List<ServiceAppointment> appointments, {
    required DateTime reference,
  }) {
    return appointments
        .where(
          (appointment) =>
              _isSameDay(appointment.appointmentDate, reference) &&
              appointment.status != AppointmentStatus.cancelado.value,
        )
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _AlwaysOnlineNetworkStatus implements NetworkStatusPort {
  const _AlwaysOnlineNetworkStatus();

  @override
  Future<bool> isOnline() async => true;
}
