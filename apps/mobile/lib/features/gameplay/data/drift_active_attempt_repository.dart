import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:game_engine/game_engine.dart';
import 'package:mobile/core/storage/app_database.dart' as db_lib;
import 'package:mobile/features/gameplay/data/active_attempt_repository.dart';

final class DriftActiveAttemptRepository implements ActiveAttemptRepository {
  DriftActiveAttemptRepository(this._db);

  final db_lib.AppDatabase _db;
  static const _activeId = 'active';

  @override
  Future<SavedAttempt?> load() async {
    final row = await (_db.select(
      _db.activeAttempts,
    )..where((t) => t.id.equals(_activeId))).getSingleOrNull();
    if (row == null) return null;
    try {
      final json = jsonDecode(row.gameStateJson) as Map<String, Object?>;
      final state = GameStateCodec.decode(json);
      return SavedAttempt(
        levelDefinitionId: row.levelDefinitionId,
        attemptId: row.attemptId,
        seed: row.seed,
        gameState: state,
        rulesVersion: row.rulesVersion,
        saveSchemaVersion: row.saveSchemaVersion,
        generatorVersion: row.generatorVersion,
        revision: row.revision,
      );
    } catch (_) {
      await clear();
      return null;
    }
  }

  @override
  Future<void> save(SavedAttempt attempt) async {
    final stateJson = jsonEncode(GameStateCodec.encode(attempt.gameState));
    await _db
        .into(_db.activeAttempts)
        .insertOnConflictUpdate(
          db_lib.ActiveAttemptsCompanion(
            id: const Value(_activeId),
            levelDefinitionId: Value(attempt.levelDefinitionId),
            attemptId: Value(attempt.attemptId),
            seed: Value(attempt.seed),
            gameStateJson: Value(stateJson),
            rulesVersion: Value(attempt.rulesVersion),
            saveSchemaVersion: Value(attempt.saveSchemaVersion),
            generatorVersion: Value(attempt.generatorVersion),
            revision: Value(attempt.revision),
            savedAt: Value(DateTime.now().toUtc()),
          ),
        );
  }

  @override
  Future<void> clear() async {
    await (_db.delete(
      _db.activeAttempts,
    )..where((t) => t.id.equals(_activeId))).go();
  }
}
