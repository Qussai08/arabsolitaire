import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:level_generator/level_generator.dart';
import 'package:mobile/features/content/application/content_providers.dart';
import 'package:mobile/features/content/domain/content_bundle.dart';
import 'package:mobile/features/gameplay/application/gameplay_controller.dart';
import 'package:mobile/features/gameplay/application/gameplay_state.dart';
import 'package:mobile/features/gameplay/data/level_content_factory.dart';
import 'package:mobile/features/journey/data/journey_content.dart';
import 'package:mobile/features/journey/domain/journey_models.dart';
export 'package:mobile/features/gameplay/data/active_attempt_providers.dart';

/// The level definition the player is currently about to play or is playing.
/// Set by JourneyScreen / HomeScreen before pushing [AppRoutes.gameplay].
final currentPlayingLevelProvider = StateProvider<LevelDefinition?>(
  (_) => null,
);

LevelDefinition _defaultLevel() => JourneyContent.buildLevels().first;

/// Resolves associations from the loaded content snapshot (or fallback).
final approvedAssociationPoolProvider = Provider<List<AssociationVariantDto>>((
  ref,
) {
  final async = ref.watch(contentSnapshotProvider);
  return async.maybeWhen(
    data: (snapshot) => snapshot.associations,
    orElse: bundledFallbackAssociations,
  );
});

final gameplayControllerProvider =
    NotifierProvider<GameplayController, GameplayViewState>(
      GameplayController.new,
    );

/// Extension helpers used by [GameplayController.build].
extension GameplayLevelResolution on Ref {
  LevelDefinition resolvePlayingLevel() {
    return watch(currentPlayingLevelProvider) ?? _defaultLevel();
  }

  LevelConfiguration resolveLevelConfig(LevelDefinition level) {
    return levelConfigurationFor(level);
  }

  ContentSelector resolveContentSelector(LevelDefinition level) {
    final pool = watch(approvedAssociationPoolProvider);
    return ApprovedPoolContentSelector(
      pool: pool,
      chapterId: level.chapterId,
      semanticTier: level.semanticDifficultyTier,
    );
  }
}
