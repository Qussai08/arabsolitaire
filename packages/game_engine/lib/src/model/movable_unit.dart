import 'package:game_engine/src/model/card.dart';
import 'package:game_engine/src/model/identifiers.dart';

/// Atomic movable unit. No public API exposes partial stack splits.
sealed class MovableUnit {
  const MovableUnit();

  AssociationId get associationId;
  List<GameCard> get cards;
  int get size => cards.length;

  Map<String, Object?> toJson();

  static MovableUnit fromJson(Map<String, Object?> json) {
    final kind = json['kind'] as String?;
    return switch (kind) {
      'singleMember' => SingleMember.fromJson(json),
      'singleAssociation' => SingleAssociation.fromJson(json),
      'memberStack' => MemberStack.fromJson(json),
      'associationStack' => AssociationStack.fromJson(json),
      _ => throw FormatException('Unknown MovableUnit kind: $kind'),
    };
  }

  static MovableUnit single(GameCard card) {
    return switch (card) {
      MemberCard() => SingleMember(card),
      AssociationCard() => SingleAssociation(card),
    };
  }
}

final class SingleMember extends MovableUnit {
  const SingleMember(this.card);

  final MemberCard card;

  @override
  AssociationId get associationId => card.associationId;

  @override
  List<GameCard> get cards => [card];

  factory SingleMember.fromJson(Map<String, Object?> json) {
    return SingleMember(
      MemberCard.fromJson(Map<String, Object?>.from(json['card']! as Map)),
    );
  }

  @override
  Map<String, Object?> toJson() => {
    'kind': 'singleMember',
    'card': card.toJson(),
  };

  @override
  bool operator ==(Object other) => other is SingleMember && other.card == card;

  @override
  int get hashCode => Object.hash(runtimeType, card);
}

final class SingleAssociation extends MovableUnit {
  const SingleAssociation(this.card);

  final AssociationCard card;

  @override
  AssociationId get associationId => card.associationId;

  @override
  List<GameCard> get cards => [card];

  factory SingleAssociation.fromJson(Map<String, Object?> json) {
    return SingleAssociation(
      AssociationCard.fromJson(Map<String, Object?>.from(json['card']! as Map)),
    );
  }

  @override
  Map<String, Object?> toJson() => {
    'kind': 'singleAssociation',
    'card': card.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      other is SingleAssociation && other.card == card;

  @override
  int get hashCode => Object.hash(runtimeType, card);
}

/// 2+ Members, same associationId. Ordered bottom → top.
final class MemberStack extends MovableUnit {
  MemberStack(List<MemberCard> members)
    : members = List<MemberCard>.unmodifiable(members) {
    if (this.members.length < 2) {
      throw ArgumentError('MemberStack requires 2+ members');
    }
    final id = this.members.first.associationId;
    for (final m in this.members) {
      if (m.associationId != id) {
        throw ArgumentError('MemberStack mixed associationId');
      }
    }
  }

  final List<MemberCard> members;

  @override
  AssociationId get associationId => members.first.associationId;

  @override
  List<GameCard> get cards => members;

  factory MemberStack.fromJson(Map<String, Object?> json) {
    final raw = json['members'] as List<dynamic>;
    return MemberStack([
      for (final item in raw)
        MemberCard.fromJson(Map<String, Object?>.from(item as Map)),
    ]);
  }

  @override
  Map<String, Object?> toJson() => {
    'kind': 'memberStack',
    'members': members.map((m) => m.toJson()).toList(),
  };

  @override
  bool operator ==(Object other) {
    if (other is! MemberStack || other.members.length != members.length) {
      return false;
    }
    for (var i = 0; i < members.length; i++) {
      if (other.members[i] != members[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(members);
}

/// Exactly one Association Card + zero or more matching Members (bottom → top).
final class AssociationStack extends MovableUnit {
  AssociationStack({
    required this.associationCard,
    List<MemberCard> members = const [],
  }) : members = List<MemberCard>.unmodifiable(members) {
    for (final m in this.members) {
      if (m.associationId != associationCard.associationId) {
        throw ArgumentError('AssociationStack member mismatch');
      }
    }
  }

  final AssociationCard associationCard;
  final List<MemberCard> members;

  @override
  AssociationId get associationId => associationCard.associationId;

  @override
  List<GameCard> get cards => [associationCard, ...members];

  Set<CardId> get memberIds => members.map((m) => m.id).toSet();

  AssociationStack withAttachedMembers(List<MemberCard> extra) {
    return AssociationStack(
      associationCard: associationCard,
      members: [...members, ...extra],
    );
  }

  factory AssociationStack.fromJson(Map<String, Object?> json) {
    final rawMembers = json['members'] as List<dynamic>? ?? const [];
    return AssociationStack(
      associationCard: AssociationCard.fromJson(
        Map<String, Object?>.from(json['associationCard']! as Map),
      ),
      members: [
        for (final item in rawMembers)
          MemberCard.fromJson(Map<String, Object?>.from(item as Map)),
      ],
    );
  }

  @override
  Map<String, Object?> toJson() => {
    'kind': 'associationStack',
    'associationCard': associationCard.toJson(),
    'members': members.map((m) => m.toJson()).toList(),
  };

  @override
  bool operator ==(Object other) {
    if (other is! AssociationStack ||
        other.associationCard != associationCard ||
        other.members.length != members.length) {
      return false;
    }
    for (var i = 0; i < members.length; i++) {
      if (other.members[i] != members[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(associationCard, Object.hashAll(members));
}

/// Merge helpers used by tableau/slot rules (always produce atomic units).
MovableUnit mergeOnto(MovableUnit moving, MovableUnit target) {
  // Association onto Member / MemberStack
  if (moving is SingleAssociation) {
    if (target is SingleMember &&
        target.associationId == moving.associationId) {
      return AssociationStack(
        associationCard: moving.card,
        members: [target.card],
      );
    }
    if (target is MemberStack && target.associationId == moving.associationId) {
      return AssociationStack(
        associationCard: moving.card,
        members: target.members,
      );
    }
  }

  // Member / MemberStack merging
  final movingMembers = _asMembers(moving);
  final targetMembers = _asMembers(target);
  if (movingMembers != null &&
      targetMembers != null &&
      moving.associationId == target.associationId) {
    final merged = [...targetMembers, ...movingMembers];
    if (merged.length == 1) return SingleMember(merged.first);
    return MemberStack(merged);
  }

  throw StateError('Illegal mergeOnto combination');
}

List<MemberCard>? _asMembers(MovableUnit unit) {
  return switch (unit) {
    SingleMember(:final card) => [card],
    MemberStack(:final members) => members,
    _ => null,
  };
}
