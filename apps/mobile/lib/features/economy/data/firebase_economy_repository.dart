import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:mobile/features/economy/data/economy_repository.dart';
import 'package:mobile/features/economy/domain/economy_models.dart';

/// Production implementation calling Firebase Cloud Functions.
final class FirebaseEconomyRepository implements EconomyRepository {
  FirebaseEconomyRepository(this._functions);
  final FirebaseFunctions _functions;

  HttpsCallable _fn(String name) =>
      _functions.httpsCallable(name);

  @override
  Future<EconomyResult> initializeWallet() =>
      _call('initializeWallet', {});

  @override
  Future<EconomyResult> claimLevelReward({
    required String levelId,
    required String completionId,
    required int remainingMoves,
    required int streakCoins,
  }) =>
      _call('grantLevelReward', {
        'levelId': levelId,
        'completionId': completionId,
        'remainingMoves': remainingMoves,
        'streakCoins': streakCoins,
      });

  @override
  Future<EconomyResult> claimChapterReward({required String chapterId}) =>
      _call('grantChapterReward', {'chapterId': chapterId});

  @override
  Future<EconomyResult> purchaseHint({required String operationId}) =>
      _call('purchaseHint', {'operationId': operationId});

  @override
  Future<EconomyResult> consumeHint({required String operationId}) =>
      _call('consumeHint', {'operationId': operationId});

  @override
  Future<EconomyResult> purchaseExtraMoves({
    required String attemptId,
    required int rescueIndex,
  }) =>
      _call('purchaseExtraMoves', {
        'attemptId': attemptId,
        'rescueIndex': rescueIndex,
      });

  @override
  Future<EconomyResult> purchaseDeadEndRescue({required String attemptId}) =>
      _call('purchaseDeadEndRescue', {'attemptId': attemptId});

  @override
  Future<WalletSnapshot?> fetchServerSnapshot() async {
    try {
      final result = await _fn('getWalletSnapshot').call<dynamic>(<String, dynamic>{});
      final data =
          (result.data as Map<Object?, Object?>).cast<String, dynamic>();
      if (data['exists'] != true) return null;
      return WalletSnapshot(
        coinBalance: (data['coinBalance'] as num?)?.toInt() ?? 0,
        hintBalance: (data['hintBalance'] as num?)?.toInt() ?? 0,
        walletRevision: (data['walletRevision'] as num?)?.toInt() ?? 0,
        lastReconciledAt: DateTime.now().toUtc(),
        isStale: false,
      );
    } catch (_) {
      return null;
    }
  }

  Future<EconomyResult> _call(
    String functionName,
    Map<String, dynamic> payload,
  ) async {
    try {
      final result = await _fn(functionName).call<dynamic>(payload);
      final data =
          (result.data as Map<Object?, Object?>).cast<String, dynamic>();
      final success = data['success'] == true;
      if (success) {
        return EconomySuccess(
          operationId: data['operationId'] as String? ?? '',
          transactionId: (data['transactionIds'] as List?)?.firstOrNull
              as String?,
          walletSnapshot: WalletSnapshot(
            coinBalance: (data['coinBalanceAfter'] as num?)?.toInt() ?? 0,
            hintBalance: (data['hintBalanceAfter'] as num?)?.toInt() ?? 0,
            walletRevision:
                (data['walletRevision'] as num?)?.toInt() ?? 0,
            lastReconciledAt: DateTime.now().toUtc(),
            isStale: false,
          ),
          isPending: false,
        );
      } else {
        return EconomyFailure(
          operationId: data['operationId'] as String?,
          error: EconomyError(
            code: _parseErrorCode(data['errorCode'] as String?),
            message: data['errorMessage'] as String?,
          ),
        );
      }
    } on FirebaseFunctionsException catch (e) {
      if (e.code == 'unauthenticated') {
        return const EconomyFailure(
          error: EconomyError(code: EconomyErrorCode.authRequired),
        );
      }
      return EconomyFailure(
        error: EconomyError(
          code: EconomyErrorCode.serverUnavailable,
          message: e.message,
        ),
      );
    } catch (_) {
      return const EconomyFailure(
        error: EconomyError(code: EconomyErrorCode.serverUnavailable),
      );
    }
  }

  static EconomyErrorCode _parseErrorCode(String? code) {
    return switch (code) {
      'insufficientFunds' => EconomyErrorCode.insufficientFunds,
      'insufficientHints' => EconomyErrorCode.insufficientHints,
      'limitReached' => EconomyErrorCode.limitReached,
      'duplicate' => EconomyErrorCode.duplicate,
      'notEligible' => EconomyErrorCode.notEligible,
      'authRequired' => EconomyErrorCode.authRequired,
      _ => EconomyErrorCode.internalError,
    };
  }
}

/// Offline no-op repository for when Firebase is unavailable.
final class OfflineEconomyRepository implements EconomyRepository {
  const OfflineEconomyRepository();

  static EconomyResult get _offlineResult => const EconomyFailure(
        error: EconomyError(
          code: EconomyErrorCode.offlineQueued,
          message: 'Operation queued for sync',
        ),
      );

  @override
  Future<EconomyResult> initializeWallet() async => _offlineResult;
  @override
  Future<EconomyResult> claimLevelReward({
    required String levelId,
    required String completionId,
    required int remainingMoves,
    required int streakCoins,
  }) async =>
      _offlineResult;
  @override
  Future<EconomyResult> claimChapterReward({required String chapterId}) async =>
      _offlineResult;
  @override
  Future<EconomyResult> purchaseHint({required String operationId}) async =>
      _offlineResult;
  @override
  Future<EconomyResult> consumeHint({required String operationId}) async =>
      _offlineResult;
  @override
  Future<EconomyResult> purchaseExtraMoves({
    required String attemptId,
    required int rescueIndex,
  }) async =>
      _offlineResult;
  @override
  Future<EconomyResult> purchaseDeadEndRescue(
          {required String attemptId}) async =>
      _offlineResult;
  @override
  Future<WalletSnapshot?> fetchServerSnapshot() async => null;
}
