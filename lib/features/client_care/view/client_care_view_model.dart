import 'package:clientta/core/utils/commands.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:clientta/features/client_care/domain/care_timeline_builder.dart';
import 'package:clientta/features/client_care/domain/models/care_timeline_entry.dart';
import 'package:clientta/features/client_care/domain/models/client_care_args.dart';
import 'package:clientta/features/client_care/domain/models/encounter_note.dart';
import 'package:clientta/features/client_care/domain/repositories/encounter_note_repository.dart';

class ClientCareViewModel {
  ClientCareViewModel({
    required EncounterNoteRepository encounterRepository,
    required AppointmentRepository appointmentRepository,
    required ClientCareArgs args,
  }) : _encounterRepository = encounterRepository,
       _appointmentRepository = appointmentRepository,
       _args = args {
    load = CommandBase(_load);
    addNote = CommandAction<void, String>(_addNote);
  }

  final EncounterNoteRepository _encounterRepository;
  final AppointmentRepository _appointmentRepository;
  final ClientCareArgs _args;

  late final CommandBase<void> load;
  late final CommandAction<void, String> addNote;

  List<CareTimelineEntry> timeline = [];

  ClientCareArgs get args => _args;

  Future<Result<void>> _load() async {
    try {
      final encounterNotes = await _encounterRepository.getByClientPhone(
        _args.clientPhone,
      );
      final appointments = await _appointmentRepository.getAll();
      timeline = buildCareTimeline(
        clientPhone: _args.clientPhone,
        encounterNotes: encounterNotes,
        appointments: appointments,
      );
      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }

  Future<Result<void>> _addNote(String body) async {
    try {
      final trimmed = body.trim();
      if (trimmed.isEmpty) {
        return Result.errorDefault('empty');
      }

      final note = EncounterNote(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        clientPhone: _args.clientPhone,
        clientName: _args.clientName,
        serviceType: _args.serviceType,
        appointmentId: _args.appointmentId,
        body: trimmed,
        createdAt: DateTime.now(),
      );
      await _encounterRepository.save(note);
      await load.execute();
      return Result.ok();
    } catch (e) {
      return Result.errorDefault(e.toString());
    }
  }
}
