// Sprint 9 — Daily Reward / Streak / Challenge Cloud Functions.

import { onCall, HttpsError, CallableRequest } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import {
  DailyConfig,
  DailyRewardStateDoc,
  DailyChallengeStateDoc,
  StreakStateDoc,
  TimezoneDoc,
  rewardForDayIndex,
  nextDayIndex,
  utcToDayKey,
} from "./daily_config";
import { atomicWalletMutation } from "../economy/wallet_service";

// ── Auth helper ───────────────────────────────────────────────────────────────

function requireAuth(request: CallableRequest): string {
  if (!request.auth) throw new HttpsError("unauthenticated", "Auth required");
  return request.auth.uid;
}

// ── Firestore path helpers ────────────────────────────────────────────────────

const db = () => getFirestore();
const playerRef = (uid: string) => db().collection("players").doc(uid);
const rewardRef = (uid: string) =>
  playerRef(uid).collection("daily").doc("reward");
const streakRef = (uid: string) =>
  playerRef(uid).collection("daily").doc("streak");
const challengeStatusRef = (uid: string) =>
  playerRef(uid).collection("daily").doc("challengeStatus");
const timezoneRef = (uid: string) =>
  playerRef(uid).collection("daily").doc("timezone");
const challengeDefRef = (dayKey: string) =>
  db().collection("dailyChallenges").doc(dayKey);

// ── Timezone loader ───────────────────────────────────────────────────────────

async function loadTimezone(uid: string): Promise<TimezoneDoc> {
  const snap = await timezoneRef(uid).get();
  if (snap.exists) return snap.data() as TimezoneDoc;
  return {
    timezoneId: "UTC",
    offsetMinutes: 0,
    validatedAt: new Date().toISOString(),
    revision: 0,
  };
}

// ── getDailyState ─────────────────────────────────────────────────────────────

export const getDailyState = onCall(async (request) => {
  const uid = requireAuth(request);
  const now = Date.now();

  const [tzSnap, rewardSnap, streakSnap, challengeSnap] = await Promise.all([
    timezoneRef(uid).get(),
    rewardRef(uid).get(),
    streakRef(uid).get(),
    challengeStatusRef(uid).get(),
  ]);

  const tz: TimezoneDoc = tzSnap.exists
    ? (tzSnap.data() as TimezoneDoc)
    : { timezoneId: "UTC", offsetMinutes: 0, validatedAt: new Date().toISOString(), revision: 0 };

  const dayKey = utcToDayKey(now, tz.offsetMinutes);

  const reward: DailyRewardStateDoc = rewardSnap.exists
    ? (rewardSnap.data() as DailyRewardStateDoc)
    : { calendarDayIndex: 1, lastClaimedDayKey: null, lastClaimedAt: null, revision: 0 };

  const streak: StreakStateDoc = streakSnap.exists
    ? (streakSnap.data() as StreakStateDoc)
    : {
        currentStreakDays: 0,
        lastQualifiedDayKey: null,
        longestStreakDays: 0,
        claimedMilestones: [],
        streakCycleId: "init",
        revision: 0,
      };

  // Check if streak is broken (missed a day)
  const streakOut = computeStreakWithBrokenCheck(streak, dayKey);

  const challenge: DailyChallengeStateDoc = challengeSnap.exists
    ? (challengeSnap.data() as DailyChallengeStateDoc)
    : {
        currentDayKey: "",
        challengeId: "",
        completed: false,
        rewardGranted: false,
        completedAt: null,
        attemptCount: 0,
        revision: 0,
      };

  return {
    dayKey,
    serverNow: new Date(now).toISOString(),
    timezoneId: tz.timezoneId,
    schemaVersion: DailyConfig.dailyStateSchemaVersion,
    dailyRewardState: reward,
    streakState: streakOut,
    dailyChallengeState: challenge,
  };
});

// ── getDailyChallenge ─────────────────────────────────────────────────────────

export const getDailyChallenge = onCall(async (request) => {
  const uid = requireAuth(request);
  const tz = await loadTimezone(uid);
  const dayKey = utcToDayKey(Date.now(), tz.offsetMinutes);
  const snap = await challengeDefRef(dayKey).get();
  if (!snap.exists) return null;
  return snap.data();
});

// ── claimDailyReward ──────────────────────────────────────────────────────────

