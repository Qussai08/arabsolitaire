/// Sprint 9 — Daily Reward, Daily Challenge, Streak & Notifications
/// Pure Dart — no SDK dependencies.
library;

// ── Config ────────────────────────────────────────────────────────────────────

abstract final class DailyConfig {
  /// 7-day repeating reward schedule.
  static const List<DailyRewardEntry> rewardSchedule = [
    DailyRewardEntry(dayIndex: 1, coins: 100, hints: 0),
    DailyRewardEntry(dayIndex: 2, coins: 125, hints: 0),
    DailyRewardEntry(dayIndex: 3, coins: 150, hints: 0),
    DailyRewardEntry(dayIndex: 4, coins: 0, hints: 1),
    DailyRewardEntry(dayIndex: 5, coins: 175, hints: 0),
    DailyRewardEntry(dayIndex: 6, coins: 200, hints: 0),
    DailyRewardEntry(dayIndex: 7, coins: 300, hints: 1),
  ];

  static const int challengeReward = 150;

  static const List<StreakMilestone> streakMilestones = [
    StreakMilestone(days: 3, coins: 100),
    StreakMilestone(days: 7, coins: 250),
    StreakMilestone(days: 14, coins: 400),
    StreakMilestone(days: 30, coins: 750),
  ];

  static const int quietHoursStartHour = 22;
  static const int quietHoursEndHour = 9;

  static const int timezoneChangeCooldownMinutes = 60;
  static const int minSecondsBetweenClaims = 3600 * 20;

  static const String cohortDefault = 'ar_global';
  static const int challengeRulesVersion = 1;
  static const int challengeGeneratorVersion = 1;
  static const int challengeSolverVersion = 1;

  static DailyRewardEntry rewardForDayIndex(int index) {
    final idx = ((index - 1) % 7) + 1;
    return rewardSchedule.firstWhere((e) => e.dayIndex == idx);
  }

  static int nextDayIndex(int current) => (current % 7) + 1;
}

// ── Daily reward ──────────────────────────────────────────────────────────────

final class DailyRewardEntry {
  const DailyRewardEntry({
    required this.dayIndex,
    required this.coins,
    required this.hints,
  });

  final int dayIndex;
  final int coins;
  final int hints;
}

final class DailyRewardState {
  const DailyRewardState({
    required this.calendarDayIndex,
    required this.lastClaimedDayKey,
    required this.lastClaimedAt,
    this.revision = 0,
  });

  final int calendarDayIndex;
  final String? lastClaimedDayKey;
  final DateTime? lastClaimedAt;
  final int revision;

  static const initial = DailyRewardState(
    calendarDayIndex: 1,
    lastClaimedDayKey: null,
    lastClaimedAt: null,
  );

  DailyRewardEntry get currentReward =>
      DailyConfig.rewardForDayIndex(calendarDayIndex);

  DailyRewardEntry get nextReward =>
      DailyConfig.rewardForDayIndex(DailyConfig.nextDayIndex(calendarDayIndex));
}

// ── Streak ────────────────────────────────────────────────────────────────────

final class StreakMilestone {
  const StreakMilestone({required this.days, required this.coins});
  final int days;
  final int coins;
}

final class StreakState {
  const StreakState({
    required this.currentStreakDays,
    required this.lastQualifiedDayKey,
    required this.longestStreakDays,
    required this.claimedMilestones,
    required this.streakCycleId,
    this.revision = 0,
  });

  final int currentStreakDays;
  final String? lastQualifiedDayKey;
  final int longestStreakDays;
  final List<int> claimedMilestones;
  final String streakCycleId;
  final int revision;

  static const initial = StreakState(
    currentStreakDays: 0,
    lastQualifiedDayKey: null,
    longestStreakDays: 0,
    claimedMilestones: [],
    streakCycleId: 'init',
  );

  StreakMilestone? get nextMilestone {
    for (final m in DailyConfig.streakMilestones) {
      if (m.days > currentStreakDays) return m;
    }
    return null;
  }
}

// ── Day key ───────────────────────────────────────────────────────────────────

/// Represents a validated player-local day key in YYYY-MM-DD format.
final class DayKey {
  const DayKey(this.value);

  final String value;

  static DayKey fromDate(DateTime localDate) {
    final y = localDate.year.toString().padLeft(4, '0');
    final m = localDate.month.toString().padLeft(2, '0');
    final d = localDate.day.toString().padLeft(2, '0');
    return DayKey('$y-$m-$d');
  }

  static DayKey today(DateTime Function() nowFn) => fromDate(nowFn());

  bool isBeforeOrSame(DayKey other) => value.compareTo(other.value) <= 0;
  bool isBefore(DayKey other) => value.compareTo(other.value) < 0;
  bool isSameDay(DayKey other) => value == other.value;

