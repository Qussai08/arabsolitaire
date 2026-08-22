import 'package:drift/drift.dart';

part 'app_database.g.dart';

/// Local SQLite database. Schema v8 adds ContentMetadataRows for Sprint 10.
@DriftDatabase(
  tables: [
    AppMetadata,
    SchemaMetadata,
    ActiveAttempts,
    JourneyProgressRows,
    PlayerFlagRows,
    PlayerIdentityRows,
    SyncMetadataRows,
    SyncOperationRows,
    WalletCacheRows,
    EconomyOperationRows,
    EntitlementRows,
    MonetizationStateRows,
    RewardedAdReceiptRows,
    DailyStateCacheRows,
    DailyChallengeCacheRows,
    NotificationPreferenceRows,
    DeviceRegistrationRows,
    ContentMetadataRows,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await into(schemaMetadata).insert(
        SchemaMetadataCompanion.insert(
          schemaVersion: schemaVersion,
          notes: const Value('initial schema'),
        ),
      );
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(activeAttempts);
      }
      if (from < 3) {
        await m.createTable(journeyProgressRows);
        await m.createTable(playerFlagRows);
      }
      if (from < 4) {
        await m.createTable(playerIdentityRows);
        await m.createTable(syncMetadataRows);
        await m.createTable(syncOperationRows);
      }
      if (from < 5) {
        await m.createTable(walletCacheRows);
        await m.createTable(economyOperationRows);
      }
      if (from < 6) {
        await m.createTable(entitlementRows);
        await m.createTable(monetizationStateRows);
        await m.createTable(rewardedAdReceiptRows);
      }
      if (from < 7) {
        await m.createTable(dailyStateCacheRows);
        await m.createTable(dailyChallengeCacheRows);
        await m.createTable(notificationPreferenceRows);
        await m.createTable(deviceRegistrationRows);
      }
      if (from < 8) {
        await m.createTable(contentMetadataRows);
      }
    },
  );

  Future<void> ensureInitialized() async {
    // Touch the DB so opening/migration runs.
    await select(schemaMetadata).get();
  }

  Future<void> upsertMetadata(String key, String value) {
    return into(appMetadata).insertOnConflictUpdate(
      AppMetadataCompanion.insert(
        key: key,
        value: value,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
  }

  Future<String?> readMetadata(String key) async {
    final row = await (select(
      appMetadata,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }
}

class AppMetadata extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

class SchemaMetadata extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get schemaVersion => integer()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get migratedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Single-row active attempt. Primary key is always 'active'.
class ActiveAttempts extends Table {
  TextColumn get id => text()(); // always 'active'
  TextColumn get levelDefinitionId => text()();
  TextColumn get attemptId => text()();
  IntColumn get seed => integer()();
  TextColumn get gameStateJson => text()();
  TextColumn get rulesVersion => text()();
  IntColumn get saveSchemaVersion => integer()();
  TextColumn get generatorVersion =>
      text().withDefault(const Constant(''))();
  IntColumn get revision =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get savedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Serialised journey progress — single row (id='main').
class JourneyProgressRows extends Table {
  TextColumn get id => text()();
  IntColumn get highestUnlockedLevel =>
      integer().withDefault(const Constant(1))();
  IntColumn get highestCompletedLevel =>
      integer().withDefault(const Constant(0))();
  TextColumn get currentLevelId => text().nullable()();
  TextColumn get completedLevelIdsJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get completedChapterIdsJson =>
      text().withDefault(const Constant('[]'))();
  IntColumn get progressionSchemaVersion =>
      integer().withDefault(const Constant(1))();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Serialised player flags — single row (id='main').
class PlayerFlagRows extends Table {
  TextColumn get id => text()();
  BoolColumn get isFirstLaunch =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get onboardingCompleted =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get tutorialCompleted =>
      boolean().withDefault(const Constant(false))();
  TextColumn get unlockedStoryBeatIdsJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get viewedStoryBeatIdsJson =>
      text().withDefault(const Constant('[]'))();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Local player identity — single row (id='main').
class PlayerIdentityRows extends Table {
  TextColumn get id => text()();
  TextColumn get localPlayerId => text()();
  TextColumn get firebaseUid => text().nullable()();
  TextColumn get identityState =>
      text().withDefault(const Constant('offlineLocalOnly'))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  IntColumn get cloudMigrationVersion =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get cloudMigrationCompletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Sync metadata — single row (id='main').
class SyncMetadataRows extends Table {
  TextColumn get id => text()();
  DateTimeColumn get lastSuccessfulSyncAt => dateTime().nullable()();
  IntColumn get lastCloudRevision =>
      integer().withDefault(const Constant(0))();
  IntColumn get pendingOperationsCount =>
      integer().withDefault(const Constant(0))();
  TextColumn get lastSyncErrorCode => text().nullable()();
  TextColumn get identityUid => text().nullable()();
  IntColumn get syncSchemaVersion =>
      integer().withDefault(const Constant(1))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Durable idempotent sync queue.
class SyncOperationRows extends Table {
  TextColumn get operationId => text()();
  TextColumn get operationType => text()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  TextColumn get idempotencyKey => text()();
  IntColumn get attemptCount =>
      integer().withDefault(const Constant(0))();
  TextColumn get status =>
      text().withDefault(const Constant('pending'))();
  DateTimeColumn get nextRetryAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {operationId};
}

/// Locally reconciled wallet cache — single row (id='main').
class WalletCacheRows extends Table {
  TextColumn get id => text()();
  TextColumn get firebaseUid => text().nullable()();
  IntColumn get coinBalance =>
      integer().withDefault(const Constant(0))();
  IntColumn get hintBalance =>
      integer().withDefault(const Constant(0))();
  IntColumn get pendingCoinDelta =>
      integer().withDefault(const Constant(0))();
  IntColumn get pendingHintDelta =>
      integer().withDefault(const Constant(0))();
  IntColumn get walletRevision =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get lastReconciledAt => dateTime().nullable()();
  BoolColumn get isStale =>
      boolean().withDefault(const Constant(true))();
  IntColumn get walletSchemaVersion =>
      integer().withDefault(const Constant(1))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Local pending economy operations (offline spend + reward claims).
class EconomyOperationRows extends Table {
  TextColumn get operationId => text()();
  TextColumn get operationType => text()();
  TextColumn get idempotencyKey => text()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  IntColumn get coinDelta => integer().withDefault(const Constant(0))();
  IntColumn get hintDelta => integer().withDefault(const Constant(0))();
  TextColumn get status =>
      text().withDefault(const Constant('pending'))();
  IntColumn get attemptCount =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get nextRetryAt => dateTime().nullable()();
  TextColumn get serverTransactionId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {operationId};
}

/// Entitlements (e.g. Remove Ads) — keyed by entitlement type string.
class EntitlementRows extends Table {
  TextColumn get entitlementType => text()();
  BoolColumn get active =>
      boolean().withDefault(const Constant(false))();
  TextColumn get source =>
      text().withDefault(const Constant('none'))();
  TextColumn get storeProductId => text().nullable()();
  TextColumn get purchaseId => text().nullable()();
  DateTimeColumn get validatedAt => dateTime().nullable()();
  IntColumn get revision =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {entitlementType};
}

/// Per-session + persistent monetization policy state.
class MonetizationStateRows extends Table {
  TextColumn get id => text()();
  IntColumn get levelsSinceLastInterstitial =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get lastRewardedAdAt => dateTime().nullable()();
  DateTimeColumn get lastPurchaseAt => dateTime().nullable()();
  DateTimeColumn get lastTutorialCompletedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Daily state cache — one row (id = 'main').
class DailyStateCacheRows extends Table {
  TextColumn get id => text()();
  TextColumn get dayKey => text()();
  TextColumn get timezoneId => text().withDefault(const Constant('UTC'))();
  IntColumn get timezoneOffsetMinutes =>
      integer().withDefault(const Constant(0))();
  IntColumn get rewardCalendarDayIndex =>
      integer().withDefault(const Constant(1))();
  TextColumn get rewardLastClaimedDayKey => text().nullable()();
  DateTimeColumn get rewardLastClaimedAt => dateTime().nullable()();
  IntColumn get rewardRevision =>
      integer().withDefault(const Constant(0))();
  IntColumn get streakCurrentDays =>
      integer().withDefault(const Constant(0))();
  TextColumn get streakLastQualifiedDayKey => text().nullable()();
  IntColumn get streakLongestDays =>
      integer().withDefault(const Constant(0))();
  TextColumn get streakClaimedMilestonesJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get streakCycleId =>
      text().withDefault(const Constant('init'))();
  IntColumn get streakRevision =>
      integer().withDefault(const Constant(0))();
  TextColumn get challengeCurrentDayKey => text().nullable()();
  TextColumn get challengeId => text().nullable()();
  BoolColumn get challengeCompleted =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get challengeRewardGranted =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get challengeCompletedAt => dateTime().nullable()();
  IntColumn get challengeAttemptCount =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get fetchedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Cached daily challenge definition.
class DailyChallengeCacheRows extends Table {
  TextColumn get challengeId => text()();
  TextColumn get dayKey => text()();
  TextColumn get cohortKey => text()();
  IntColumn get seed => integer()();
  IntColumn get rewardAmount => integer()();
  DateTimeColumn get activeFrom => dateTime()();
  DateTimeColumn get activeUntil => dateTime()();
  IntColumn get rulesVersion => integer()();
  IntColumn get generatorVersion => integer()();
  IntColumn get solverVersion => integer()();
  TextColumn get contentBundleVersion => text().nullable()();
  TextColumn get boardFingerprint => text().nullable()();
  DateTimeColumn get cachedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {challengeId};
}

/// Player notification preferences.
class NotificationPreferenceRows extends Table {
  TextColumn get id => text()();
  BoolColumn get dailyChallengeEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get streakRiskEnabled =>
      boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// FCM device registration.
class DeviceRegistrationRows extends Table {
  TextColumn get deviceId => text()();
  TextColumn get fcmToken => text()();
  TextColumn get platform => text()();
  TextColumn get timezoneId =>
      text().withDefault(const Constant('UTC'))();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();
  TextColumn get appVersion => text().nullable()();
  DateTimeColumn get registeredAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastSeenAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {deviceId};
}

/// Rewarded ad pending receipts for crash recovery.
class RewardedAdReceiptRows extends Table {
  TextColumn get operationId => text()();
  TextColumn get rewardType => text()();
  BoolColumn get adCompleted =>
      boolean().withDefault(const Constant(false))();
  TextColumn get attemptId => text().nullable()();
  BoolColumn get backendGranted =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get localEffectApplied =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {operationId};
}

/// Sprint 10 — Local content bundle metadata (active/previous version tracking).
class ContentMetadataRows extends Table {
  /// Always a single row with id = 'main'.
  TextColumn get id => text()();
  TextColumn get activeBundleVersion => text().nullable()();
  TextColumn get previousBundleVersion => text().nullable()();
  TextColumn get activeContentHash => text().nullable()();
  TextColumn get quarantinedVersionsJson =>
      text().withDefault(const Constant('[]'))();
  DateTimeColumn get lastUpdateCheckAt => dateTime().nullable()();
  DateTimeColumn get lastSuccessfulActivationAt => dateTime().nullable()();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
