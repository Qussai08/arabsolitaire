import 'package:game_engine/src/model/movable_unit.dart';

final class AssociationSlot {
  const AssociationSlot({required this.index, this.activeAssociation});

  final int index;
  final AssociationStack? activeAssociation;

  bool get isEmpty => activeAssociation == null;

  AssociationSlot copyWith({
    AssociationStack? activeAssociation,
    bool clear = false,
  }) {
    return AssociationSlot(
      index: index,
      activeAssociation: clear
          ? null
          : (activeAssociation ?? this.activeAssociation),
    );
  }

  Map<String, Object?> toJson() => {
    'index': index,
    'activeAssociation': activeAssociation?.toJson(),
  };

  factory AssociationSlot.fromJson(Map<String, Object?> json) {
    final active = json['activeAssociation'];
    return AssociationSlot(
      index: json['index']! as int,
      activeAssociation: active == null
          ? null
          : AssociationStack.fromJson(Map<String, Object?>.from(active as Map)),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AssociationSlot &&
      other.index == index &&
      other.activeAssociation == activeAssociation;

  @override
  int get hashCode => Object.hash(index, activeAssociation);
}