export const claimDailyReward = onCall(async (request) => {
  const uid = requireAuth(request);
  const tz = await loadTimezone(uid);
  const now = Date.now();
  const dayKey = utcToDayKey(now, tz.offsetMinutes);
  const idempotencyKey = `daily_reward:${uid}:${dayKey}`;

  const snap = await rewardRef(uid).get();
  const reward: DailyRewardStateDoc = snap.exists
    ? (snap.data() as DailyRewardStateDoc)
    : { calendarDayIndex: 1, lastClaimedDayKey: null, lastClaimedAt: null, revision: 0 };

  // Idempotent: already claimed today
  if (reward.lastClaimedDayKey === dayKey) {
    return { coinGrant: 0, hintGrant: 0, idempotent: true };
  }

  // Anti-abuse: minimum seconds between claims
  if (reward.lastClaimedAt) {
    const lastMs = new Date(reward.lastClaimedAt).getTime();
    const elapsedSec = (now - lastMs) / 1000;
    if (elapsedSec < DailyConfig.minSecondsBetweenClaims) {
      throw new HttpsError(
        "failed-precondition",
        `too_soon:${Math.round(DailyConfig.minSecondsBetweenClaims - elapsedSec)}`
      );
    }
  }

  const entry = rewardForDayIndex(reward.calendarDayIndex);
  const newDayIndex = nextDayIndex(reward.calendarDayIndex);

  // Grant coins/hints via idempotent wallet mutation
  if (entry.coins > 0 || entry.hints > 0) {
    const mutations = [];
    if (entry.coins > 0) {
      mutations.push({
        type: "dailyReward" as const,
        resource: "coins" as const,
        amount: entry.coins,
        referenceType: "daily_reward",
        referenceId: dayKey,
        idempotencyKey,
      });
    }
    if (entry.hints > 0) {
      mutations.push({
        type: "dailyReward" as const,
        resource: "hints" as const,
        amount: entry.hints,
        referenceType: "daily_reward",
        referenceId: dayKey,
        idempotencyKey: `${idempotencyKey}_hints`,
      });
    }
    await atomicWalletMutation(uid, idempotencyKey, "dailyReward", dayKey, mutations);
  }

  // Update reward state
  const updatedReward: DailyRewardStateDoc = {
    calendarDayIndex: newDayIndex,
    lastClaimedDayKey: dayKey,
    lastClaimedAt: new Date(now).toISOString(),
    revision: (reward.revision ?? 0) + 1,
  };
  await rewardRef(uid).set(updatedReward);

  // Mark streak activity
  await _updateStreak(uid, dayKey);

  return { coinGrant: entry.coins, hintGrant: entry.hints, idempotent: false };
});

// ── claimDailyChallengeReward ─────────────────────────────────────────────────

export const claimDailyChallengeReward = onCall(async (request) => {
  const uid = requireAuth(request);
  const { challengeId, dayKey } = request.data as {
    challengeId: string;
    dayKey: string;
  };
  if (!challengeId || !dayKey) {
    throw new HttpsError("invalid-argument", "challengeId and dayKey required");
  }

  const idempotencyKey = `challenge_reward:${uid}:${challengeId}`;

  const snap = await challengeStatusRef(uid).get();
  const status: DailyChallengeStateDoc = snap.exists
    ? (snap.data() as DailyChallengeStateDoc)
    : {
        currentDayKey: "",
        challengeId: "",
        completed: false,
        rewardGranted: false,
        completedAt: null,
        attemptCount: 0,
        revision: 0,
      };

  // Idempotent: already granted
  if (status.rewardGranted && status.challengeId === challengeId) {
    return { coinGrant: 0, idempotent: true };
  }

  if (!status.completed || status.challengeId !== challengeId) {
    throw new HttpsError(
      "failed-precondition",
      "challenge_not_completed"
    );
  }

  // Verify challenge definition exists for this dayKey
  const defSnap = await challengeDefRef(dayKey).get();
  if (!defSnap.exists) {
    throw new HttpsError("not-found", "challenge_def_not_found");
  }
  const def = defSnap.data()!;
  const reward = (def["rewardAmount"] as number) ?? DailyConfig.challengeReward;

  await atomicWalletMutation(uid, idempotencyKey, "dailyChallenge", dayKey, [
    {
      type: "dailyChallenge" as const,
      resource: "coins" as const,
      amount: reward,
      referenceType: "daily_challenge",
      referenceId: challengeId,
      idempotencyKey,
    },
  ]);

  await challengeStatusRef(uid).set(
    {
      rewardGranted: true,
      revision: FieldValue.increment(1),
    },
    { merge: true }
  );

  await _updateStreak(uid, dayKey);

  return { coinGrant: reward, idempotent: false };
});

