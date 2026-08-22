import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/storage/database_provider.dart';

void main() {
  test('Drift schema opens and metadata round-trips without wipe', () async {
    final db = openTestDatabase();
    addTearDown(db.close);

    await db.ensureInitialized();

    final versions = await db.select(db.schemaMetadata).get();
    expect(versions, isNotEmpty);
    expect(versions.first.schemaVersion, 1);

    await db.upsertMetadata('sprint', '0');
    expect(await db.readMetadata('sprint'), '0');

    await db.upsertMetadata('sprint', '0-updated');
    expect(await db.readMetadata('sprint'), '0-updated');

    // Re-open same connection path is in-memory; verify migration does not wipe
    // by ensuring schema metadata still present after ensureInitialized again.
    await db.ensureInitialized();
    final after = await db.select(db.schemaMetadata).get();
    expect(after, isNotEmpty);
    expect(await db.readMetadata('sprint'), '0-updated');
  });
}
