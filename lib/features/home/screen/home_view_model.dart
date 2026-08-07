import 'package:clientta/core/network/network_status_port.dart';
import 'package:clientta/core/utils/commands.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/appointments/data/appointment_sync_service.dart';
import 'package:clientta/features/appointments/domain/models/appointment_status.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:clientta/features/appointments/domain/sync/sync_state.dart';

enum HomeSyncBannerState { hidden, offline, syncPending, syncing }

class HomeViewModel {
  HomeViewModel({
    required AppointmentRepository appointmentRepository,
    NetworkStatusPort? networkStatus,
    AppointmentSyncService? syncService,
    Future<bool> Function()? hasProSync,
  }) : _appointmentRepository = appointmentRepository,
       _networkStatus = networkStatus ?? const _AlwaysOnlineNetworkStatus(),
       _syncService = syncService,
       _hasProSync = hasProSync ?? (() async => false) {
    load = CommandBase(_load);
    markComplete = CommandAction<void, ServiceAppointment>(_markComplete);
    cancelAppointment = CommandAction<void, ServiceAppointment>(_cancelAppointment);
  }

  final AppointmentRepository _appointmentRepository;
  final NetworkStatusPort _networkStatus;
  final AppointmentSyncService? _syncService;
  final Future<bool> Function() _hasProSync;

  late final CommandBase<void> load;
  late final CommandAction<void, ServiceAppointment> markComplete;
  late final CommandAction<void, ServiceAppointment> cancelAppointment;

  List<ServiceAppointment> todayAppointments = [];
  HomeSyncBannerState syncBannerState = HomeSyncBannerState.hidden;
  DateTime? lastSyncedAt;
  bool showSyncIndicator = false;

  AppointmentSyncService? get syncService => _syncService;

  bool get isAppointmentActionRunning =>
      markComplete.running || cancelAppointment.running;

  /// Atualiza rótulo de sync e estado do banner (ex.: quando o sync notifica).
  Future<void> refreshSyncBanner() async {
    final sync = _syncService;
    if (sync != null) {
      lastSyncedAt = sync.state.lastSyncedAt;
    }
    await _refreshSyncBanner();
  }

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
