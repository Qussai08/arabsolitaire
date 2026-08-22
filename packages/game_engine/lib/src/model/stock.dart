import 'package:game_engine/src/model/card.dart';

/// Stock as undealt draw pile + waste (cycle).
///
/// Advance: draw 1 from [undealt] onto [waste] (append).
/// Visible window: last up to 3 of [waste]; playable = last of [waste].
/// Restore: available when [undealt] is empty and [waste] is not;
/// moves [waste] back to [undealt] preserving order and clears waste.
final class StockState {
  const StockState({this.undealt = const [], this.waste = const []});

  /// Next card to advance is at index 0.
  final List<GameCard> undealt;

  /// Advanced cards this cycle; last is playable.
  final List<GameCard> waste;

  bool get canAdvance => undealt.isNotEmpty;

  bool get canRestore => undealt.isEmpty && waste.isNotEmpty;

  List<GameCard> get visibleCards {
    if (waste.isEmpty) return const [];
    final start = waste.length > 3 ? waste.length - 3 : 0;
    return List<GameCard>.unmodifiable(waste.sublist(start));
  }

  GameCard? get playableCard => waste.isEmpty ? null : waste.last;

  bool get isEmpty => undealt.isEmpty && waste.isEmpty;

  List<GameCard> get allRemainingCards => [...undealt, ...waste];

  StockState advance() {
    if (!canAdvance) {
      throw StateError('Cannot advance empty undealt stock');
    }
    final next = undealt.first;
    return StockState(undealt: undealt.sublist(1), waste: [...waste, next]);
  }

  StockState restore() {
    if (!canRestore) {
      throw StateError('Cannot restore stock');
    }
    return StockState(undealt: List<GameCard>.from(waste), waste: const []);
  }

  StockState removePlayable() {
    if (waste.isEmpty) {
      throw StateError('No playable stock card');
    }
    return StockState(
      undealt: undealt,
      waste: waste.sublist(0, waste.length - 1),
    );
  }

  Map<String, Object?> toJson() => {
    'undealt': undealt.map((c) => c.toJson()).toList(),
    'waste': waste.map((c) => c.toJson()).toList(),
  };

  factory StockState.fromJson(Map<String, Object?> json) {
    final undealt = json['undealt'] as List<dynamic>? ?? const [];
    final waste = json['waste'] as List<dynamic>? ?? const [];
    return StockState(
      undealt: [
        for (final item in undealt)
          GameCard.fromJson(Map<String, Object?>.from(item as Map)),
      ],
      waste: [
        for (final item in waste)
          GameCard.fromJson(Map<String, Object?>.from(item as Map)),
      ],
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! StockState) return false;
    if (other.undealt.length != undealt.length ||
        other.waste.length != waste.length) {
      return false;
    }
    for (var i = 0; i < undealt.length; i++) {
      if (other.undealt[i] != undealt[i]) return false;
    }
    for (var i = 0; i < waste.length; i++) {
      if (other.waste[i] != waste[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(undealt), Object.hashAll(waste));
}
