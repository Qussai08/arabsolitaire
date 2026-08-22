import 'package:level_generator/src/model/association_variant.dart';
import 'package:level_generator/src/model/level_configuration.dart';
import 'package:level_generator/src/random/generation_seed.dart';

/// Selects approved Association variants. No semantic / Arabic inference.
abstract interface class ContentSelector {
  List<AssociationVariant> select({
    required LevelConfiguration config,
    required GenerationSeed seed,
  });
}

/// Uses an explicitly supplied list (must already match [groupSizeProfile]).
final class FixedContentSelector implements ContentSelector {
  FixedContentSelector(this.variants);

  final List<AssociationVariant> variants;

  @override
  List<AssociationVariant> select({
    required LevelConfiguration config,
    required GenerationSeed seed,
  }) {
    return List.unmodifiable(variants);
  }
}

/// Seeded pick from an eligible pool (no history / cooldown without context).
final class SeededPoolContentSelector implements ContentSelector {
  SeededPoolContentSelector(this.eligiblePool);

  final List<AssociationVariant> eligiblePool;

  @override
  List<AssociationVariant> select({
    required LevelConfiguration config,
    required GenerationSeed seed,
  }) {
    final bySize = <int, List<AssociationVariant>>{};
    for (final v in eligiblePool) {
      bySize.putIfAbsent(v.memberCount, () => []).add(v);
    }

    final random = seed.createRandom();
    final selected = <AssociationVariant>[];
    final usedIds = <String>{};

    for (final size in config.groupSizeProfile) {
      final pool = List<AssociationVariant>.from(bySize[size] ?? const []);
      pool.removeWhere((v) => usedIds.contains(v.id));
      if (pool.isEmpty) {
        throw StateError('no eligible content for group size $size');
      }
      final shuffled = seededShuffle(pool, random);
      final pick = shuffled.first;
      selected.add(pick);
      usedIds.add(pick.id);
    }

    return List.unmodifiable(selected);
  }
}
