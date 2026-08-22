/// Local defaults for Remote Config — never block launch on fetch failure.
///
/// All keys must have a safe default that keeps the app functional offline.
/// Kill switches default to enabled (true) so the app works without network.
abstract final class FeatureFlagDefaults {
  static const Map<String, Object> values = {
    // ── System flags ────────────────────────────────────────────────────────
    'bootstrap_banner_enabled': false,
    'maintenance_mode': false,

    // ── Kill switches (true = feature active) ────────────────────────────────
    // Disable via Remote Config in production emergencies.
    'rewarded_ads_enabled': true,
    'interstitial_enabled': true,
    'shop_enabled': true,
    'daily_enabled': true,
    'daily_challenge_enabled': true,
    'remote_content_updates_enabled': true,

    // ── Monetization tuning ──────────────────────────────────────────────────
    // Interstitial cadence: show after every N completed levels (baseline 3–5).
    'interstitial_every_n_levels': 3,
    // Max interstitials per session.
    'interstitial_session_cap': 3,
    // Rewarded Coin grant cap per day.
    'rewarded_coin_daily_cap': 3,
  };

  // ── Typed accessors for kill switches ─────────────────────────────────────

  static const String rewardedAdsEnabled = 'rewarded_ads_enabled';
  static const String interstitialEnabled = 'interstitial_enabled';
  static const String shopEnabled = 'shop_enabled';
  static const String dailyEnabled = 'daily_enabled';
  static const String dailyChallengeEnabled = 'daily_challenge_enabled';
  static const String remoteContentUpdatesEnabled =
      'remote_content_updates_enabled';
  static const String interstitialEveryNLevels = 'interstitial_every_n_levels';
  static const String interstitialSessionCap = 'interstitial_session_cap';
  static const String rewardedCoinDailyCap = 'rewarded_coin_daily_cap';
}
