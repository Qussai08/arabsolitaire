/// Notification infrastructure domain models.
library;

import 'package:mobile/features/daily/domain/daily_models.dart';

export 'package:mobile/features/daily/domain/daily_models.dart'
    show NotificationPreferences, QuietHoursPolicy;

// ── Device registration ───────────────────────────────────────────────────────

final class DeviceRegistrationInfo {
  const DeviceRegistrationInfo({
    required this.deviceId,
    required this.fcmToken,
    required this.platform,
    required this.timezoneId,
    this.notificationsEnabled = true,
    this.appVersion,
  });

  final String deviceId;
  final String fcmToken;
  final String platform;
  final String timezoneId;
  final bool notificationsEnabled;
  final String? appVersion;
}

// ── Notification type ─────────────────────────────────────────────────────────

enum NotificationType {
  dailyChallenge,
  streakRisk,
}

// ── Notification schedule check ───────────────────────────────────────────────

final class NotificationEligibility {
  const NotificationEligibility({
    required this.type,
    required this.eligible,
    this.reason,
    this.scheduledFor,
  });

  final NotificationType type;
  final bool eligible;
  final String? reason;
  final DateTime? scheduledFor;
}

// ── Quiet hours evaluation ────────────────────────────────────────────────────

abstract final class NotificationScheduler {
  /// Determine the best send time outside quiet hours.
  /// Returns null if no valid window found for the day.
  static DateTime? nextValidSendTime({
    required DateTime preferredTime,
    required String timezoneId,
  }) {
    if (!QuietHoursPolicy.isInQuietHours(preferredTime)) {
      return preferredTime;
    }
    // Find next 09:00 local in the same day or next.
    final afterQuiet = DateTime(
      preferredTime.year,
      preferredTime.month,
      preferredTime.day,
      DailyConfig.quietHoursEndHour,
    );
    if (afterQuiet.isAfter(preferredTime)) return afterQuiet;
    // If it's already past 22:00 and next window is next day 09:00.
    return afterQuiet.add(const Duration(days: 1));
  }

  static NotificationEligibility evaluateDailyChallenge({
    required DailyStateSnapshot snapshot,
    required NotificationPreferences prefs,
    required DateTime now,
  }) {
    if (!prefs.dailyChallengeEnabled) {
      return const NotificationEligibility(
        type: NotificationType.dailyChallenge,
        eligible: false,
        reason: 'preference_disabled',
      );
    }
    if (snapshot.challengeState.completed) {
      return const NotificationEligibility(
        type: NotificationType.dailyChallenge,
        eligible: false,
        reason: 'already_completed',
      );
    }
    return NotificationEligibility(
      type: NotificationType.dailyChallenge,
      eligible: true,
      scheduledFor: nextValidSendTime(
        preferredTime: now,
        timezoneId: snapshot.timezoneId,
      ),
    );
  }

  static NotificationEligibility evaluateStreakRisk({
    required DailyStateSnapshot snapshot,
    required NotificationPreferences prefs,
    required DateTime now,
  }) {
    if (!prefs.streakRiskEnabled) {
      return const NotificationEligibility(
        type: NotificationType.streakRisk,
        eligible: false,
        reason: 'preference_disabled',
      );
    }
    final streak = snapshot.streakState;
    if (streak.currentStreakDays == 0) {
      return const NotificationEligibility(
        type: NotificationType.streakRisk,
        eligible: false,
        reason: 'no_active_streak',
      );
    }
    final qualifiedToday =
        streak.lastQualifiedDayKey == snapshot.dayKey;
    if (qualifiedToday) {
      return const NotificationEligibility(
        type: NotificationType.streakRisk,
        eligible: false,
        reason: 'already_qualified_today',
      );
    }
    return NotificationEligibility(
      type: NotificationType.streakRisk,
      eligible: true,
      scheduledFor: nextValidSendTime(
        preferredTime: now,
        timezoneId: snapshot.timezoneId,
      ),
    );
  }
}
