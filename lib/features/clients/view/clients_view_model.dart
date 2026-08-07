import 'package:clientta/core/utils/commands.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/appointments/data/appointment_sync_service.dart';
import 'package:clientta/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:clientta/features/client_care/domain/repositories/encounter_note_repository.dart';
import 'package:clientta/features/clients/domain/client_profile_aggregator.dart';
import 'package:clientta/features/clients/domain/models/client_profile.dart';

class ClientsViewModel {
  ClientsViewModel({
    required AppointmentRepository appointmentRepository,
    required EncounterNoteRepository encounterRepository,
    AppointmentSyncService? syncService,
  }) : _appointmentRepository = appointmentRepository,
       _encounterRepository = encounterRepository,
       _syncService = syncService {
    load = CommandBase(_load);
  }

  final AppointmentRepository _appointmentRepository;
  final EncounterNoteRepository _encounterRepository;
  final AppointmentSyncService? _syncService;

  late final CommandBase<void> load;

  List<ClientProfile> profiles = [];
  String searchQuery = '';

  List<ClientProfile> get visibleProfiles =>
      filterClientProfiles(profiles, searchQuery);

  void setSearchQuery(String value) {
    searchQuery = value;
  }

  Future<Result<void>> _load() async {
    try {
      final sync = _syncService;
      if (sync != null && await sync.canSync()) {
        await sync.sync();
      }
      final appointments = await _appointmentRepository.getAll();
      final encounterNotes = await _encounterRepository.getAll();
      profiles = buildClientProfiles(
        appointments: appointments,
        encounterNotes: encounterNotes,
      );
      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }
}
