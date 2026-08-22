import { initializeApp } from "firebase-admin/app";
import {
  initializeWallet,
  grantLevelReward,
  grantChapterReward,
  purchaseHint,
  consumeHint,
  purchaseExtraMoves,
  purchaseDeadEndRescue,
  getWalletSnapshot,
} from "./economy/economy_functions";
import {
  validateAndGrantPurchase,
  restoreEntitlements,
} from "./monetization/purchase_functions";
import {
  getDailyState,
  getDailyChallenge,
  claimDailyReward,
  claimDailyChallengeReward,
  markDailyActivity,
  updateTimezone,
} from "./daily/daily_functions";
import {
  registerDeviceToken,
  updateNotificationPreferences,
} from "./notifications/notification_functions";
import { publishToStaging } from "./content/publish_staging";
import { promoteToProduction } from "./content/promote_production";
import { rollbackProduction } from "./content/rollback_production";
import {
  disableContent,
  enableContent,
  getAuditLogEntries,
} from "./content/disable_content";

initializeApp();

export {
  // Economy (Sprint 7)
  initializeWallet,
  grantLevelReward,
  grantChapterReward,
  purchaseHint,
  consumeHint,
  purchaseExtraMoves,
  purchaseDeadEndRescue,
  getWalletSnapshot,
  // Monetization (Sprint 8)
  validateAndGrantPurchase,
  restoreEntitlements,
  // Daily & Notifications (Sprint 9)
  getDailyState,
  getDailyChallenge,
  claimDailyReward,
  claimDailyChallengeReward,
  markDailyActivity,
  updateTimezone,
  registerDeviceToken,
  updateNotificationPreferences,
  // Content Publishing (Sprint 10)
  publishToStaging,
  promoteToProduction,
  rollbackProduction,
  disableContent,
  enableContent,
  getAuditLogEntries,
};
