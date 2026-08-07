import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clientta/features/client_care/domain/models/encounter_note.dart';
import 'package:clientta/features/client_care/domain/repositories/encounter_note_repository_remote.dart';

class EncounterNoteRepositoryRemoteFirestore
    implements EncounterNoteRepositoryRemote {
  EncounterNoteRepositoryRemoteFirestore({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String userId) =>
      _firestore.collection('users').doc(userId).collection('encounterNotes');

  @override
  Future<List<EncounterNote>> fetchAll(String userId) async {
    final snapshot = await _collection(userId).get();
    return snapshot.docs.map(_fromFirestore).toList();
  }

  @override
  Future<void> upsert(String userId, EncounterNote note) async {
    final data = _toFirestore(userId, note);
    await _collection(userId).doc(note.id).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> delete(String userId, String noteId) async {
    await _collection(userId).doc(noteId).delete();
  }

  EncounterNote _fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = Map<String, dynamic>.from(doc.data());
    data['id'] = doc.id;
    data['createdAt'] = _timestampToIso(data['createdAt']);
    data['updatedAt'] = _timestampToIso(data['updatedAt']);
    return EncounterNote.fromMap(data);
  }

  Map<String, dynamic> _toFirestore(String userId, EncounterNote note) {
    final map = note.toMap();
    map['userId'] = userId;
    final updatedAt = note.updatedAt ?? DateTime.now();
    map['updatedAt'] = Timestamp.fromDate(updatedAt);
    map['createdAt'] = Timestamp.fromDate(note.createdAt);
    return map;
  }

  String? _timestampToIso(dynamic value) {
    if (value is Timestamp) {
      return value.toDate().toIso8601String();
    }
    if (value is String) return value;
    return null;
  }
}
