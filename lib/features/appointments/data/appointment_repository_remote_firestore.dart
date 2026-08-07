import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/appointments/domain/repositories/appointment_repository_remote.dart';

class AppointmentRepositoryRemoteFirestore
    implements AppointmentRepositoryRemote {
  AppointmentRepositoryRemoteFirestore({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String userId) =>
      _firestore.collection('users').doc(userId).collection('appointments');

  @override
  Future<List<ServiceAppointment>> fetchAll(String userId) async {
    final snapshot = await _collection(userId).get();
    return snapshot.docs.map(_fromFirestore).toList();
  }

  @override
  Future<void> upsert(String userId, ServiceAppointment entry) async {
    final data = _toFirestore(userId, entry);
    await _collection(userId).doc(entry.id).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> delete(String userId, String appointmentId) async {
    await _collection(userId).doc(appointmentId).delete();
  }

  ServiceAppointment _fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = Map<String, dynamic>.from(doc.data());
    data['id'] = doc.id;
    data['updatedAt'] = _timestampToIso(data['updatedAt']);
    return ServiceAppointment.fromMap(data);
  }

  Map<String, dynamic> _toFirestore(String userId, ServiceAppointment entry) {
    final map = entry.toMap();
    map['userId'] = userId;
    final updatedAt = entry.updatedAt ?? DateTime.now();
    map['updatedAt'] = Timestamp.fromDate(updatedAt);
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
