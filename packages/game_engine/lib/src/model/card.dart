import 'package:game_engine/src/model/identifiers.dart';

/// Authoritative card kinds. Display content stays outside the engine.
sealed class GameCard {
  const GameCard({
    required this.id,
    required this.associationId,
    this.contentRefId,
  });

  final CardId id;
  final AssociationId associationId;

  /// Optional stable content reference (never used for legality).
  final String? contentRefId;

  Map<String, Object?> toJson();

  static GameCard fromJson(Map<String, Object?> json) {
    final kind = json['kind'] as String?;
    return switch (kind) {
      'association' => AssociationCard.fromJson(json),
      'member' => MemberCard.fromJson(json),
      _ => throw FormatException('Unknown GameCard kind: $kind'),
    };
  }

  @override
  bool operator ==(Object other) {
    return other is GameCard &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.associationId == associationId &&
        other.contentRefId == contentRefId;
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, associationId, contentRefId);
}

final class AssociationCard extends GameCard {
  const AssociationCard({
    required super.id,
    required super.associationId,
    super.contentRefId,
  });

  factory AssociationCard.fromJson(Map<String, Object?> json) {
    return AssociationCard(
      id: json['id']! as String,
      associationId: json['associationId']! as String,
      contentRefId: json['contentRefId'] as String?,
    );
  }

  @override
  Map<String, Object?> toJson() => {
    'kind': 'association',
    'id': id,
    'associationId': associationId,
    if (contentRefId != null) 'contentRefId': contentRefId,
  };
}

final class MemberCard extends GameCard {
  const MemberCard({
    required super.id,
    required super.associationId,
    super.contentRefId,
  });

  factory MemberCard.fromJson(Map<String, Object?> json) {
    return MemberCard(
      id: json['id']! as String,
      associationId: json['associationId']! as String,
      contentRefId: json['contentRefId'] as String?,
    );
  }

  @override
  Map<String, Object?> toJson() => {
    'kind': 'member',
    'id': id,
    'associationId': associationId,
    if (contentRefId != null) 'contentRefId': contentRefId,
  };
}
