import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/economy/application/economy_providers.dart';
import 'package:mobile/features/economy/data/drift_wallet_repository.dart';
import 'package:mobile/features/economy/data/economy_repository.dart';
import 'package:mobile/features/economy/data/wallet_repository.dart';
import 'package:mobile/features/economy/domain/economy_models.dart';

// ── View State ────────────────────────────────────────────────────────────────

sealed class WalletViewState {
  const WalletViewState();
}

final class WalletLoading extends WalletViewState {
  const WalletLoading();
}

final class WalletReady extends WalletViewState {
  const WalletReady({
    required this.snapshot,
    this.isOperationInFlight = false,
    this.lastError,
  });
  final WalletSnapshot snapshot;
  final bool isOperationInFlight;
  final EconomyError? lastError;
}

// ── Controller ────────────────────────────────────────────────────────────────

class WalletController extends Notifier<WalletViewState> {
  @override
  WalletViewState build() {
    Future.microtask(_initialize);
    return const WalletLoading();
  }

  WalletRepository get _walletRepo => ref.read(walletRepositoryProvider);
  EconomyRepository get _economyRepo => ref.read(economyRepositoryProvider);
  DriftEconomyOperationRepository? get _opRepo =>
      ref.read(economyOperationRepositoryProvider);

  Future<void> _initialize() async {
    final snapshot = await _walletRepo.getSnapshot();
    state = WalletReady(snapshot: snapshot);
    // Attempt server reconciliation in background.
    unawaited(_reconcile());
  }

  // ── Read ──────────────────────────────────────────────────────────────────

  WalletSnapshot get snapshot {
    final s = state;
    return s is WalletReady ? s.snapshot : WalletSnapshot.empty;
  }

  // ── Economy operations ────────────────────────────────────────────────────

  Future<EconomyResult> initializeWallet() =>
      _executeOp(EconomyOperationType.initialGrant, () async {
        final result = await _economyRepo.initializeWallet();
        return result;
      });

  Future<EconomyResult> claimLevelReward({
    required String levelId,
    required String completionId,
    required int remainingMoves,
    required int streakCoins,
  }) => _executeOp(EconomyOperationType.levelReward, () async {
    return _economyRepo.claimLevelReward(
      levelId: levelId,
      completionId: completionId,
      remainingMoves: remainingMoves,
      streakCoins: streakCoins,
    );
  });

  Future<EconomyResult> claimChapterReward({required String chapterId}) =>
      _executeOp(EconomyOperationType.chapterReward, () async {
        return _economyRepo.claimChapterReward(chapterId: chapterId);
      });

  Future<EconomyResult> purchaseHint({required String operationId}) =>
      _executeOp(
        EconomyOperationType.hintPurchase,
        () async {
          return _economyRepo.purchaseHint(operationId: operationId);
        },
        localCoinDelta: -EconomyConfig.hintCostCoins,
        localHintDelta: 1,
      );

  Future<EconomyResult> consumeHint({required String operationId}) =>
      _executeOp(EconomyOperationType.hintConsume, () async {
        return _economyRepo.consumeHint(operationId: operationId);
      }, localHintDelta: -1);

  Future<EconomyResult> purchaseExtraMoves({
    required String attemptId,
    required int rescueIndex,
  }) {
    final cost = rescueIndex == 1
        ? EconomyConfig.extraMovesCostFirst
        : EconomyConfig.extraMovesCostSecond;
    return _executeOp(EconomyOperationType.extraMovesPurchase, () async {
      return _economyRepo.purchaseExtraMoves(
        attemptId: attemptId,
        rescueIndex: rescueIndex,
      );
    }, localCoinDelta: -cost);
  }

  Future<EconomyResult> purchaseDeadEndRescue({required String attemptId}) =>
      _executeOp(
        EconomyOperationType.deadEndRescuePurchase,
        () async {
          return _economyRepo.purchaseDeadEndRescue(attemptId: attemptId);
        },
        localCoinDelta: -EconomyConfig.deadEndRescueCostCoins,
      );

  // ── Reconciliation ────────────────────────────────────────────────────────

