import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/daily/application/daily_providers.dart';
import 'package:mobile/features/daily/data/daily_local_repository.dart';
import 'package:mobile/features/daily/data/daily_remote_repository.dart';
import 'package:mobile/features/daily/domain/daily_models.dart';

// ── View state ────────────────────────────────────────────────────────────────

sealed class DailyViewState {
  const DailyViewState();
}

final class DailyLoading extends DailyViewState {
  const DailyLoading();
}

final class DailyReady extends DailyViewState {
  const DailyReady({
    required this.snapshot,
    required this.preferences,
    required this.challengeDefinition,
    this.isClaimingReward = false,
    this.isClaimingChallenge = false,
  });

  final DailyStateSnapshot snapshot;
  final NotificationPreferences preferences;
  final DailyChallengeDefinition? challengeDefinition;
  final bool isClaimingReward;
  final bool isClaimingChallenge;

  DailyReady copyWith({
    DailyStateSnapshot? snapshot,
    NotificationPreferences? preferences,
    DailyChallengeDefinition? challengeDefinition,
    bool? isClaimingReward,
    bool? isClaimingChallenge,
  }) =>
      DailyReady(
        snapshot: snapshot ?? this.snapshot,
        preferences: preferences ?? this.preferences,
        challengeDefinition: challengeDefinition ?? this.challengeDefinition,
        isClaimingReward: isClaimingReward ?? this.isClaimingReward,
        isClaimingChallenge: isClaimingChallenge ?? this.isClaimingChallenge,
      );
}

final class DailyOffline extends DailyViewState {
  const DailyOffline({this.cachedSnapshot, this.preferences});
  final DailyStateSnapshot? cachedSnapshot;
  final NotificationPreferences? preferences;
}

final class DailyError extends DailyViewState {
  const DailyError(this.message);
  final String message;
}

// ── Controller ────────────────────────────────────────────────────────────────

final class DailyController extends Notifier<DailyViewState> {
  @override
  DailyViewState build() {
    _initialize();
    return const DailyLoading();
  }

  DailyLocalRepository? get _local => ref.read(dailyLocalRepositoryProvider);
  DailyRemoteRepository get _remote => ref.read(dailyRemoteRepositoryProvider);

  Future<void> _initialize() async {
    final prefs =
        await _local?.loadPreferences() ?? NotificationPreferences.defaults;

    // Try to load from cache first.
    final cached = await _local?.loadSnapshot();

    // Try remote refresh.
    final remote = await _remote.getDailyState();
    if (remote != null) {
      await _local?.saveSnapshot(remote);
      final challengeDef = await _refreshChallengeDef(remote);
      state = DailyReady(
        snapshot: remote,
        preferences: prefs,
        challengeDefinition: challengeDef,
      );
      return;
    }

    // Offline: use cache.
    if (cached != null) {
      DailyChallengeDefinition? def;
      if (cached.challengeState.currentDayKey.isNotEmpty) {
        def = await _local?.loadChallengeDefinition(
            cached.challengeState.currentDayKey);
      }
      state = DailyOffline(cachedSnapshot: cached, preferences: prefs);
      if (def != null) {
        // Still show offline state — challenge def is cached.
        state = DailyReady(
          snapshot: cached,
          preferences: prefs,
          challengeDefinition: def,
        );
      }
      return;
    }

    state = const DailyOffline();
  }

  Future<void> refresh() async {
    final current = state;
    final prefs = current is DailyReady
        ? current.preferences
        : await _local?.loadPreferences() ?? NotificationPreferences.defaults;

    final remote = await _remote.getDailyState();
    if (remote == null) {
      if (current is DailyReady) return;
      state = const DailyOffline();
      return;
    }

    await _local?.saveSnapshot(remote);
    final challengeDef = await _refreshChallengeDef(remote);
    state = DailyReady(
      snapshot: remote,
      preferences: prefs,
      challengeDefinition: challengeDef,
    );
  }

  Future<DailyChallengeDefinition?> _refreshChallengeDef(
      DailyStateSnapshot snapshot) async {
    final dayKey = snapshot.dayKey;
    // Try cache.
    final cached = await _local?.loadChallengeDefinition(dayKey);
    if (cached != null && !cached.isExpired) return cached;
    // Try remote.
    final remote = await _remote.getDailyChallenge();
    if (remote != null) {
      await _local?.saveChallengeDefinition(remote);
      return remote;
    }
    return cached;
  }

  // ── Reward claim ─────────────────────────────────────────────────────────────

  Future<DailyClaimResult> claimDailyReward() async {
    final current = state;
    if (current is! DailyReady || current.isClaimingReward) {
      return const DailyClaimFailed('not_ready');
    }
    state = current.copyWith(isClaimingReward: true);
    try {
      final result = await _remote.claimDailyReward();
      if (result is DailyClaimSuccess) {
        await refresh();
      }
      return result;
    } finally {
      final s = state;
      if (s is DailyReady) state = s.copyWith(isClaimingReward: false);
    }
  }

  // ── Challenge ────────────────────────────────────────────────────────────────

  Future<DailyClaimResult> claimChallengeReward({
    required String challengeId,
    required String dayKey,
  }) async {
    final current = state;
    if (current is! DailyReady || current.isClaimingChallenge) {
      return const DailyClaimFailed('not_ready');
    }
    state = current.copyWith(isClaimingChallenge: true);
    try {
      final result = await _remote.claimDailyChallengeReward(
        challengeId: challengeId,
        dayKey: dayKey,
      );
      if (result is DailyClaimSuccess) {
        await refresh();
        // Mark streak activity.
        unawaited(_remote.markDailyActivity(
          source: DailyActivitySource.dailyChallenge,
        ));
      }
      return result;
    } finally {
      final s = state;
      if (s is DailyReady) state = s.copyWith(isClaimingChallenge: false);
    }
  }

  Future<void> onLevelCompleted() async {
    await _remote.markDailyActivity(source: DailyActivitySource.levelCompletion);
    unawaited(refresh());
  }

  // ── Preferences ──────────────────────────────────────────────────────────────

  Future<void> updatePreferences(NotificationPreferences prefs) async {
    await _local?.savePreferences(prefs);
    await _remote.updateNotificationPreferences(prefs);
    final s = state;
    if (s is DailyReady) state = s.copyWith(preferences: prefs);
  }
}

void unawaited(Future<dynamic> future) {
  future.ignore();
}

// ── Providers ─────────────────────────────────────────────────────────────────

final dailyControllerProvider =
    NotifierProvider<DailyController, DailyViewState>(
  DailyController.new,
);
