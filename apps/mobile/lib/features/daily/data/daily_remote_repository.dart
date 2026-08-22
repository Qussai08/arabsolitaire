import 'package:cloud_functions/cloud_functions.dart';
import 'package:mobile/features/daily/domain/daily_models.dart';
import 'package:mobile/features/notifications/domain/notification_models.dart';

abstract interface class DailyRemoteRepository {
  Future<DailyStateSnapshot?> getDailyState();
  Future<DailyClaimResult> claimDailyReward();
  Future<DailyClaimResult> claimDailyChallengeReward({
    required String challengeId,
    required String dayKey,
  });
  Future<void> markDailyActivity({required DailyActivitySource source});
  Future<DailyChallengeDefinition?> getDailyChallenge();
  Future<void> registerDevice(DeviceRegistrationInfo info);
  Future<void> updateNotificationPreferences(NotificationPreferences prefs);
  Future<void> updateTimezone(PlayerTimezone timezone);
}

final class FirebaseDailyRemoteRepository implements DailyRemoteRepository {
  FirebaseDailyRemoteRepository(this._functions);
  final FirebaseFunctions _functions;

  @override
  Future<DailyStateSnapshot?> getDailyState() async {
    try {
      final callable = _functions.httpsCallable('getDailyState');
      final result = await callable.call<Map<Object?, Object?>>(<String, dynamic>{});
      final data = (result.data).cast<String, dynamic>();
      return _parseSnapshot(data);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<DailyClaimResult> claimDailyReward() async {
    try {
      final callable = _functions.httpsCallable('claimDailyReward');
      final result = await callable.call<Map<Object?, Object?>>(<String, dynamic>{});
      final data = (result.data).cast<String, dynamic>();
      return DailyClaimSuccess(
        coinGrant: (data['coinGrant'] as int?) ?? 0,
        hintGrant: (data['hintGrant'] as int?) ?? 0,
        idempotent: (data['idempotent'] as bool?) ?? false,
      );
    } on FirebaseFunctionsException catch (e) {
      return DailyClaimFailed(e.message ?? e.code);
    } catch (e) {
      return DailyClaimFailed(e.toString());
    }
  }

  @override
  Future<DailyClaimResult> claimDailyChallengeReward({
    required String challengeId,
    required String dayKey,
  }) async {
    try {
      final callable = _functions.httpsCallable('claimDailyChallengeReward');
      final result = await callable.call<Map<Object?, Object?>>({
        'challengeId': challengeId,
        'dayKey': dayKey,
      });
      final data = (result.data).cast<String, dynamic>();
      return DailyClaimSuccess(
        coinGrant: (data['coinGrant'] as int?) ?? 0,
        hintGrant: 0,
        idempotent: (data['idempotent'] as bool?) ?? false,
      );
    } on FirebaseFunctionsException catch (e) {
      return DailyClaimFailed(e.message ?? e.code);
    } catch (e) {
      return DailyClaimFailed(e.toString());
    }
  }

  @override
  Future<void> markDailyActivity({required DailyActivitySource source}) async {
    try {
      final callable = _functions.httpsCallable('markDailyActivity');
      await callable.call<Map<Object?, Object?>>({'source': source.name});
    } catch (_) {}
  }

  @override
  Future<DailyChallengeDefinition?> getDailyChallenge() async {
    try {
      final callable = _functions.httpsCallable('getDailyChallenge');
      final result = await callable.call<Map<Object?, Object?>>(<String, dynamic>{});
      final data = (result.data).cast<String, dynamic>();
      return _parseChallengeDef(data);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> registerDevice(DeviceRegistrationInfo info) async {
    try {
      final callable = _functions.httpsCallable('registerDeviceToken');
      await callable.call<Map<Object?, Object?>>({
        'fcmToken': info.fcmToken,
        'platform': info.platform,
        'timezoneId': info.timezoneId,
        'notificationsEnabled': info.notificationsEnabled,
        'appVersion': info.appVersion ?? '',
      });
    } catch (_) {}
  }

  @override
  Future<void> updateNotificationPreferences(
      NotificationPreferences prefs) async {
    try {
      final callable =
          _functions.httpsCallable('updateNotificationPreferences');
      await callable.call<Map<Object?, Object?>>({
        'dailyChallengeNotificationsEnabled': prefs.dailyChallengeEnabled,
        'streakRiskNotificationsEnabled': prefs.streakRiskEnabled,
      });
    } catch (_) {}
  }

  @override
  Future<void> updateTimezone(PlayerTimezone timezone) async {
    try {
      final callable = _functions.httpsCallable('updateTimezone');
      await callable.call<Map<Object?, Object?>>({
        'timezoneId': timezone.timezoneId,
        'offsetMinutes': timezone.offsetMinutes,
      });
    } catch (_) {}
  }

  // ── Parsers ─────────────────────────────────────────────────────────────────

  static DailyStateSnapshot? _parseSnapshot(Map<String, dynamic> data) {
    try {
      final reward = (data['dailyRewardState'] as Map?)?.cast<String, dynamic>() ?? {};
      final streak = (data['streakState'] as Map?)?.cast<String, dynamic>() ?? {};
      final challenge = (data['dailyChallengeState'] as Map?)?.cast<String, dynamic>() ?? {};

      return DailyStateSnapshot(
        dayKey: data['dayKey'] as String? ?? '',
        serverNow: DateTime.tryParse(data['serverNow'] as String? ?? '') ??
            DateTime.now(),
        timezoneId: data['timezoneId'] as String? ?? 'UTC',
        rewardState: DailyRewardState(
          calendarDayIndex: (reward['calendarDayIndex'] as int?) ?? 1,
          lastClaimedDayKey: reward['lastClaimedDayKey'] as String?,
          lastClaimedAt:
              DateTime.tryParse(reward['lastClaimedAt'] as String? ?? ''),
          revision: (reward['revision'] as int?) ?? 0,
        ),
        streakState: StreakState(
          currentStreakDays: (streak['currentStreakDays'] as int?) ?? 0,
          lastQualifiedDayKey: streak['lastQualifiedDayKey'] as String?,
          longestStreakDays: (streak['longestStreakDays'] as int?) ?? 0,
          claimedMilestones: ((streak['claimedMilestones'] as List?) ?? []).cast<int>(),
          streakCycleId: streak['streakCycleId'] as String? ?? 'init',
          revision: (streak['revision'] as int?) ?? 0,
        ),
        challengeState: DailyChallengeState(
          currentDayKey: challenge['currentDayKey'] as String? ?? '',
          challengeId: challenge['challengeId'] as String? ?? '',
          completed: (challenge['completed'] as bool?) ?? false,
          rewardGranted: (challenge['rewardGranted'] as bool?) ?? false,
          completedAt:
              DateTime.tryParse(challenge['completedAt'] as String? ?? ''),
          attemptCount: (challenge['attemptCount'] as int?) ?? 0,
          revision: (challenge['revision'] as int?) ?? 0,
        ),
        fetchedAt: DateTime.now(),
      );
    } catch (_) {
      return null;
    }
  }

  static DailyChallengeDefinition? _parseChallengeDef(
      Map<String, dynamic> data) {
    try {
      return DailyChallengeDefinition(
        challengeId: data['challengeId'] as String,
        dayKey: data['dayKey'] as String,
        cohortKey: data['cohortKey'] as String? ?? DailyConfig.cohortDefault,
        seed: data['seed'] as int,
        rewardAmount: (data['rewardAmount'] as int?) ?? DailyConfig.challengeReward,
        activeFrom: DateTime.parse(data['activeFrom'] as String),
        activeUntil: DateTime.parse(data['activeUntil'] as String),
        rulesVersion: (data['rulesVersion'] as int?) ??
            DailyConfig.challengeRulesVersion,
        generatorVersion: (data['generatorVersion'] as int?) ??
            DailyConfig.challengeGeneratorVersion,
        solverVersion: (data['solverVersion'] as int?) ??
            DailyConfig.challengeSolverVersion,
        contentBundleVersion: data['contentBundleVersion'] as String?,
        boardFingerprint: data['boardFingerprint'] as String?,
      );
    } catch (_) {
      return null;
    }
  }
}

/// Offline stub.
final class OfflineDailyRemoteRepository implements DailyRemoteRepository {
  const OfflineDailyRemoteRepository();

  @override
  Future<DailyStateSnapshot?> getDailyState() async => null;
  @override
  Future<DailyClaimResult> claimDailyReward() async =>
      const DailyClaimFailed('offline');
  @override
  Future<DailyClaimResult> claimDailyChallengeReward({
    required String challengeId,
    required String dayKey,
  }) async =>
      const DailyClaimFailed('offline');
  @override
  Future<void> markDailyActivity({required DailyActivitySource source}) async {}
  @override
  Future<DailyChallengeDefinition?> getDailyChallenge() async => null;
  @override
  Future<void> registerDevice(DeviceRegistrationInfo info) async {}
  @override
  Future<void> updateNotificationPreferences(
      NotificationPreferences prefs) async {}
  @override
  Future<void> updateTimezone(PlayerTimezone timezone) async {}
}
