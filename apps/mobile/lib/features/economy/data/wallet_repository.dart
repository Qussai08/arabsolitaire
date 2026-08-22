import 'package:mobile/features/economy/domain/economy_models.dart';

abstract interface class WalletRepository {
  Future<WalletSnapshot> getSnapshot();
  Stream<WalletSnapshot> watchSnapshot();
  Future<void> saveSnapshot(WalletSnapshot snapshot);
  Future<void> applyPendingDelta({
    required int coinDelta,
    required int hintDelta,
  });
  Future<void> clearPendingDeltas();
}
