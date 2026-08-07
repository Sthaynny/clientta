import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:clientta/core/plan/plan_access_policy.dart';
import 'package:clientta/core/storage/device_json_store.dart';
import 'package:clientta/features/appointments/data/appointment_repository_local.dart';
import 'package:clientta/features/appointments/domain/repositories/appointment_repository_remote.dart';
import 'package:clientta/features/appointments/domain/sync/appointment_sync_merge.dart';
import 'package:clientta/features/appointments/domain/sync/sync_state.dart';
import 'package:clientta/features/auth/domain/repositories/user_repository.dart';
import 'package:clientta/features/billing/domain/entities/user_subscription.dart';

class AppointmentSyncService extends ChangeNotifier {
  AppointmentSyncService({
    required DeviceJsonStore store,
    required AppointmentRepositoryLocal localRepository,
    required AppointmentRepositoryRemote remoteRepository,
    UserRepository? userRepository,
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  }) : _store = store,
       _localRepository = localRepository,
       _remoteRepository = remoteRepository,
       _userRepository = userRepository,
       _auth = auth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  static const _syncKey = 'sync';
  static const _pendingDeletesKey = 'pendingDeleteIds';
  static const _lastSyncedAtKey = 'lastSyncedAt';

  final DeviceJsonStore _store;
  final AppointmentRepositoryLocal _localRepository;
  final AppointmentRepositoryRemote _remoteRepository;
  final UserRepository? _userRepository;
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  SyncState _state = const SyncState();
  Timer? _debounceTimer;

  SyncState get state => _state;

  void scheduleSync() {
    _setState(_state.copyWith(hasPendingChanges: true));
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 2), () {
      unawaited(sync());
    });
  }

  void queueDelete(String appointmentId) {
    unawaited(_addPendingDelete(appointmentId));
    scheduleSync();
  }

  Future<bool> canSync() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    return _hasActiveProSubscription(user.uid);
  }

  Future<void> sync() async {
    if (_state.isSyncing) return;

    final user = _auth.currentUser;
    if (user == null) return;

    if (!await _hasActiveProSubscription(user.uid)) {
      _setState(
        _state.copyWith(
          phase: SyncPhase.idle,
          hasPendingChanges: false,
          clearError: true,
        ),
      );
      return;
    }

    _setState(
      _state.copyWith(phase: SyncPhase.syncing, clearError: true),
    );

    try {
      final pendingDeletes = await _readPendingDeletes();
      final local = await _localRepository.getAll();
      final remote = await _remoteRepository.fetchAll(user.uid);

      final merge = AppointmentSyncMerge.merge(
        local: local,
        remote: remote,
        pendingDeleteIds: pendingDeletes,
      );

      if (merge.toSaveLocal.isNotEmpty || merge.toDeleteLocal.isNotEmpty) {
        await _localRepository.saveAll(
          merge.toSaveLocal,
          deleteIds: merge.toDeleteLocal,
        );
      }

      for (final entry in merge.toUpsertRemote) {
        await _remoteRepository.upsert(user.uid, entry);
      }

      for (final id in merge.toDeleteRemote) {
        await _remoteRepository.delete(user.uid, id);
      }

      if (merge.toDeleteRemote.isNotEmpty) {
        await _clearPendingDeletes(merge.toDeleteRemote);
      }

      final now = DateTime.now();
      await _writeLastSyncedAt(now);
      await _userRepository?.touchLastActivity(uid: user.uid);

      _setState(
        SyncState(
          phase: SyncPhase.success,
          lastSyncedAt: now,
          hasPendingChanges: false,
        ),
      );
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Appointment sync failed: $error');
      }
      _setState(
        _state.copyWith(
          phase: SyncPhase.error,
          hasPendingChanges: true,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<bool> _hasActiveProSubscription(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    final subscription = UserSubscription.fromMap(
      doc.data()?['subscription'] as Map<String, dynamic>?,
    );
    return PlanAccessPolicy.canAccessCloudSync(subscription);
  }

  Future<Set<String>> _readPendingDeletes() async {
    final root = await _store.readRoot();
    final sync = root[_syncKey] as Map<String, dynamic>? ?? {};
    final raw = sync[_pendingDeletesKey] as List<dynamic>? ?? [];
    return raw.map((e) => e as String).toSet();
  }

  Future<void> _addPendingDelete(String appointmentId) async {
    final root = await _store.readRoot();
    final sync = Map<String, dynamic>.from(
      root[_syncKey] as Map<String, dynamic>? ?? {},
    );
    final pending = <String>{
      ...((sync[_pendingDeletesKey] as List<dynamic>? ?? [])
          .map((e) => e as String)),
      appointmentId,
    };
    sync[_pendingDeletesKey] = pending.toList();
    root[_syncKey] = sync;
    await _store.writeRoot(root);
  }

  Future<void> _clearPendingDeletes(List<String> deletedIds) async {
    final root = await _store.readRoot();
    final sync = Map<String, dynamic>.from(
      root[_syncKey] as Map<String, dynamic>? ?? {},
    );
    final pending = <String>{
      ...((sync[_pendingDeletesKey] as List<dynamic>? ?? [])
          .map((e) => e as String)),
    }..removeAll(deletedIds);
    sync[_pendingDeletesKey] = pending.toList();
    root[_syncKey] = sync;
    await _store.writeRoot(root);
  }

  Future<void> _writeLastSyncedAt(DateTime value) async {
    final root = await _store.readRoot();
    final sync = Map<String, dynamic>.from(
      root[_syncKey] as Map<String, dynamic>? ?? {},
    );
    sync[_lastSyncedAtKey] = value.toIso8601String();
    root[_syncKey] = sync;
    await _store.writeRoot(root);
  }

  Future<void> loadPersistedState() async {
    final root = await _store.readRoot();
    final sync = root[_syncKey] as Map<String, dynamic>? ?? {};
    final lastSyncedRaw = sync[_lastSyncedAtKey] as String?;
    final pending = (sync[_pendingDeletesKey] as List<dynamic>? ?? []).isNotEmpty;

    _setState(
      SyncState(
        lastSyncedAt:
            lastSyncedRaw != null ? DateTime.tryParse(lastSyncedRaw) : null,
        hasPendingChanges: pending,
      ),
    );
  }

  void _setState(SyncState next) {
    _state = next;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
