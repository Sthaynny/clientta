import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/utils/commands.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/appointments/data/appointment_sync_service.dart';
import 'package:clientta/features/client_care/domain/care_timeline_builder.dart';
import 'package:clientta/features/client_care/domain/encounter_session.dart';
import 'package:clientta/features/client_care/domain/models/care_timeline_entry.dart';
import 'package:clientta/features/client_care/domain/models/client_care_args.dart';
import 'package:clientta/features/client_care/domain/models/encounter_note.dart';
import 'package:clientta/features/client_care/domain/repositories/encounter_note_repository.dart';

enum AddEncounterNoteResult { saved, alreadyRegisteredToday }

class ClientCareViewModel {
  ClientCareViewModel({
    required EncounterNoteRepository encounterRepository,
    required ClientCareArgs args,
    AppointmentSyncService? syncService,
  }) : _encounterRepository = encounterRepository,
       _args = args,
       _syncService = syncService {
    load = CommandBase(_load);
    addNote = CommandAction<AddEncounterNoteResult, String>(_addNote);
  }

  final EncounterNoteRepository _encounterRepository;
  final ClientCareArgs _args;
  final AppointmentSyncService? _syncService;

  late final CommandBase<void> load;
  late final CommandAction<AddEncounterNoteResult, String> addNote;

  List<CareTimelineEntry> timeline = [];

  ClientCareArgs get args => _args;

  Future<Result<void>> _load() async {
    try {
      final encounterNotes = await _encounterRepository.getByClientPhone(
        _args.clientPhone,
      );
      timeline = buildCareTimeline(encounterNotes: encounterNotes);
      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }

  Future<Result<AddEncounterNoteResult>> _addNote(String body) async {
    try {
      final trimmed = body.trim();
      final existing = await _encounterRepository.getByClientPhone(
        _args.clientPhone,
      );

      if (trimmed.isEmpty) {
        if (hasEncounterSessionToday(
          existing,
          sessionBody: encounterStartedDefaultBodyString,
        )) {
          return const Result.ok(AddEncounterNoteResult.alreadyRegisteredToday);
        }
      }

      final noteBody =
          trimmed.isEmpty ? encounterStartedDefaultBodyString : trimmed;

      final note = EncounterNote(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        clientPhone: _args.clientPhone,
        clientName: _args.clientName,
        serviceType: _args.serviceType,
        body: noteBody,
        createdAt: DateTime.now(),
      );
      await _encounterRepository.save(note);
      _syncService?.scheduleSync();
      await load.execute();
      return const Result.ok(AddEncounterNoteResult.saved);
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }
}
