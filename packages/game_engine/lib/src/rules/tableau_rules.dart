import 'package:game_engine/src/model/card.dart';
import 'package:game_engine/src/model/movable_unit.dart';
import 'package:game_engine/src/model/tableau_column.dart';
import 'package:game_engine/src/transition/rejection_reason.dart';
import 'package:game_engine/src/transition/streak_effect.dart';

/// Tableau destination legality for a moving unit.
({bool ok, RejectionReason? reason, StreakEffect? streak, MovableUnit? result})
validateTableauPlacement({
  required MovableUnit moving,
  required MovableUnit? target,
}) {
  if (target == null) {
    return (
      ok: true,
      reason: null,
      streak: StreakEffect.neutral,
      result: moving,
    );
  }

  // Member / MemberStack → Association in Tableau: invalid
  if ((moving is SingleMember || moving is MemberStack) &&
      (target is SingleAssociation || target is AssociationStack)) {
    if (target is AssociationStack) {
      return (
        ok: false,
        reason: RejectionReason.associationStackCannotReceiveInTableau,
        streak: null,
        result: null,
      );
    }
    return (
      ok: false,
      reason: RejectionReason.memberCannotMoveOntoAssociationInTableau,
      streak: null,
      result: null,
    );
  }

  // Association Stack → non-empty Tableau: invalid
  if (moving is AssociationStack) {
    return (
      ok: false,
      reason: RejectionReason.associationStackCannotMoveOntoNonEmptyTableau,
      streak: null,
      result: null,
    );
  }

  // Association Card → matching Member / MemberStack
  if (moving is SingleAssociation) {
    if (target is SingleMember || target is MemberStack) {
      if (moving.associationId != target.associationId) {
        return (
          ok: false,
          reason: RejectionReason.associationMismatch,
          streak: null,
          result: null,
        );
      }
      return (
        ok: true,
        reason: null,
        streak: StreakEffect.correct,
        result: mergeOnto(moving, target),
      );
    }
    return (
      ok: false,
      reason: RejectionReason.invalidDestination,
      streak: null,
      result: null,
    );
  }

  // Member / MemberStack → Member / MemberStack
  if ((moving is SingleMember || moving is MemberStack) &&
      (target is SingleMember || target is MemberStack)) {
    if (moving.associationId != target.associationId) {
      return (
        ok: false,
        reason: RejectionReason.associationMismatch,
        streak: null,
        result: null,
      );
    }
    final merged = mergeOnto(moving, target);
    return (
      ok: true,
      reason: null,
      streak: StreakEffect.correct,
      result: merged,
    );
  }

  return (
    ok: false,
    reason: RejectionReason.invalidDestination,
    streak: null,
    result: null,
  );
}

bool isAssociationActivator(MovableUnit unit) =>
    unit is SingleAssociation || unit is AssociationStack;

List<MemberCard>? membersOnly(MovableUnit unit) {
  return switch (unit) {
    SingleMember(:final card) => [card],
    MemberStack(:final members) => members,
    _ => null,
  };
}

/// Auto-reveal after removing exposed unit from [columnIndex].
({List<TableauColumn> tableau, GameCard? revealed}) revealAfterRemoval(
  List<TableauColumn> tableau,
  int columnIndex,
) {
  final col = tableau[columnIndex];
  if (col.hiddenCards.isEmpty) {
    final next = [...tableau];
    next[columnIndex] = const TableauColumn();
    return (tableau: next, revealed: null);
  }
  final hidden = List<GameCard>.from(col.hiddenCards);
  final revealed = hidden.removeLast();
  final next = [...tableau];
  next[columnIndex] = TableauColumn(
    hiddenCards: hidden,
    exposedUnit: MovableUnit.single(revealed),
  );
  return (tableau: next, revealed: revealed);
}