// ── markDailyActivity ─────────────────────────────────────────────────────────

export const markDailyActivity = onCall(async (request) => {
  const uid = requireAuth(request);
  const tz = await loadTimezone(uid);
  const dayKey = utcToDayKey(Date.now(), tz.offsetMinutes);
  await _updateStreak(uid, dayKey);
  return { ok: true };
});

// ── updateTimezone ────────────────────────────────────────────────────────────

export const updateTimezone = onCall(async (request) => {
  const uid = requireAuth(request);
  const { timezoneId, offsetMinutes } = request.data as {
    timezoneId: string;
    offsetMinutes: number;
  };
  if (!timezoneId || offsetMinutes == null) {
    throw new HttpsError("invalid-argument", "timezoneId and offsetMinutes required");
  }

  const snap = await timezoneRef(uid).get();
  const current: Partial<TimezoneDoc> = snap.exists ? snap.data()! : {};
  const now = new Date().toISOString();

  // Enforce cooldown between timezone changes
  if (current.lastChangedAt) {
    const elapsedMinutes =
      (Date.now() - new Date(current.lastChangedAt).getTime()) / 60_000;
    if (
      current.timezoneId !== timezoneId &&
      elapsedMinutes < DailyConfig.timezoneChangeCooldownMinutes
    ) {
      throw new HttpsError(
        "resource-exhausted",
        `timezone_cooldown:${Math.round(DailyConfig.timezoneChangeCooldownMinutes - elapsedMinutes)}`
      );
    }
  }

  const updated: TimezoneDoc = {
    timezoneId,
    offsetMinutes,
    validatedAt: now,
    revision: ((current.revision ?? 0) + 1),
    previousTimezoneId: current.timezoneId,
    lastChangedAt:
      current.timezoneId !== timezoneId ? now : current.lastChangedAt,
  };
  await timezoneRef(uid).set(updated);
  return { ok: true };
});

// ── Internal: streak update ───────────────────────────────────────────────────

async function _updateStreak(uid: string, dayKey: string): Promise<void> {
  await db().runTransaction(async (tx) => {
    const ref = streakRef(uid);
    const snap = await tx.get(ref);
    const streak: StreakStateDoc = snap.exists
      ? (snap.data() as StreakStateDoc)
      : {
          currentStreakDays: 0,
          lastQualifiedDayKey: null,
          longestStreakDays: 0,
          claimedMilestones: [],
          streakCycleId: "init",
          revision: 0,
        };

    // Already recorded for this day
    if (streak.lastQualifiedDayKey === dayKey) return;

    const prevKey = streak.lastQualifiedDayKey;
    let newCurrent = 1;
    if (prevKey) {
      const prevMs = new Date(prevKey).getTime();
      const currMs = new Date(dayKey).getTime();
      const diffDays = Math.round((currMs - prevMs) / 86_400_000);
      if (diffDays === 1) {
        // Consecutive day
        newCurrent = streak.currentStreakDays + 1;
      }
      // diffDays === 0 handled above; diffDays > 1 → reset to 1
    }

    const newLongest = Math.max(streak.longestStreakDays, newCurrent);
    const updated: StreakStateDoc = {
      currentStreakDays: newCurrent,
      lastQualifiedDayKey: dayKey,
      longestStreakDays: newLongest,
      claimedMilestones: streak.claimedMilestones,
      streakCycleId: streak.streakCycleId,
      revision: (streak.revision ?? 0) + 1,
    };
    tx.set(ref, updated);
  });
}

/** Checks if streak was broken since last qualified day. Pure read, no write. */
function computeStreakWithBrokenCheck(
  streak: StreakStateDoc,
  todayKey: string
): StreakStateDoc {
  if (!streak.lastQualifiedDayKey) return streak;
  const prevMs = new Date(streak.lastQualifiedDayKey).getTime();
  const todayMs = new Date(todayKey).getTime();
  const diffDays = Math.round((todayMs - prevMs) / 86_400_000);
  if (diffDays <= 1) return streak;
  // Streak broken — return zeroed streak (lazy reset; written on next activity)
  return {
    ...streak,
    currentStreakDays: 0,
  };
}
