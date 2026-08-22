/// Pure Dart level generator for Solitaire Al-Arab.
///
/// Pipeline: LevelConfiguration → approved content → card pool → seeded deal →
/// Solver validation (fixed Move Limit) → Board Difficulty acceptance.
library;

export 'src/api/generation_result.dart';
export 'src/api/level_generator.dart';
export 'src/config/level_templates.dart';
export 'src/content/card_pool_builder.dart';
export 'src/content/content_selector.dart';
export 'src/deal/board_dealer.dart';
export 'src/difficulty/difficulty_evaluator.dart';
export 'src/difficulty/difficulty_models.dart';
export 'src/model/association_variant.dart';
export 'src/model/level_configuration.dart';
export 'src/random/generation_seed.dart';
export 'src/validation/candidate_validator.dart';
export 'src/version/package_version.dart';
