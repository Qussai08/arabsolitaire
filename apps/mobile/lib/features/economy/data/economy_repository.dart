import 'package:mobile/features/economy/domain/economy_models.dart';

abstract interface class EconomyRepository {
  Future<EconomyResult> initializeWallet();
  Future<EconomyResult> claimLevelReward({
    required String levelId,
    required String completionId,
    required int remainingMoves,
    required int streakCoins,
  });
  Future<EconomyResult> claimChapterReward({required String chapterId});
  Future<EconomyResult> purchaseHint({required String operationId});
  Future<EconomyResult> consumeHint({required String operationId});
  Future<EconomyResult> purchaseExtraMoves({
    required String attemptId,
    required int rescueIndex,
  });
  Future<EconomyResult> purchaseDeadEndRescue({required String attemptId});
  Future<WalletSnapshot?> fetchServerSnapshot();
}
