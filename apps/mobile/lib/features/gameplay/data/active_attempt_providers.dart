import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/storage/database_provider.dart';
import 'package:mobile/features/gameplay/data/active_attempt_repository.dart';
import 'package:mobile/features/gameplay/data/drift_active_attempt_repository.dart';

/// Repository provider — available to both controller and tests.
final activeAttemptRepositoryProvider = Provider<ActiveAttemptRepository>(
  (ref) {
    final dbAsync = ref.watch(appDatabaseProvider);
    final db = dbAsync.valueOrNull;
    if (db == null) return const _NoOpActiveAttemptRepository();
    return DriftActiveAttemptRepository(db);
  },
);

final class _NoOpActiveAttemptRepository implements ActiveAttemptRepository {
  const _NoOpActiveAttemptRepository();
  @override
  Future<SavedAttempt?> load() async => null;
  @override
  Future<void> save(SavedAttempt attempt) async {}
  @override
  Future<void> clear() async {}
}