  @override
  String toString() => value;
  @override
  bool operator ==(Object other) => other is DayKey && other.value == value;
  @override
  int get hashCode => value.hashCode;
}

// ── Timezone ─────────────────────────────────────────────────────────────────

final class PlayerTimezone {
  const PlayerTimezone({
    required this.timezoneId,
    required this.offsetMinutes,
    required this.validatedAt,
    this.revision = 0,
    this.previousTimezoneId,
    this.lastChangedAt,
  });

  final String timezoneId;
  final int offsetMinutes;
  final DateTime validatedAt;
  final int revision;
  final String? previousTimezoneId;
  final DateTime? lastChangedAt;

  static final defaultTimezone = PlayerTimezone(
    timezoneId: 'UTC',
    offsetMinutes: 0,
    validatedAt: DateTime.utc(1970),
  );
}

// ── Daily challenge ───────────────────────────────────────────────────────────

final class DailyChallengeDefinition {
  const DailyChallengeDefinition({
    required this.challengeId,
    required this.dayKey,
    required this.cohortKey,
    required this.seed,
    required this.rewardAmount,
    required this.activeFrom,
    required this.activeUntil,
    required this.rulesVersion,
    required this.generatorVersion,
    required this.solverVersion,
    this.contentBundleVersion,
    this.boardFingerprint,
  });

  final String challengeId;
  final String dayKey;
  final String cohortKey;
  final int seed;
  final int rewardAmount;
  final DateTime activeFrom;
  final DateTime activeUntil;
  final int rulesVersion;
  final int generatorVersion;
  final int solverVersion;
  final String? contentBundleVersion;
  final String? boardFingerprint;

  bool get isExpired => DateTime.now().isAfter(activeUntil);
}

final class DailyChallengeState {
  const DailyChallengeState({
    required this.currentDayKey,
    required this.challengeId,
    required this.completed,
    required this.rewardGranted,
    this.completedAt,
    this.attemptCount = 0,
    this.revision = 0,
  });

  final String currentDayKey;
  final String challengeId;
  final bool completed;
  final bool rewardGranted;
  final DateTime? completedAt;
  final int attemptCount;
  final int revision;

  static const empty = DailyChallengeState(
    currentDayKey: '',
    challengeId: '',
    completed: false,
    rewardGranted: false,
  );
}

// ── Aggregated daily state ────────────────────────────────────────────────────

final class DailyStateSnapshot {
  const DailyStateSnapshot({
    required this.dayKey,
    required this.serverNow,
    required this.timezoneId,
    required this.rewardState,
    required this.streakState,
    required this.challengeState,
    required this.fetchedAt,
  });

  final String dayKey;
  final DateTime serverNow;
  final String timezoneId;
  final DailyRewardState rewardState;
  final StreakState streakState;
  final DailyChallengeState challengeState;
  final DateTime fetchedAt;

  bool get isStale {
    final dayFromFetch = DayKey.fromDate(fetchedAt);
    final dayNow = DayKey.fromDate(DateTime.now());
    return !dayFromFetch.isSameDay(dayNow);
  }
}

// ── Notification preferences ──────────────────────────────────────────────────

final class NotificationPreferences {
  const NotificationPreferences({
    this.dailyChallengeEnabled = true,
    this.streakRiskEnabled = true,
  });

  final bool dailyChallengeEnabled;
  final bool streakRiskEnabled;

  static const defaults = NotificationPreferences();

  NotificationPreferences copyWith({
    bool? dailyChallengeEnabled,
    bool? streakRiskEnabled,
  }) => NotificationPreferences(
    dailyChallengeEnabled: dailyChallengeEnabled ?? this.dailyChallengeEnabled,
    streakRiskEnabled: streakRiskEnabled ?? this.streakRiskEnabled,
  );
}

// ── Quiet hours ───────────────────────────────────────────────────────────────

abstract final class QuietHoursPolicy {
  static bool isInQuietHours(DateTime localTime) {
    final h = localTime.hour;
    return h >= DailyConfig.quietHoursStartHour ||
        h < DailyConfig.quietHoursEndHour;
  }
}

// ── Daily operation results ───────────────────────────────────────────────────

sealed class DailyClaimResult {
  const DailyClaimResult();
}

final class DailyClaimSuccess extends DailyClaimResult {
  const DailyClaimSuccess({
    required this.coinGrant,
    required this.hintGrant,
    this.idempotent = false,
  });
  final int coinGrant;
  final int hintGrant;
  final bool idempotent;
}

final class DailyClaimFailed extends DailyClaimResult {
  const DailyClaimFailed(this.reason);
  final String reason;
}

// ── Streak activity sources ───────────────────────────────────────────────────

enum DailyActivitySource { levelCompletion, dailyChallenge, dailyRewardClaim }
