// Sprint 9 — Daily Reward, Streak, and Challenge configuration.
// Must stay in sync with DailyConfig in apps/mobile/lib/features/daily/domain/daily_models.dart

export const DailyConfig = {
  rewardSchedule: [
    { dayIndex: 1, coins: 100, hints: 0 },
    { dayIndex: 2, coins: 125, hints: 0 },
    { dayIndex: 3, coins: 150, hints: 0 },
    { dayIndex: 4, coins: 0,   hints: 1 },
    { dayIndex: 5, coins: 175, hints: 0 },
    { dayIndex: 6, coins: 200, hints: 0 },
    { dayIndex: 7, coins: 300, hints: 1 },
  ] as { dayIndex: number; coins: number; hints: number }[],

  challengeReward: 150,

  streakMilestones: [
    { days: 3,  coins: 100 },
    { days: 7,  coins: 250 },
    { days: 14, coins: 400 },
    { days: 30, coins: 750 },
  ] as { days: number; coins: number }[],

  quietHoursStartHour: 22,
  quietHoursEndHour: 9,

  timezoneChangeCooldownMinutes: 60,
  // Minimum seconds between same-day claims (20 hours)
  minSecondsBetweenClaims: 3600 * 20,

  cohortDefault: "ar_global",
  challengeRulesVersion: 1,
  dailyStateSchemaVersion: 1,
} as const;

export function rewardForDayIndex(
  index: number
): { dayIndex: number; coins: number; hints: number } {
  const idx = ((index - 1) % 7) + 1;
  return DailyConfig.rewardSchedule.find((e) => e.dayIndex === idx)!;
}

export function nextDayIndex(current: number): number {
  return (current % 7) + 1;
}

/** Returns YYYY-MM-DD for a UTC date clamped to player's offset. */
export function utcToDayKey(utcMs: number, offsetMinutes: number): string {
  const local = new Date(utcMs + offsetMinutes * 60_000);
  const y = local.getUTCFullYear().toString().padStart(4, "0");
  const m = (local.getUTCMonth() + 1).toString().padStart(2, "0");
  const d = local.getUTCDate().toString().padStart(2, "0");
  return `${y}-${m}-${d}`;
}

export type DailyRewardStateDoc = {
  calendarDayIndex: number;
  lastClaimedDayKey: string | null;
  lastClaimedAt: string | null; // ISO UTC
  revision: number;
};

export type StreakStateDoc = {
  currentStreakDays: number;
  lastQualifiedDayKey: string | null;
  longestStreakDays: number;
  claimedMilestones: number[];
  streakCycleId: string;
  revision: number;
};

export type DailyChallengeStateDoc = {
  currentDayKey: string;
  challengeId: string;
  completed: boolean;
  rewardGranted: boolean;
  completedAt: string | null;
  attemptCount: number;
  revision: number;
};

export type TimezoneDoc = {
  timezoneId: string;
  offsetMinutes: number;
  validatedAt: string;
  revision: number;
  previousTimezoneId?: string;
  lastChangedAt?: string;
};
