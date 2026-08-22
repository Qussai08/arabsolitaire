import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/storage/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

final appDatabaseProvider = FutureProvider<AppDatabase>((ref) async {
  final database = AppDatabase(openConnection());
  ref.onDispose(database.close);
  return database;
});

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'solitaire_al_arab.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

/// In-memory database for widget/unit tests.
AppDatabase openTestDatabase() {
  return AppDatabase(NativeDatabase.memory());
}
