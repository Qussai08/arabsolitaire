import 'package:drift/drift.dart';

part 'app_database.g.dart';

/// Local SQLite database skeleton (Sprint 0).
///
/// Full gameplay schema arrives with later sprints / Data Model work.
@DriftDatabase(tables: [AppMetadata, SchemaMetadata])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// Explicit schema version — bump only with tested migrations.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await into(schemaMetadata).insert(
        SchemaMetadataCompanion.insert(
          schemaVersion: schemaVersion,
          notes: const Value('initial sprint-0 schema'),
        ),
      );
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Production must never wipe data as a migration fallback.
      // Add explicit step-by-step migrations when schemaVersion increases.
      if (from < to) {
        // No upgrades defined for schemaVersion 1.
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
