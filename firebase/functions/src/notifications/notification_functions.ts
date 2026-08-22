// Sprint 9 — FCM device registration and notification preference functions.

import { onCall, HttpsError, CallableRequest } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";

// ── Auth helper ───────────────────────────────────────────────────────────────

function requireAuth(request: CallableRequest): string {
  if (!request.auth) throw new HttpsError("unauthenticated", "Auth required");
  return request.auth.uid;
}

const db = () => getFirestore();

// ── Types ─────────────────────────────────────────────────────────────────────

type DeviceDoc = {
  fcmToken: string;
  platform: string;
  timezoneId: string;
  notificationsEnabled: boolean;
  appVersion: string;
  registeredAt: string;
  updatedAt: string;
};

type NotificationPrefsDoc = {
  dailyChallengeEnabled: boolean;
  streakRiskEnabled: boolean;
  updatedAt: string;
  revision: number;
};

// ── registerDeviceToken ───────────────────────────────────────────────────────

export const registerDeviceToken = onCall(async (request) => {
  const uid = requireAuth(request);
  const {
    fcmToken,
    platform,
    timezoneId,
    notificationsEnabled,
    appVersion,
  } = request.data as {
    fcmToken: string;
    platform: string;
    timezoneId: string;
    notificationsEnabled: boolean;
    appVersion: string;
  };

  if (!fcmToken || !platform) {
    throw new HttpsError("invalid-argument", "fcmToken and platform required");
  }

  const now = new Date().toISOString();
  // Use hashed token as document ID to deduplicate per-token registrations.
  const tokenHash = Buffer.from(fcmToken).toString("base64").slice(0, 40);

  const deviceRef = db()
    .collection("players")
    .doc(uid)
    .collection("devices")
    .doc(tokenHash);

  const existing = await deviceRef.get();
  const doc: DeviceDoc = {
    fcmToken,
    platform,
    timezoneId: timezoneId ?? "UTC",
    notificationsEnabled: notificationsEnabled ?? true,
    appVersion: appVersion ?? "",
    registeredAt: existing.exists
      ? (existing.data() as DeviceDoc).registeredAt
      : now,
    updatedAt: now,
  };
  await deviceRef.set(doc);
  return { ok: true };
});

// ── updateNotificationPreferences ─────────────────────────────────────────────

export const updateNotificationPreferences = onCall(async (request) => {
  const uid = requireAuth(request);
  const { dailyChallengeNotificationsEnabled, streakRiskNotificationsEnabled } =
    request.data as {
      dailyChallengeNotificationsEnabled: boolean;
      streakRiskNotificationsEnabled: boolean;
    };

  const prefsRef = db()
    .collection("players")
    .doc(uid)
    .collection("daily")
    .doc("notificationPrefs");

  const update: Partial<NotificationPrefsDoc> = {
    updatedAt: new Date().toISOString(),
    revision: FieldValue.increment(1) as unknown as number,
  };
  if (dailyChallengeNotificationsEnabled != null) {
    update.dailyChallengeEnabled = dailyChallengeNotificationsEnabled;
  }
  if (streakRiskNotificationsEnabled != null) {
    update.streakRiskEnabled = streakRiskNotificationsEnabled;
  }
  await prefsRef.set(update, { merge: true });
  return { ok: true };
});
