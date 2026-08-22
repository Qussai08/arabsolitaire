import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:level_generator/level_generator.dart';
import 'package:mobile/features/gameplay/application/gameplay_controller.dart';
import 'package:mobile/features/gameplay/application/gameplay_state.dart';
export 'package:mobile/features/gameplay/data/active_attempt_providers.dart';

/// Technical level fixture — DEV/TEST CONTENT only.
final _devConfig = LevelTemplates.early3x3(moveLimit: 60);
final _devContent = FixedContentSelector(
  SyntheticContent.forProfile(_devConfig.groupSizeProfile),
);

final gameplayControllerProvider =
    NotifierProvider<GameplayController, GameplayViewState>(
  () => GameplayController(
    config: _devConfig,
    contentSelector: _devContent,
  ),
);
