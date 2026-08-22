import 'package:drift/drift.dart';

part 'app_database.g.dart';

/// Local SQLite database. Schema v2 adds active attempt persistence.
@DriftDatabase(tables: [AppMetadata, SchemaMetadata, ActiveAttempts])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 2;

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
