import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/storage/database_provider.dart';
import 'package:mobile/features/journey/data/drift_journey_repository.dart';
import 'package:mobile/features/journey/data/journey_repository.dart';
import 'package:mobile/features/journey/domain/journey_models.dart';

// ── Fake / no-op for when db is loading ───────────────────────────────────────

final class _NoOpJourneyRepository implements JourneyRepository {
  const _NoOpJourneyRepository();

  @override
  Future<JourneyProgress> loadProgress() async => const JourneyProgress();

  @override
  Future<void> saveProgress(JourneyProgress progress) async {}

  @override
  Future<PlayerLocalFlags> loadFlags() async => const PlayerLocalFlags();

  @override
  Future<void> saveFlags(PlayerLocalFlags flags) async {}
}

// ── Providers ─────────────────────────────────────────────────────────────────

final journeyRepositoryProvider = Provider<JourneyRepository>((ref) {
  final dbAsync = ref.watch(appDatabaseProvider);
  final db = dbAsync.valueOrNull;
  if (db == null) return const _NoOpJourneyRepository();
  return DriftJourneyRepository(db);
});
