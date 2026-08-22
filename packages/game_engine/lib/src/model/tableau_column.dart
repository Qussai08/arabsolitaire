import 'package:game_engine/src/model/card.dart';
import 'package:game_engine/src/model/movable_unit.dart';

/// One Tableau column: hidden cards (bottom→top) + optional exposed unit.
final class TableauColumn {
  const TableauColumn({this.hiddenCards = const [], this.exposedUnit});

  final List<GameCard> hiddenCards;
  final MovableUnit? exposedUnit;

  bool get isEmpty => hiddenCards.isEmpty && exposedUnit == null;
  bool get hasExposed => exposedUnit != null;

  TableauColumn copyWith({
    List<GameCard>? hiddenCards,
    MovableUnit? exposedUnit,
    bool clearExposed = false,
  }) {
    return TableauColumn(
      hiddenCards: hiddenCards ?? this.hiddenCards,
      exposedUnit: clearExposed ? null : (exposedUnit ?? this.exposedUnit),
    );
  }

  Map<String, Object?> toJson() => {
    'hiddenCards': hiddenCards.map((c) => c.toJson()).toList(),
    'exposedUnit': exposedUnit?.toJson(),
  };

  factory TableauColumn.fromJson(Map<String, Object?> json) {
    final hidden = json['hiddenCards'] as List<dynamic>? ?? const [];
    final exposed = json['exposedUnit'];
    return TableauColumn(
      hiddenCards: [
        for (final item in hidden)
          GameCard.fromJson(Map<String, Object?>.from(item as Map)),
      ],
      exposedUnit: exposed == null
          ? null
          : MovableUnit.fromJson(Map<String, Object?>.from(exposed as Map)),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! TableauColumn) return false;
    if (other.exposedUnit != exposedUnit) return false;
    if (other.hiddenCards.length != hiddenCards.length) return false;
    for (var i = 0; i < hiddenCards.length; i++) {
      if (other.hiddenCards[i] != hiddenCards[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(Object.hashAll(hiddenCards), exposedUnit);
}
