import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mobile/core/storage/app_database.dart' as db_lib;
import 'package:mobile/features/daily/domain/daily_models.dart';
import 'package:mobile/features/notifications/domain/notification_models.dart';

abstract interface class DailyLocalRepository {
  Future<DailyStateSnapshot?> loadSnapshot();
  Future<void> saveSnapshot(DailyStateSnapshot snapshot);
  Future<DailyChallengeDefinition?> loadChallengeDefinition(String dayKey);
  Future<void> saveChallengeDefinition(DailyChallengeDefinition def);
  Future<NotificationPreferences> loadPreferences();
  Future<void> savePreferences(NotificationPreferences prefs);
  Future<void> saveDeviceRegistration(DeviceRegistrationInfo info);
  Future<DeviceRegistrationInfo?> loadDeviceRegistration(String deviceId);
}

final class DriftDailyLocalRepository implements DailyLocalRepository {
  DriftDailyLocalRepository(this._db);
  final db_lib.AppDatabase _db;
  static const _mainId = 'main';

  @override
  Future<DailyStateSnapshot?> loadSnapshot() async {
    final row = await (_db.select(_db.dailyStateCacheRows)
          ..where((t) => t.id.equals(_mainId)))
        .getSingleOrNull();
    if (row == null) return null;
    return _rowToSnapshot(row);
  }

  @override
  Future<void> saveSnapshot(DailyStateSnapshot snapshot) async {
    final rewardState = snapshot.rewardState;
    final streak = snapshot.streakState;
    final challenge = snapshot.challengeState;
    await _db.into(_db.dailyStateCacheRows).insertOnConflictUpdate(
          db_lib.DailyStateCacheRowsCompanion(
            id: const Value(_mainId),
            dayKey: Value(snapshot.dayKey),
            timezoneId: Value(snapshot.timezoneId),
            rewardCalendarDayIndex: Value(rewardState.calendarDayIndex),
            rewardLastClaimedDayKey: Value(rewardState.lastClaimedDayKey),
            rewardLastClaimedAt: Value(rewardState.lastClaimedAt),
            rewardRevision: Value(rewardState.revision),
            streakCurrentDays: Value(streak.currentStreakDays),
            streakLastQualifiedDayKey: Value(streak.lastQualifiedDayKey),
            streakLongestDays: Value(streak.longestStreakDays),
            streakClaimedMilestonesJson:
                Value(jsonEncode(streak.claimedMilestones)),
            streakCycleId: Value(streak.streakCycleId),
            streakRevision: Value(streak.revision),
            challengeCurrentDayKey: Value(challenge.currentDayKey.isEmpty
                ? null
                : challenge.currentDayKey),
            challengeId:
                Value(challenge.challengeId.isEmpty ? null : challenge.challengeId),
            challengeCompleted: Value(challenge.completed),
            challengeRewardGranted: Value(challenge.rewardGranted),
            challengeCompletedAt: Value(challenge.completedAt),
            challengeAttemptCount: Value(challenge.attemptCount),
            fetchedAt: Value(snapshot.fetchedAt),
          ),
        );
  }

  @override
  Future<DailyChallengeDefinition?> loadChallengeDefinition(
      String dayKey) async {
    final row = await (_db.select(_db.dailyChallengeCacheRows)
          ..where((t) => t.dayKey.equals(dayKey))
          ..orderBy([(t) => OrderingTerm.desc(t.cachedAt)])
          ..limit(1))
        .getSingleOrNull();
    if (row == null) return null;
    return _rowToChallengeDef(row);
  }

  @override
  Future<void> saveChallengeDefinition(DailyChallengeDefinition def) async {
    await _db.into(_db.dailyChallengeCacheRows).insertOnConflictUpdate(
          db_lib.DailyChallengeCacheRowsCompanion(
            challengeId: Value(def.challengeId),
            dayKey: Value(def.dayKey),
            cohortKey: Value(def.cohortKey),
            seed: Value(def.seed),
            rewardAmount: Value(def.rewardAmount),
            activeFrom: Value(def.activeFrom),
            activeUntil: Value(def.activeUntil),
            rulesVersion: Value(def.rulesVersion),
            generatorVersion: Value(def.generatorVersion),
            solverVersion: Value(def.solverVersion),
            contentBundleVersion: Value(def.contentBundleVersion),
            boardFingerprint: Value(def.boardFingerprint),
          ),
        );
  }

