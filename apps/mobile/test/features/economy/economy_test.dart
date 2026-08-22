// Sprint 7 — Economy domain unit tests.
//
// Coverage:
//  1. EconomyConfig approved values.
//  2. WalletSnapshot effective balance math.
//  3. AttemptEconomyMetadata limits.
//  4. LevelRewardPreview formula.
//  5. DriftWalletRepository CRUD.
//  6. DriftEconomyOperationRepository enqueue/flush/purge.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/storage/database_provider.dart';
import 'package:mobile/features/economy/data/drift_wallet_repository.dart';
import 'package:mobile/features/economy/domain/economy_models.dart';

void main() {
  group('EconomyConfig — approved values', () {
    test('starting coins', () => expect(EconomyConfig.startingCoins, 300));
    test('starting hints', () => expect(EconomyConfig.startingHints, 3));
    test('hint cost', () => expect(EconomyConfig.hintCostCoins, 75));
    test('extra moves first cost', () => expect(EconomyConfig.extraMovesCostFirst, 150));
    test('extra moves second cost', () => expect(EconomyConfig.extraMovesCostSecond, 250));
    test('extra moves grant', () => expect(EconomyConfig.extraMovesGrant, 5));
    test('extra moves max per attempt', () => expect(EconomyConfig.extraMovesMaxPerAttempt, 2));
    test('dead end rescue cost', () => expect(EconomyConfig.deadEndRescueCostCoins, 200));
    test('dead end rescue max per attempt', () => expect(EconomyConfig.deadEndRescueMaxPerAttempt, 1));
    test('chapter reward coins', () => expect(EconomyConfig.chapterRewardCoins, 500));
    test('chapter reward hints', () => expect(EconomyConfig.chapterRewardHints, 2));
    test('level reward base', () => expect(EconomyConfig.levelRewardBase, 50));
    test('level reward per move', () => expect(EconomyConfig.levelRewardPerRemainingMove, 2));
  });

  group('WalletSnapshot effective balances', () {
    test('no pending — effective equals server', () {
      const snap = WalletSnapshot(coinBalance: 300, hintBalance: 3);
      expect(snap.effectiveCoinBalance, 300);
      expect(snap.effectiveHintBalance, 3);
    });

    test('pending spend reduces effective', () {
      const snap = WalletSnapshot(
        coinBalance: 200,
        hintBalance: 2,
        pendingCoinDelta: -75,
        pendingHintDelta: 1,
      );
      expect(snap.effectiveCoinBalance, 125);
      expect(snap.effectiveHintBalance, 3);
    });

    test('effective never goes below zero', () {
      const snap = WalletSnapshot(coinBalance: 50, pendingCoinDelta: -200);
      expect(snap.effectiveCoinBalance, 0);
    });

    test('hasPendingOperations when deltas present', () {
      const snap = WalletSnapshot(pendingCoinDelta: -75);
      expect(snap.hasPendingOperations, isTrue);
    });
  });

  group('AttemptEconomyMetadata', () {
    test('can buy first extra moves', () {
      const meta = AttemptEconomyMetadata();
      expect(meta.canBuyExtraMoves, isTrue);
      expect(meta.nextExtraMovesCost, EconomyConfig.extraMovesCostFirst);
    });

    test('can buy second extra moves', () {
      const meta = AttemptEconomyMetadata(extraMovesPurchasesUsed: 1);
      expect(meta.canBuyExtraMoves, isTrue);
      expect(meta.nextExtraMovesCost, EconomyConfig.extraMovesCostSecond);
    });

    test('cannot buy third extra moves', () {
      const meta = AttemptEconomyMetadata(extraMovesPurchasesUsed: 2);
      expect(meta.canBuyExtraMoves, isFalse);
      expect(meta.nextExtraMovesCost, -1);
    });

    test('can buy dead end rescue initially', () {
      const meta = AttemptEconomyMetadata();
      expect(meta.canBuyDeadEndRescue, isTrue);
    });

    test('cannot buy second dead end rescue', () {
      const meta = AttemptEconomyMetadata(deadEndRescueUsed: true);
      expect(meta.canBuyDeadEndRescue, isFalse);
    });
  });

  group('LevelRewardPreview formula', () {
    test('base only', () {
      const preview = LevelRewardPreview(
        levelId: 'l1',
        remainingMoves: 0,
        streakCoins: 0,
      );
      expect(preview.previewCoins, EconomyConfig.levelRewardBase);
    });

    test('with remaining moves', () {
      const preview = LevelRewardPreview(
        levelId: 'l1',
        remainingMoves: 4,
        streakCoins: 0,
      );
      // 50 + 2*4 = 58
      expect(preview.previewCoins, 58);
    });

    test('EC-002 scenario: 4 moves + 7 streak = 65', () {
      const preview = LevelRewardPreview(
        levelId: 'l1',
        remainingMoves: 4,
        streakCoins: 7,
      );
      expect(preview.previewCoins, 65);
    });
  });

  group('DriftWalletRepository', () {
    late DriftWalletRepository repo;

    setUp(() {
      final db = openTestDatabase();
      repo = DriftWalletRepository(db);
    });

    test('returns empty snapshot on fresh db', () async {
      final snap = await repo.getSnapshot();
      expect(snap.coinBalance, 0);
      expect(snap.isStale, isTrue);
    });

    test('saveSnapshot and getSnapshot round-trips', () async {
      const snap = WalletSnapshot(
        coinBalance: 300,
        hintBalance: 3,
        walletRevision: 1,
        isStale: false,
      );
      await repo.saveSnapshot(snap);
      final loaded = await repo.getSnapshot();
      expect(loaded.coinBalance, 300);
      expect(loaded.hintBalance, 3);
      expect(loaded.walletRevision, 1);
      expect(loaded.isStale, isFalse);
    });

    test('applyPendingDelta accumulates', () async {
      await repo.saveSnapshot(const WalletSnapshot(coinBalance: 300));
      await repo.applyPendingDelta(coinDelta: -75, hintDelta: 1);
      final snap = await repo.getSnapshot();
      expect(snap.pendingCoinDelta, -75);
      expect(snap.pendingHintDelta, 1);
    });

    test('clearPendingDeltas resets to zero', () async {
      await repo.saveSnapshot(const WalletSnapshot(
        coinBalance: 300,
        pendingCoinDelta: -75,
        pendingHintDelta: 1,
      ));
      await repo.clearPendingDeltas();
      final snap = await repo.getSnapshot();
      expect(snap.pendingCoinDelta, 0);
      expect(snap.pendingHintDelta, 0);
    });
  });

  group('DriftEconomyOperationRepository', () {
    late DriftEconomyOperationRepository repo;

    setUp(() {
      final db = openTestDatabase();
      repo = DriftEconomyOperationRepository(db);
    });

    test('enqueue and loadPending', () async {
      final op = EconomyOperation(
        operationId: 'eco_001',
        type: EconomyOperationType.levelReward,
        idempotencyKey: 'idem_001',
        payload: {'levelId': 'l1', 'completionId': 'c1', 'remainingMoves': 4, 'streakCoins': 7},
        createdAt: DateTime.now().toUtc(),
        coinDelta: 65,
      );
      await repo.enqueue(op);
      final pending = await repo.loadPending();
      expect(pending.length, 1);
      expect(pending.first.operationId, 'eco_001');
      expect(pending.first.coinDelta, 65);
    });

    test('markCompleted removes from pending', () async {
      final op = EconomyOperation(
        operationId: 'eco_002',
        type: EconomyOperationType.hintPurchase,
        idempotencyKey: 'idem_002',
        payload: {},
        createdAt: DateTime.now().toUtc(),
        coinDelta: -75,
        hintDelta: 1,
      );
      await repo.enqueue(op);
      await repo.markCompleted('eco_002', serverTransactionId: 'txn_002');
      final pending = await repo.loadPending();
      expect(pending.where((o) => o.operationId == 'eco_002'), isEmpty);
    });

    test('purgeCompleted cleans up', () async {
      final op = EconomyOperation(
        operationId: 'eco_003',
        type: EconomyOperationType.chapterReward,
        idempotencyKey: 'idem_003',
        payload: {'chapterId': 'ch1'},
        createdAt: DateTime.now().toUtc(),
        coinDelta: 500,
        hintDelta: 2,
      );
      await repo.enqueue(op);
      await repo.markCompleted('eco_003', serverTransactionId: 'txn_003');
      await repo.purgeCompleted();
      final pending = await repo.loadPending();
      expect(pending.where((o) => o.operationId == 'eco_003'), isEmpty);
    });
  });
}
