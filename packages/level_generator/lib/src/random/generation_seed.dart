import 'dart:math';

/// Explicit generation seed (never ambient system randomness on the happy path).
final class GenerationSeed {
  const GenerationSeed(this.value);

  final int value;

  /// Deterministic candidate seed from base + attempt index.
  GenerationSeed deriveCandidate(int attemptIndex) {
    // Mix bits so consecutive attempts diverge strongly.
    final mixed = value ^ (attemptIndex * 0x9E3779B9);
    final rotated = (mixed << 7) | ((mixed >> 25) & 0x7F);
    return GenerationSeed((rotated + attemptIndex * 0x85EBCA6B) & 0x7FFFFFFF);
  }

  Random createRandom() => Random(value);

  @override
  String toString() => 'GenerationSeed($value)';

  @override
  bool operator ==(Object other) =>
      other is GenerationSeed && other.value == value;

  @override
  int get hashCode => value;
}

/// Fisher–Yates shuffle using an explicit [Random].
List<T> seededShuffle<T>(List<T> items, Random random) {
  final list = List<T>.from(items);
  for (var i = list.length - 1; i > 0; i--) {
    final j = random.nextInt(i + 1);
    final tmp = list[i];
    list[i] = list[j];
    list[j] = tmp;
  }
  return list;
}
