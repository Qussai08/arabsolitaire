import 'package:game_engine/src/model/identifiers.dart';

/// Exact membership required for Association completion.
final class AssociationDefinition {
  const AssociationDefinition({
    required this.associationId,
    required this.associationCardId,
    required this.requiredMemberCardIds,
  });

  final AssociationId associationId;
  final CardId associationCardId;
  final Set<CardId> requiredMemberCardIds;

  int get requiredMemberCount => requiredMemberCardIds.length;

  Map<String, Object?> toJson() => {
    'associationId': associationId,
    'associationCardId': associationCardId,
    'requiredMemberCardIds': requiredMemberCardIds.toList()..sort(),
  };

  factory AssociationDefinition.fromJson(Map<String, Object?> json) {
    final raw = json['requiredMemberCardIds'] as List<dynamic>? ?? const [];
    return AssociationDefinition(
      associationId: json['associationId']! as String,
      associationCardId: json['associationCardId']! as String,
      requiredMemberCardIds: raw.map((e) => e as String).toSet(),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AssociationDefinition &&
        other.associationId == associationId &&
        other.associationCardId == associationCardId &&
        _setEquals(other.requiredMemberCardIds, requiredMemberCardIds);
  }

  @override
  int get hashCode => Object.hash(
    associationId,
    associationCardId,
    Object.hashAll(requiredMemberCardIds.toList()..sort()),
  );
}

bool _setEquals(Set<Object?> a, Set<Object?> b) {
  if (a.length != b.length) return false;
  for (final value in a) {
    if (!b.contains(value)) return false;
  }
  return true;
}