  Future<void> _reconcile() async {
    final serverSnapshot = await _economyRepo.fetchServerSnapshot();
    if (serverSnapshot == null) return;

    // Flush pending operations
    final opRepo = _opRepo;
    if (opRepo != null) {
      final pending = await opRepo.loadPending();
      for (final op in pending) {
        await _flushOperation(op);
      }
      await opRepo.purgeCompleted();
    }

    // Update local cache to server state (after flush)
    final freshSnapshot = await _economyRepo.fetchServerSnapshot();
    if (freshSnapshot != null) {
      await _walletRepo.saveSnapshot(freshSnapshot);
      final current = state;
      if (current is WalletReady) {
        state = WalletReady(snapshot: freshSnapshot);
      }
    }
  }

  Future<void> _flushOperation(EconomyOperation op) async {
    final opRepo = _opRepo;
    if (opRepo == null) return;
    try {
      EconomyResult result;
      switch (op.type) {
        case EconomyOperationType.levelReward:
          final p = op.payload;
          result = await _economyRepo.claimLevelReward(
            levelId: p['levelId'] as String,
            completionId: p['completionId'] as String,
            remainingMoves: p['remainingMoves'] as int,
            streakCoins: p['streakCoins'] as int,
          );
        case EconomyOperationType.chapterReward:
          result = await _economyRepo.claimChapterReward(
            chapterId: op.payload['chapterId'] as String,
          );
        case EconomyOperationType.hintPurchase:
          result = await _economyRepo.purchaseHint(operationId: op.operationId);
        case EconomyOperationType.hintConsume:
          result = await _economyRepo.consumeHint(operationId: op.operationId);
        case EconomyOperationType.extraMovesPurchase:
          result = await _economyRepo.purchaseExtraMoves(
            attemptId: op.payload['attemptId'] as String,
            rescueIndex: op.payload['rescueIndex'] as int,
          );
        case EconomyOperationType.deadEndRescuePurchase:
          result = await _economyRepo.purchaseDeadEndRescue(
            attemptId: op.payload['attemptId'] as String,
          );
        default:
          return;
      }
      if (result is EconomySuccess) {
        await opRepo.markCompleted(
          op.operationId,
          serverTransactionId: result.transactionId ?? op.operationId,
        );
      } else {
        await opRepo.markFailed(op.operationId, retryable: true);
      }
    } catch (_) {
      await opRepo.markFailed(op.operationId, retryable: true);
    }
  }

  // ── Internal operation executor ───────────────────────────────────────────

  Future<EconomyResult> _executeOp(
    EconomyOperationType type,
    Future<EconomyResult> Function() fn, {
    int localCoinDelta = 0,
    int localHintDelta = 0,
  }) async {
    final current = state;
    if (current is WalletReady && current.isOperationInFlight) {
      return const EconomyFailure(
        error: EconomyError(
          code: EconomyErrorCode.invalidOperation,
          message: 'Operation in flight',
        ),
      );
    }

    // Optimistic local delta
    if (localCoinDelta != 0 || localHintDelta != 0) {
      await _walletRepo.applyPendingDelta(
        coinDelta: localCoinDelta,
        hintDelta: localHintDelta,
      );
    }

    if (current is WalletReady) {
      state = WalletReady(
        snapshot: current.snapshot,
        isOperationInFlight: true,
      );
    }

    try {
      final result = await fn();
      if (result is EconomySuccess) {
        // Apply server-confirmed state
        await _walletRepo.saveSnapshot(result.walletSnapshot);
        await _walletRepo.clearPendingDeltas();
        state = WalletReady(snapshot: result.walletSnapshot);
      } else if (result is EconomyFailure) {
        // Rollback optimistic delta
        if (localCoinDelta != 0 || localHintDelta != 0) {
          await _walletRepo.applyPendingDelta(
            coinDelta: -localCoinDelta,
            hintDelta: -localHintDelta,
          );
        }
        final refreshed = await _walletRepo.getSnapshot();
        state = WalletReady(snapshot: refreshed, lastError: result.error);
      }
      return result;
    } catch (_) {
      // On unexpected error, rollback optimistic delta
      if (localCoinDelta != 0 || localHintDelta != 0) {
        await _walletRepo.applyPendingDelta(
          coinDelta: -localCoinDelta,
          hintDelta: -localHintDelta,
        );
      }
      final refreshed = await _walletRepo.getSnapshot();
      state = WalletReady(
        snapshot: refreshed,
        lastError: const EconomyError(code: EconomyErrorCode.internalError),
      );
      return const EconomyFailure(
        error: EconomyError(code: EconomyErrorCode.internalError),
      );
    }
  }
}

final walletControllerProvider =
    NotifierProvider<WalletController, WalletViewState>(WalletController.new);
