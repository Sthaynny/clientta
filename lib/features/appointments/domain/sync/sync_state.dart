enum SyncPhase {
  idle,
  syncing,
  success,
  error,
}

class SyncState {
  const SyncState({
    this.phase = SyncPhase.idle,
    this.lastSyncedAt,
    this.hasPendingChanges = false,
    this.errorMessage,
  });

  final SyncPhase phase;
  final DateTime? lastSyncedAt;
  final bool hasPendingChanges;
  final String? errorMessage;

  bool get isSyncing => phase == SyncPhase.syncing;

  SyncState copyWith({
    SyncPhase? phase,
    DateTime? lastSyncedAt,
    bool? hasPendingChanges,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SyncState(
      phase: phase ?? this.phase,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      hasPendingChanges: hasPendingChanges ?? this.hasPendingChanges,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
