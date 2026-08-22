/// Auth domain models for Sprint 6.
///
/// Pure Dart — no Firebase SDK, no Flutter.
library;

// ── Auth State ────────────────────────────────────────────────────────────────

enum AuthStateType {
  uninitialized,
  offlineLocalOnly,
  anonymousAuthenticated,
  linkedAuthenticated,
  linking,
  conflict,
  recoverableError,
}

final class AuthState {
  const AuthState({
    required this.type,
    this.firebaseUid,
    this.linkedProviders = const [],
    this.error,
  });

  final AuthStateType type;
  final String? firebaseUid;
  final List<String> linkedProviders;
  final String? error;

  bool get isAuthenticated =>
      type == AuthStateType.anonymousAuthenticated ||
      type == AuthStateType.linkedAuthenticated;

  bool get isOffline => type == AuthStateType.offlineLocalOnly;

  bool get hasConflict => type == AuthStateType.conflict;

  static const uninitialized = AuthState(type: AuthStateType.uninitialized);
  static const offline = AuthState(type: AuthStateType.offlineLocalOnly);

  @override
  String toString() =>
      'AuthState(${type.name}, uid=$firebaseUid, providers=$linkedProviders)';
}

// ── Link Result ───────────────────────────────────────────────────────────────

enum LinkResultType { success, alreadyLinked, conflict, failed }

final class LinkResult {
  const LinkResult({required this.type, this.error});

  final LinkResultType type;
  final String? error;

  bool get isSuccess => type == LinkResultType.success;
  bool get isConflict => type == LinkResultType.conflict;
  bool get isAlreadyLinked => type == LinkResultType.alreadyLinked;

  static const success = LinkResult(type: LinkResultType.success);
  static const alreadyLinked = LinkResult(type: LinkResultType.alreadyLinked);
}

// ── Player Identity ───────────────────────────────────────────────────────────

final class PlayerIdentity {
  const PlayerIdentity({
    required this.localPlayerId,
    this.firebaseUid,
    required this.identityState,
    required this.createdAt,
    this.cloudMigrationVersion = 0,
    this.cloudMigrationCompletedAt,
  });

  final String localPlayerId;
  final String? firebaseUid;
  final AuthStateType identityState;
  final DateTime createdAt;
  final int cloudMigrationVersion;
  final DateTime? cloudMigrationCompletedAt;

  bool get hasMigratedToCloud => cloudMigrationVersion > 0;
}
