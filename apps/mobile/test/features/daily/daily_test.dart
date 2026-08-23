// Sprint 9 — Daily Reward, Streak, Challenge & Notifications unit tests.
//
// Coverage:
//  1. DayKey formatting and comparison.
//  2. DailyConfig reward schedule.
//  3. StreakState milestone logic.
//  4. QuietHoursPolicy.
//  5. DailyRewardState helpers.
//  6. DriftDailyLocalRepository read/write round-trips.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/storage/database_provider.dart';
import 'package:mobile/features/daily/data/daily_local_repository.dart';
import 'package:mobile/features/daily/domain/daily_models.dart';

void main() {
  // ── DayKey ─────────────────────────────────────────────────────────────────

  group('DayKey', () {
    test('fromDate formats YYYY-MM-DD', () {
      final d = DateTime(2026, 8, 22);
      expect(DayKey.fromDate(d).value, '2026-08-22');
    });

    test('fromDate pads single-digit month and day', () {
      final d = DateTime(2026, 1, 3);
      expect(DayKey.fromDate(d).value, '2026-01-03');
    });

    test('isSameDay true for same key', () {
      const a = DayKey('2026-08-22');
      const b = DayKey('2026-08-22');
      expect(a.isSameDay(b), isTrue);
    });

    test('isBefore true for earlier key', () {
      const a = DayKey('2026-08-21');
      const b = DayKey('2026-08-22');
      expect(a.isBefore(b), isTrue);
      expect(b.isBefore(a), isFalse);
    });

    test('today returns correct DayKey', () {
      final fixed = DateTime(2026, 8, 22, 14, 0, 0);
      final key = DayKey.today(() => fixed);
      expect(key.value, '2026-08-22');
    });
  });

  // ── DailyConfig reward schedule ────────────────────────────────────────────

  group('DailyConfig reward schedule', () {
    test('7 entries in schedule', () {
      expect(DailyConfig.rewardSchedule.length, 7);
    });

    test('day 7 gives maximum coins', () {
      final entry = DailyConfig.rewardForDayIndex(7);
      expect(entry.coins, 300);
      expect(entry.hints, 1);
    });

    test('schedule wraps at 8 (8 → same as 1)', () {
      final e1 = DailyConfig.rewardForDayIndex(1);
      final e8 = DailyConfig.rewardForDayIndex(8);
      expect(e1.coins, e8.coins);
      expect(e1.hints, e8.hints);
    });

    test('nextDayIndex wraps at 7', () {
      expect(DailyConfig.nextDayIndex(7), 1);
      expect(DailyConfig.nextDayIndex(6), 7);
    });

    test('day 4 gives a hint not coins', () {
      final entry = DailyConfig.rewardForDayIndex(4);
      expect(entry.coins, 0);
      expect(entry.hints, 1);
    });
  });

  // ── StreakState helpers ────────────────────────────────────────────────────

  group('StreakState', () {
    test('initial streak is 0', () {
      expect(StreakState.initial.currentStreakDays, 0);
    });

    test('nextMilestone returns first unclaimed milestone', () {
      const s = StreakState(
        currentStreakDays: 4,
        lastQualifiedDayKey: null,
        longestStreakDays: 4,
        claimedMilestones: [],
        streakCycleId: 'c1',
      );
      // currentStreak=4, next milestone should be day 7
      expect(s.nextMilestone?.days, 7);
    });

    test('nextMilestone null when all milestones surpassed', () {
      const s = StreakState(
        currentStreakDays: 100,
        lastQualifiedDayKey: null,
        longestStreakDays: 100,
        claimedMilestones: [],
        streakCycleId: 'c1',
      );
      expect(s.nextMilestone, isNull);
    });
  });

  // ── QuietHoursPolicy ──────────────────────────────────────────────────────

  group('QuietHoursPolicy', () {
    test('23:00 is in quiet hours', () {
      expect(
        QuietHoursPolicy.isInQuietHours(DateTime(2026, 1, 1, 23, 0)),
        isTrue,
      );
    });

    test('00:00 is in quiet hours', () {
      expect(
        QuietHoursPolicy.isInQuietHours(DateTime(2026, 1, 1, 0, 0)),
        isTrue,
      );
    });

    test('08:59 is in quiet hours', () {
      expect(
        QuietHoursPolicy.isInQuietHours(DateTime(2026, 1, 1, 8, 59)),
        isTrue,
      );
    });

    test('09:00 is not in quiet hours', () {
      expect(
        QuietHoursPolicy.isInQuietHours(DateTime(2026, 1, 1, 9, 0)),
        isFalse,
      );
    });

    test('14:00 is not in quiet hours', () {
      expect(
        QuietHoursPolicy.isInQuietHours(DateTime(2026, 1, 1, 14, 0)),
        isFalse,
      );
    });
  });

  // ── DailyRewardState helpers ──────────────────────────────────────────────

  group('DailyRewardState', () {
    test('initial starts at day index 1', () {
      expect(DailyRewardState.initial.calendarDayIndex, 1);
    });

    test('currentReward for day 1 is 100 coins', () {
      expect(DailyRewardState.initial.currentReward.coins, 100);
    });

    test('nextReward for day 1 is day 2 (125 coins)', () {
      expect(DailyRewardState.initial.nextReward.coins, 125);
    });
  });

  // ── NotificationPreferences ───────────────────────────────────────────────

  group('NotificationPreferences', () {
    test('defaults are all enabled', () {
      const p = NotificationPreferences.defaults;
      expect(p.dailyChallengeEnabled, isTrue);
      expect(p.streakRiskEnabled, isTrue);
    });

    test('copyWith partial update', () {
      const p = NotificationPreferences.defaults;
      final updated = p.copyWith(dailyChallengeEnabled: false);
      expect(updated.dailyChallengeEnabled, isFalse);
      expect(updated.streakRiskEnabled, isTrue);
    });
  });

  // ── DriftDailyLocalRepository ─────────────────────────────────────────────

  group('DriftDailyLocalRepository', () {
    late DriftDailyLocalRepository repo;

    setUp(() {
      final db = openTestDatabase();
      repo = DriftDailyLocalRepository(db);
    });

    test('loadPreferences returns defaults when empty', () async {
      final prefs = await repo.loadPreferences();
      expect(prefs, isNotNull);
    });

    test('savePreferences and reload round-trips', () async {
      const prefs = NotificationPreferences(
        dailyChallengeEnabled: false,
        streakRiskEnabled: true,
      );
      await repo.savePreferences(prefs);
      final loaded = await repo.loadPreferences();
      expect(loaded.dailyChallengeEnabled, isFalse);
      expect(loaded.streakRiskEnabled, isTrue);
    });

    test('loadSnapshot returns null initially', () async {
      final snap = await repo.loadSnapshot();
      expect(snap, isNull);
    });
  });
}
