import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/account/data/auth_repository.dart';
import 'package:mobile/features/account/domain/auth_models.dart';
import 'package:mobile/features/sync/application/sync_engine.dart';
import 'package:mobile/features/sync/application/sync_providers.dart';
import 'package:mobile/features/sync/domain/sync_models.dart';

/// UI-facing auth state managed by [AccountController].
sealed class AccountViewState {
  const AccountViewState();
}

final class AccountLoading extends AccountViewState {
  const AccountLoading();
}

final class AccountReady extends AccountViewState {
  const AccountReady({required this.authState, required this.syncStatus});
  final AuthState authState;
  final SyncStatus syncStatus;
}

final class AccountError extends AccountViewState {
  const AccountError(this.message);
  final String message;
}

// ── Controller ────────────────────────────────────────────────────────────────

class AccountController extends Notifier<AccountViewState> {
  @override
  AccountViewState build() {
    Future.microtask(_initialize);
    return const AccountLoading();
  }

  SyncEngine? get _sync => ref.read(syncEngineProvider);
  AuthRepository get _authRepo => ref.read(authRepositoryProvider);

  Future<void> _initialize() async {
    try {
      final authState = await _authRepo.ensureAnonymousIdentity();
      state = AccountReady(
        authState: authState,
        syncStatus: SyncStatus.idle,
      );
      // After securing identity, trigger initial pull+merge.
      await syncNow();
    } catch (e) {
      state = AccountError(e.toString());
    }
  }

  Future<void> syncNow() async {
    final engine = _sync;
    if (engine == null) return;
    final current = state;
    if (current is AccountReady) {
      state = AccountReady(
        authState: current.authState,
        syncStatus: SyncStatus.syncing,
      );
    }
    final pullStatus = await engine.pullAndMerge();
    final flushStatus = await engine.flush();
    final finalStatus = (pullStatus == SyncStatus.synced &&
            flushStatus == SyncStatus.synced)
        ? SyncStatus.synced
        : SyncStatus.recoverableError;
    final current2 = state;
    if (current2 is AccountReady) {
      state = AccountReady(
        authState: current2.authState,
        syncStatus: finalStatus,
      );
    }
  }

  Future<LinkResult> linkGoogle() async {
    final result = await _authRepo.linkGoogle();
    if (result.isSuccess) {
      final newState = await _authRepo.currentState();
      final current = state;
      state = AccountReady(
        authState: newState,
        syncStatus:
            current is AccountReady ? current.syncStatus : SyncStatus.idle,
      );
    }
    return result;
  }

  Future<LinkResult> linkApple() async {
    final result = await _authRepo.linkApple();
    if (result.isSuccess) {
      final newState = await _authRepo.currentState();
      final current = state;
      state = AccountReady(
        authState: newState,
        syncStatus:
            current is AccountReady ? current.syncStatus : SyncStatus.idle,
      );
    }
    return result;
  }
}

final accountControllerProvider =
    NotifierProvider<AccountController, AccountViewState>(
  AccountController.new,
);
