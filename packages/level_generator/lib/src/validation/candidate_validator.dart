import 'package:game_engine/game_engine.dart';
import 'package:game_solver/game_solver.dart';
import 'package:level_generator/src/deal/board_dealer.dart';
import 'package:level_generator/src/difficulty/difficulty_evaluator.dart';
import 'package:level_generator/src/difficulty/difficulty_models.dart';
import 'package:level_generator/src/model/level_configuration.dart';

enum CandidateRejectReason {
  engineInvariantFailure,
  unsolvable,
  solutionOverMoveLimit,
  solverInconclusive,
  tooEasy,
  tooHard,
}

sealed class CandidateValidation {
  const CandidateValidation();
}

final class CandidateAccepted extends CandidateValidation {
  const CandidateAccepted({
    required this.solved,
    required this.difficulty,
  });

  final Solved solved;
  final DifficultyEvaluation difficulty;
}

final class CandidateRejected extends CandidateValidation {
  const CandidateRejected({
    required this.reason,
    this.solveResult,
    this.difficulty,
    this.detail,
  });

  final CandidateRejectReason reason;
  final SolveResult? solveResult;
  final DifficultyEvaluation? difficulty;
  final String? detail;
}

/// Engine → Solver → difficulty gate for one candidate.
abstract final class CandidateValidator {
  static CandidateValidation validate({
    required GeneratedCandidate candidate,
    required LevelConfiguration config,
    GameSolver? solver,
    GameEngine engine = const GameEngine(),
  }) {
    final activeSolver = solver ?? GameSolver();
    final state = candidate.initialGameState;
    if (!engine.validate(state)) {
      return const CandidateRejected(
        reason: CandidateRejectReason.engineInvariantFailure,
        detail: 'GameEngine.validate failed',
      );
    }

    final result =
        activeSolver.solve(state: state, options: config.solverOptions);
    switch (result) {
      case Solved(:final actions):
        if (actions.length > config.moveLimit) {
          return CandidateRejected(
            reason: CandidateRejectReason.solutionOverMoveLimit,
            solveResult: result,
          );
        }
        final replay = GameReplay.run(initialState: state, actions: actions);
        if (!replay.succeeded ||
            replay.finalState.status != AttemptStatus.won) {
          return CandidateRejected(
            reason: CandidateRejectReason.unsolvable,
            solveResult: result,
            detail: 'solution failed engine replay',
          );
        }
        final difficulty = DifficultyEvaluator.evaluate(
          initialState: state,
          solved: result,
          target: config.difficultyTarget,
        );
        return switch (difficulty.verdict) {
          DifficultyVerdict.accepted => CandidateAccepted(
              solved: result,
              difficulty: difficulty,
            ),
          DifficultyVerdict.tooEasy => CandidateRejected(
              reason: CandidateRejectReason.tooEasy,
              solveResult: result,
              difficulty: difficulty,
            ),
          DifficultyVerdict.tooHard => CandidateRejected(
              reason: CandidateRejectReason.tooHard,
              solveResult: result,
              difficulty: difficulty,
            ),
        };
      case Unsolvable():
        return CandidateRejected(
          reason: CandidateRejectReason.unsolvable,
          solveResult: result,
        );
      case SolveInconclusive():
        return CandidateRejected(
          reason: CandidateRejectReason.solverInconclusive,
          solveResult: result,
        );
    }
  }
}