  @override
  Future<NotificationPreferences> loadPreferences() async {
    final row = await (_db.select(_db.notificationPreferenceRows)
          ..where((t) => t.id.equals(_mainId)))
        .getSingleOrNull();
    if (row == null) return NotificationPreferences.defaults;
    return NotificationPreferences(
      dailyChallengeEnabled: row.dailyChallengeEnabled,
      streakRiskEnabled: row.streakRiskEnabled,
    );
  }

  @override
  Future<void> savePreferences(NotificationPreferences prefs) async {
    await _db.into(_db.notificationPreferenceRows).insertOnConflictUpdate(
          db_lib.NotificationPreferenceRowsCompanion(
            id: const Value(_mainId),
            dailyChallengeEnabled: Value(prefs.dailyChallengeEnabled),
            streakRiskEnabled: Value(prefs.streakRiskEnabled),
          ),
        );
  }

  @override
  Future<void> saveDeviceRegistration(DeviceRegistrationInfo info) async {
    await _db.into(_db.deviceRegistrationRows).insertOnConflictUpdate(
          db_lib.DeviceRegistrationRowsCompanion(
            deviceId: Value(info.deviceId),
            fcmToken: Value(info.fcmToken),
            platform: Value(info.platform),
            timezoneId: Value(info.timezoneId),
            notificationsEnabled: Value(info.notificationsEnabled),
            appVersion: Value(info.appVersion),
            lastSeenAt: Value(DateTime.now()),
          ),
        );
  }

  @override
  Future<DeviceRegistrationInfo?> loadDeviceRegistration(
      String deviceId) async {
    final row = await (_db.select(_db.deviceRegistrationRows)
          ..where((t) => t.deviceId.equals(deviceId)))
        .getSingleOrNull();
    if (row == null) return null;
    return DeviceRegistrationInfo(
      deviceId: row.deviceId,
      fcmToken: row.fcmToken,
      platform: row.platform,
      timezoneId: row.timezoneId,
      notificationsEnabled: row.notificationsEnabled,
      appVersion: row.appVersion,
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  static DailyStateSnapshot _rowToSnapshot(db_lib.DailyStateCacheRow row) {
    final milestones = (jsonDecode(row.streakClaimedMilestonesJson) as List)
        .cast<int>();
    return DailyStateSnapshot(
      dayKey: row.dayKey,
      serverNow: row.fetchedAt,
      timezoneId: row.timezoneId,
      rewardState: DailyRewardState(
        calendarDayIndex: row.rewardCalendarDayIndex,
        lastClaimedDayKey: row.rewardLastClaimedDayKey,
        lastClaimedAt: row.rewardLastClaimedAt,
        revision: row.rewardRevision,
      ),
      streakState: StreakState(
        currentStreakDays: row.streakCurrentDays,
        lastQualifiedDayKey: row.streakLastQualifiedDayKey,
        longestStreakDays: row.streakLongestDays,
        claimedMilestones: milestones,
        streakCycleId: row.streakCycleId,
        revision: row.streakRevision,
      ),
      challengeState: DailyChallengeState(
        currentDayKey: row.challengeCurrentDayKey ?? '',
        challengeId: row.challengeId ?? '',
        completed: row.challengeCompleted,
        rewardGranted: row.challengeRewardGranted,
        completedAt: row.challengeCompletedAt,
        attemptCount: row.challengeAttemptCount,
      ),
      fetchedAt: row.fetchedAt,
    );
  }

  static DailyChallengeDefinition _rowToChallengeDef(
      db_lib.DailyChallengeCacheRow row) {
    return DailyChallengeDefinition(
      challengeId: row.challengeId,
      dayKey: row.dayKey,
      cohortKey: row.cohortKey,
      seed: row.seed,
      rewardAmount: row.rewardAmount,
      activeFrom: row.activeFrom,
      activeUntil: row.activeUntil,
      rulesVersion: row.rulesVersion,
      generatorVersion: row.generatorVersion,
      solverVersion: row.solverVersion,
      contentBundleVersion: row.contentBundleVersion,
      boardFingerprint: row.boardFingerprint,
    );
  }
}
