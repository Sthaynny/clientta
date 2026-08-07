import 'package:clientta/features/appointments/domain/appointment_client_match.dart';
import 'package:clientta/features/client_care/domain/models/encounter_note.dart';

List<EncounterNote> propagateClientIdentityToEncounterNotes({
  required List<EncounterNote> notes,
  required String previousPhone,
  required String newClientName,
  required String newClientPhone,
}) {
  final trimmedName = newClientName.trim();
  final updates = <EncounterNote>[];

  for (final note in notes) {
    if (!phonesMatch(note.clientPhone, previousPhone)) continue;
    if (note.clientName.trim() == trimmedName &&
        phonesMatch(note.clientPhone, newClientPhone)) {
      continue;
    }

    updates.add(
      note.copyWith(
        clientName: trimmedName,
        clientPhone: newClientPhone,
      ),
    );
  }

  return updates;
}
