import 'package:game_engine/game_engine.dart';

/// Persisted active-attempt record (one-at-a-time per device).
final class SavedAttempt {
  const SavedAttempt({
    required this.levelDefinitionId,
    required this.attemptId,
    required this.seed,
    required this.gameState,
    required this.rulesVersion,
    required this.saveSchemaVersion,
    required this.generatorVersion,
    required this.revision,
  });

  final String levelDefinitionId;
  final String attemptId;
  final int seed;
  final GameState gameState;
  final String rulesVersion;
  final int saveSchemaVersion;
  final String generatorVersion;
  final int revision;

  bool get isCompatible => rulesVersion == gameEngineRulesVersion;
}

abstract interface class ActiveAttemptRepository {
  Future<SavedAttempt?> load();
  Future<void> save(SavedAttempt attempt);
  Future<void> clear();
}
