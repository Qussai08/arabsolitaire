// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppMetadataTable extends AppMetadata
    with TableInfo<$AppMetadataTable, AppMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppMetadataData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppMetadataTable createAlias(String alias) {
    return $AppMetadataTable(attachedDatabase, alias);
  }
}

class AppMetadataData extends DataClass implements Insertable<AppMetadataData> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const AppMetadataData({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppMetadataCompanion toCompanion(bool nullToAbsent) {
    return AppMetadataCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppMetadataData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppMetadataData copyWith({String? key, String? value, DateTime? updatedAt}) =>
      AppMetadataData(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppMetadataData copyWithCompanion(AppMetadataCompanion data) {
    return AppMetadataData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppMetadataData(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppMetadataData &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppMetadataCompanion extends UpdateCompanion<AppMetadataData> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppMetadataCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppMetadataCompanion.insert({
    required String key,
    required String value,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<AppMetadataData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppMetadataCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppMetadataCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppMetadataCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SchemaMetadataTable extends SchemaMetadata
    with TableInfo<$SchemaMetadataTable, SchemaMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchemaMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _schemaVersionMeta = const VerificationMeta(
    'schemaVersion',
  );
  @override
  late final GeneratedColumn<int> schemaVersion = GeneratedColumn<int>(
    'schema_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _migratedAtMeta = const VerificationMeta(
    'migratedAt',
  );
  @override
  late final GeneratedColumn<DateTime> migratedAt = GeneratedColumn<DateTime>(
    'migrated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, schemaVersion, notes, migratedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schema_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<SchemaMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('schema_version')) {
      context.handle(
        _schemaVersionMeta,
        schemaVersion.isAcceptableOrUnknown(
          data['schema_version']!,
          _schemaVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_schemaVersionMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('migrated_at')) {
      context.handle(
        _migratedAtMeta,
        migratedAt.isAcceptableOrUnknown(data['migrated_at']!, _migratedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SchemaMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SchemaMetadataData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      schemaVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schema_version'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      migratedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}migrated_at'],
      )!,
    );
  }

  @override
  $SchemaMetadataTable createAlias(String alias) {
    return $SchemaMetadataTable(attachedDatabase, alias);
  }
}

class SchemaMetadataData extends DataClass
    implements Insertable<SchemaMetadataData> {
  final int id;
  final int schemaVersion;
  final String notes;
  final DateTime migratedAt;
  const SchemaMetadataData({
    required this.id,
    required this.schemaVersion,
    required this.notes,
    required this.migratedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['schema_version'] = Variable<int>(schemaVersion);
    map['notes'] = Variable<String>(notes);
    map['migrated_at'] = Variable<DateTime>(migratedAt);
    return map;
  }

  SchemaMetadataCompanion toCompanion(bool nullToAbsent) {
    return SchemaMetadataCompanion(
      id: Value(id),
      schemaVersion: Value(schemaVersion),
      notes: Value(notes),
      migratedAt: Value(migratedAt),
    );
  }

  factory SchemaMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SchemaMetadataData(
      id: serializer.fromJson<int>(json['id']),
      schemaVersion: serializer.fromJson<int>(json['schemaVersion']),
      notes: serializer.fromJson<String>(json['notes']),
      migratedAt: serializer.fromJson<DateTime>(json['migratedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'schemaVersion': serializer.toJson<int>(schemaVersion),
      'notes': serializer.toJson<String>(notes),
      'migratedAt': serializer.toJson<DateTime>(migratedAt),
    };
  }

  SchemaMetadataData copyWith({
    int? id,
    int? schemaVersion,
    String? notes,
    DateTime? migratedAt,
  }) => SchemaMetadataData(
    id: id ?? this.id,
    schemaVersion: schemaVersion ?? this.schemaVersion,
    notes: notes ?? this.notes,
    migratedAt: migratedAt ?? this.migratedAt,
  );
  SchemaMetadataData copyWithCompanion(SchemaMetadataCompanion data) {
    return SchemaMetadataData(
      id: data.id.present ? data.id.value : this.id,
      schemaVersion: data.schemaVersion.present
          ? data.schemaVersion.value
          : this.schemaVersion,
      notes: data.notes.present ? data.notes.value : this.notes,
      migratedAt: data.migratedAt.present
          ? data.migratedAt.value
          : this.migratedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SchemaMetadataData(')
          ..write('id: $id, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('notes: $notes, ')
          ..write('migratedAt: $migratedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, schemaVersion, notes, migratedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SchemaMetadataData &&
          other.id == this.id &&
          other.schemaVersion == this.schemaVersion &&
          other.notes == this.notes &&
          other.migratedAt == this.migratedAt);
}

class SchemaMetadataCompanion extends UpdateCompanion<SchemaMetadataData> {
  final Value<int> id;
  final Value<int> schemaVersion;
  final Value<String> notes;
  final Value<DateTime> migratedAt;
  const SchemaMetadataCompanion({
    this.id = const Value.absent(),
    this.schemaVersion = const Value.absent(),
    this.notes = const Value.absent(),
    this.migratedAt = const Value.absent(),
  });
  SchemaMetadataCompanion.insert({
    this.id = const Value.absent(),
    required int schemaVersion,
    this.notes = const Value.absent(),
    this.migratedAt = const Value.absent(),
  }) : schemaVersion = Value(schemaVersion);
  static Insertable<SchemaMetadataData> custom({
    Expression<int>? id,
    Expression<int>? schemaVersion,
    Expression<String>? notes,
    Expression<DateTime>? migratedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (schemaVersion != null) 'schema_version': schemaVersion,
      if (notes != null) 'notes': notes,
      if (migratedAt != null) 'migrated_at': migratedAt,
    });
  }

  SchemaMetadataCompanion copyWith({
    Value<int>? id,
    Value<int>? schemaVersion,
    Value<String>? notes,
    Value<DateTime>? migratedAt,
  }) {
    return SchemaMetadataCompanion(
      id: id ?? this.id,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      notes: notes ?? this.notes,
      migratedAt: migratedAt ?? this.migratedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (schemaVersion.present) {
      map['schema_version'] = Variable<int>(schemaVersion.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (migratedAt.present) {
      map['migrated_at'] = Variable<DateTime>(migratedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchemaMetadataCompanion(')
          ..write('id: $id, ')
          ..write('schemaVersion: $schemaVersion, ')
          ..write('notes: $notes, ')
          ..write('migratedAt: $migratedAt')
          ..write(')'))
        .toString();
  }
}

class $ActiveAttemptsTable extends ActiveAttempts
    with TableInfo<$ActiveAttemptsTable, ActiveAttempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActiveAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelDefinitionIdMeta = const VerificationMeta(
    'levelDefinitionId',
  );
  @override
  late final GeneratedColumn<String> levelDefinitionId =
      GeneratedColumn<String>(
        'level_definition_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _attemptIdMeta = const VerificationMeta(
    'attemptId',
  );
  @override
  late final GeneratedColumn<String> attemptId = GeneratedColumn<String>(
    'attempt_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seedMeta = const VerificationMeta('seed');
  @override
  late final GeneratedColumn<int> seed = GeneratedColumn<int>(
    'seed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gameStateJsonMeta = const VerificationMeta(
    'gameStateJson',
  );
  @override
  late final GeneratedColumn<String> gameStateJson = GeneratedColumn<String>(
    'game_state_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rulesVersionMeta = const VerificationMeta(
    'rulesVersion',
  );
  @override
  late final GeneratedColumn<String> rulesVersion = GeneratedColumn<String>(
    'rules_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saveSchemaVersionMeta = const VerificationMeta(
    'saveSchemaVersion',
  );
  @override
  late final GeneratedColumn<int> saveSchemaVersion = GeneratedColumn<int>(
    'save_schema_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _generatorVersionMeta = const VerificationMeta(
    'generatorVersion',
  );
  @override
  late final GeneratedColumn<String> generatorVersion = GeneratedColumn<String>(
    'generator_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta(
    'revision',
  );
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _savedAtMeta = const VerificationMeta(
    'savedAt',
  );
  @override
  late final GeneratedColumn<DateTime> savedAt = GeneratedColumn<DateTime>(
    'saved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    levelDefinitionId,
    attemptId,
    seed,
    gameStateJson,
    rulesVersion,
    saveSchemaVersion,
    generatorVersion,
    revision,
    savedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActiveAttempt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('level_definition_id')) {
      context.handle(
        _levelDefinitionIdMeta,
        levelDefinitionId.isAcceptableOrUnknown(
          data['level_definition_id']!,
          _levelDefinitionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_levelDefinitionIdMeta);
    }
    if (data.containsKey('attempt_id')) {
      context.handle(
        _attemptIdMeta,
        attemptId.isAcceptableOrUnknown(data['attempt_id']!, _attemptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_attemptIdMeta);
    }
    if (data.containsKey('seed')) {
      context.handle(
        _seedMeta,
        seed.isAcceptableOrUnknown(data['seed']!, _seedMeta),
      );
    } else if (isInserting) {
      context.missing(_seedMeta);
    }
    if (data.containsKey('game_state_json')) {
      context.handle(
        _gameStateJsonMeta,
        gameStateJson.isAcceptableOrUnknown(
          data['game_state_json']!,
          _gameStateJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gameStateJsonMeta);
    }
    if (data.containsKey('rules_version')) {
      context.handle(
        _rulesVersionMeta,
        rulesVersion.isAcceptableOrUnknown(
          data['rules_version']!,
          _rulesVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rulesVersionMeta);
    }
    if (data.containsKey('save_schema_version')) {
      context.handle(
        _saveSchemaVersionMeta,
        saveSchemaVersion.isAcceptableOrUnknown(
          data['save_schema_version']!,
          _saveSchemaVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_saveSchemaVersionMeta);
    }
    if (data.containsKey('generator_version')) {
      context.handle(
        _generatorVersionMeta,
        generatorVersion.isAcceptableOrUnknown(
          data['generator_version']!,
          _generatorVersionMeta,
        ),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('saved_at')) {
      context.handle(
        _savedAtMeta,
        savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActiveAttempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActiveAttempt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      levelDefinitionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level_definition_id'],
      )!,
      attemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attempt_id'],
      )!,
      seed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seed'],
      )!,
      gameStateJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_state_json'],
      )!,
      rulesVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rules_version'],
      )!,
      saveSchemaVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}save_schema_version'],
      )!,
      generatorVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}generator_version'],
      )!,
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      savedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}saved_at'],
      )!,
    );
  }

  @override
  $ActiveAttemptsTable createAlias(String alias) {
    return $ActiveAttemptsTable(attachedDatabase, alias);
  }
}

class ActiveAttempt extends DataClass implements Insertable<ActiveAttempt> {
  final String id;
  final String levelDefinitionId;
  final String attemptId;
  final int seed;
  final String gameStateJson;
  final String rulesVersion;
  final int saveSchemaVersion;
  final String generatorVersion;
  final int revision;
  final DateTime savedAt;
  const ActiveAttempt({
    required this.id,
    required this.levelDefinitionId,
    required this.attemptId,
    required this.seed,
    required this.gameStateJson,
    required this.rulesVersion,
    required this.saveSchemaVersion,
    required this.generatorVersion,
    required this.revision,
    required this.savedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['level_definition_id'] = Variable<String>(levelDefinitionId);
    map['attempt_id'] = Variable<String>(attemptId);
    map['seed'] = Variable<int>(seed);
    map['game_state_json'] = Variable<String>(gameStateJson);
    map['rules_version'] = Variable<String>(rulesVersion);
    map['save_schema_version'] = Variable<int>(saveSchemaVersion);
    map['generator_version'] = Variable<String>(generatorVersion);
    map['revision'] = Variable<int>(revision);
    map['saved_at'] = Variable<DateTime>(savedAt);
    return map;
  }

  ActiveAttemptsCompanion toCompanion(bool nullToAbsent) {
    return ActiveAttemptsCompanion(
      id: Value(id),
      levelDefinitionId: Value(levelDefinitionId),
      attemptId: Value(attemptId),
      seed: Value(seed),
      gameStateJson: Value(gameStateJson),
      rulesVersion: Value(rulesVersion),
      saveSchemaVersion: Value(saveSchemaVersion),
      generatorVersion: Value(generatorVersion),
      revision: Value(revision),
      savedAt: Value(savedAt),
    );
  }

  factory ActiveAttempt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActiveAttempt(
      id: serializer.fromJson<String>(json['id']),
      levelDefinitionId: serializer.fromJson<String>(json['levelDefinitionId']),
      attemptId: serializer.fromJson<String>(json['attemptId']),
      seed: serializer.fromJson<int>(json['seed']),
      gameStateJson: serializer.fromJson<String>(json['gameStateJson']),
      rulesVersion: serializer.fromJson<String>(json['rulesVersion']),
      saveSchemaVersion: serializer.fromJson<int>(json['saveSchemaVersion']),
      generatorVersion: serializer.fromJson<String>(json['generatorVersion']),
      revision: serializer.fromJson<int>(json['revision']),
      savedAt: serializer.fromJson<DateTime>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'levelDefinitionId': serializer.toJson<String>(levelDefinitionId),
      'attemptId': serializer.toJson<String>(attemptId),
      'seed': serializer.toJson<int>(seed),
      'gameStateJson': serializer.toJson<String>(gameStateJson),
      'rulesVersion': serializer.toJson<String>(rulesVersion),
      'saveSchemaVersion': serializer.toJson<int>(saveSchemaVersion),
      'generatorVersion': serializer.toJson<String>(generatorVersion),
      'revision': serializer.toJson<int>(revision),
      'savedAt': serializer.toJson<DateTime>(savedAt),
    };
  }

  ActiveAttempt copyWith({
    String? id,
    String? levelDefinitionId,
    String? attemptId,
    int? seed,
    String? gameStateJson,
    String? rulesVersion,
    int? saveSchemaVersion,
    String? generatorVersion,
    int? revision,
    DateTime? savedAt,
  }) => ActiveAttempt(
    id: id ?? this.id,
    levelDefinitionId: levelDefinitionId ?? this.levelDefinitionId,
    attemptId: attemptId ?? this.attemptId,
    seed: seed ?? this.seed,
    gameStateJson: gameStateJson ?? this.gameStateJson,
    rulesVersion: rulesVersion ?? this.rulesVersion,
    saveSchemaVersion: saveSchemaVersion ?? this.saveSchemaVersion,
    generatorVersion: generatorVersion ?? this.generatorVersion,
    revision: revision ?? this.revision,
    savedAt: savedAt ?? this.savedAt,
  );
  ActiveAttempt copyWithCompanion(ActiveAttemptsCompanion data) {
    return ActiveAttempt(
      id: data.id.present ? data.id.value : this.id,
      levelDefinitionId: data.levelDefinitionId.present
          ? data.levelDefinitionId.value
          : this.levelDefinitionId,
      attemptId: data.attemptId.present ? data.attemptId.value : this.attemptId,
      seed: data.seed.present ? data.seed.value : this.seed,
      gameStateJson: data.gameStateJson.present
          ? data.gameStateJson.value
          : this.gameStateJson,
      rulesVersion: data.rulesVersion.present
          ? data.rulesVersion.value
          : this.rulesVersion,
      saveSchemaVersion: data.saveSchemaVersion.present
          ? data.saveSchemaVersion.value
          : this.saveSchemaVersion,
      generatorVersion: data.generatorVersion.present
          ? data.generatorVersion.value
          : this.generatorVersion,
      revision: data.revision.present ? data.revision.value : this.revision,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActiveAttempt(')
          ..write('id: $id, ')
          ..write('levelDefinitionId: $levelDefinitionId, ')
          ..write('attemptId: $attemptId, ')
          ..write('seed: $seed, ')
          ..write('gameStateJson: $gameStateJson, ')
          ..write('rulesVersion: $rulesVersion, ')
          ..write('saveSchemaVersion: $saveSchemaVersion, ')
          ..write('generatorVersion: $generatorVersion, ')
          ..write('revision: $revision, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    levelDefinitionId,
    attemptId,
    seed,
    gameStateJson,
    rulesVersion,
    saveSchemaVersion,
    generatorVersion,
    revision,
    savedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActiveAttempt &&
          other.id == this.id &&
          other.levelDefinitionId == this.levelDefinitionId &&
          other.attemptId == this.attemptId &&
          other.seed == this.seed &&
          other.gameStateJson == this.gameStateJson &&
          other.rulesVersion == this.rulesVersion &&
          other.saveSchemaVersion == this.saveSchemaVersion &&
          other.generatorVersion == this.generatorVersion &&
          other.revision == this.revision &&
          other.savedAt == this.savedAt);
}

class ActiveAttemptsCompanion extends UpdateCompanion<ActiveAttempt> {
  final Value<String> id;
  final Value<String> levelDefinitionId;
  final Value<String> attemptId;
  final Value<int> seed;
  final Value<String> gameStateJson;
  final Value<String> rulesVersion;
  final Value<int> saveSchemaVersion;
  final Value<String> generatorVersion;
  final Value<int> revision;
  final Value<DateTime> savedAt;
  final Value<int> rowid;
  const ActiveAttemptsCompanion({
    this.id = const Value.absent(),
    this.levelDefinitionId = const Value.absent(),
    this.attemptId = const Value.absent(),
    this.seed = const Value.absent(),
    this.gameStateJson = const Value.absent(),
    this.rulesVersion = const Value.absent(),
    this.saveSchemaVersion = const Value.absent(),
    this.generatorVersion = const Value.absent(),
    this.revision = const Value.absent(),
    this.savedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActiveAttemptsCompanion.insert({
    required String id,
    required String levelDefinitionId,
    required String attemptId,
    required int seed,
    required String gameStateJson,
    required String rulesVersion,
    required int saveSchemaVersion,
    this.generatorVersion = const Value.absent(),
    this.revision = const Value.absent(),
    this.savedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       levelDefinitionId = Value(levelDefinitionId),
       attemptId = Value(attemptId),
       seed = Value(seed),
       gameStateJson = Value(gameStateJson),
       rulesVersion = Value(rulesVersion),
       saveSchemaVersion = Value(saveSchemaVersion);
  static Insertable<ActiveAttempt> custom({
    Expression<String>? id,
    Expression<String>? levelDefinitionId,
    Expression<String>? attemptId,
    Expression<int>? seed,
    Expression<String>? gameStateJson,
    Expression<String>? rulesVersion,
    Expression<int>? saveSchemaVersion,
    Expression<String>? generatorVersion,
    Expression<int>? revision,
    Expression<DateTime>? savedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (levelDefinitionId != null) 'level_definition_id': levelDefinitionId,
      if (attemptId != null) 'attempt_id': attemptId,
      if (seed != null) 'seed': seed,
      if (gameStateJson != null) 'game_state_json': gameStateJson,
      if (rulesVersion != null) 'rules_version': rulesVersion,
      if (saveSchemaVersion != null) 'save_schema_version': saveSchemaVersion,
      if (generatorVersion != null) 'generator_version': generatorVersion,
      if (revision != null) 'revision': revision,
      if (savedAt != null) 'saved_at': savedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActiveAttemptsCompanion copyWith({
    Value<String>? id,
    Value<String>? levelDefinitionId,
    Value<String>? attemptId,
    Value<int>? seed,
    Value<String>? gameStateJson,
    Value<String>? rulesVersion,
    Value<int>? saveSchemaVersion,
    Value<String>? generatorVersion,
    Value<int>? revision,
    Value<DateTime>? savedAt,
    Value<int>? rowid,
  }) {
    return ActiveAttemptsCompanion(
      id: id ?? this.id,
      levelDefinitionId: levelDefinitionId ?? this.levelDefinitionId,
      attemptId: attemptId ?? this.attemptId,
      seed: seed ?? this.seed,
      gameStateJson: gameStateJson ?? this.gameStateJson,
      rulesVersion: rulesVersion ?? this.rulesVersion,
      saveSchemaVersion: saveSchemaVersion ?? this.saveSchemaVersion,
      generatorVersion: generatorVersion ?? this.generatorVersion,
      revision: revision ?? this.revision,
      savedAt: savedAt ?? this.savedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (levelDefinitionId.present) {
      map['level_definition_id'] = Variable<String>(levelDefinitionId.value);
    }
    if (attemptId.present) {
      map['attempt_id'] = Variable<String>(attemptId.value);
    }
    if (seed.present) {
      map['seed'] = Variable<int>(seed.value);
    }
    if (gameStateJson.present) {
      map['game_state_json'] = Variable<String>(gameStateJson.value);
    }
    if (rulesVersion.present) {
      map['rules_version'] = Variable<String>(rulesVersion.value);
    }
    if (saveSchemaVersion.present) {
      map['save_schema_version'] = Variable<int>(saveSchemaVersion.value);
    }
    if (generatorVersion.present) {
      map['generator_version'] = Variable<String>(generatorVersion.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActiveAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('levelDefinitionId: $levelDefinitionId, ')
          ..write('attemptId: $attemptId, ')
          ..write('seed: $seed, ')
          ..write('gameStateJson: $gameStateJson, ')
          ..write('rulesVersion: $rulesVersion, ')
          ..write('saveSchemaVersion: $saveSchemaVersion, ')
          ..write('generatorVersion: $generatorVersion, ')
          ..write('revision: $revision, ')
          ..write('savedAt: $savedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppMetadataTable appMetadata = $AppMetadataTable(this);
  late final $SchemaMetadataTable schemaMetadata = $SchemaMetadataTable(this);
  late final $ActiveAttemptsTable activeAttempts = $ActiveAttemptsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appMetadata,
    schemaMetadata,
    activeAttempts,
  ];
}

typedef $$AppMetadataTableCreateCompanionBuilder =
    AppMetadataCompanion Function({
      required String key,
      required String value,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AppMetadataTableUpdateCompanionBuilder =
    AppMetadataCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $AppMetadataTable> {
  $$AppMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $AppMetadataTable> {
  $$AppMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppMetadataTable> {
  $$AppMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppMetadataTable,
          AppMetadataData,
          $$AppMetadataTableFilterComposer,
          $$AppMetadataTableOrderingComposer,
          $$AppMetadataTableAnnotationComposer,
          $$AppMetadataTableCreateCompanionBuilder,
          $$AppMetadataTableUpdateCompanionBuilder,
          (
            AppMetadataData,
            BaseReferences<_$AppDatabase, $AppMetadataTable, AppMetadataData>,
          ),
          AppMetadataData,
          PrefetchHooks Function()
        > {
  $$AppMetadataTableTableManager(_$AppDatabase db, $AppMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppMetadataCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppMetadataCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppMetadataTable,
      AppMetadataData,
      $$AppMetadataTableFilterComposer,
      $$AppMetadataTableOrderingComposer,
      $$AppMetadataTableAnnotationComposer,
      $$AppMetadataTableCreateCompanionBuilder,
      $$AppMetadataTableUpdateCompanionBuilder,
      (
        AppMetadataData,
        BaseReferences<_$AppDatabase, $AppMetadataTable, AppMetadataData>,
      ),
      AppMetadataData,
      PrefetchHooks Function()
    >;
typedef $$SchemaMetadataTableCreateCompanionBuilder =
    SchemaMetadataCompanion Function({
      Value<int> id,
      required int schemaVersion,
      Value<String> notes,
      Value<DateTime> migratedAt,
    });
typedef $$SchemaMetadataTableUpdateCompanionBuilder =
    SchemaMetadataCompanion Function({
      Value<int> id,
      Value<int> schemaVersion,
      Value<String> notes,
      Value<DateTime> migratedAt,
    });

class $$SchemaMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $SchemaMetadataTable> {
  $$SchemaMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get migratedAt => $composableBuilder(
    column: $table.migratedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SchemaMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $SchemaMetadataTable> {
  $$SchemaMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get migratedAt => $composableBuilder(
    column: $table.migratedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SchemaMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchemaMetadataTable> {
  $$SchemaMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get migratedAt => $composableBuilder(
    column: $table.migratedAt,
    builder: (column) => column,
  );
}

class $$SchemaMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SchemaMetadataTable,
          SchemaMetadataData,
          $$SchemaMetadataTableFilterComposer,
          $$SchemaMetadataTableOrderingComposer,
          $$SchemaMetadataTableAnnotationComposer,
          $$SchemaMetadataTableCreateCompanionBuilder,
          $$SchemaMetadataTableUpdateCompanionBuilder,
          (
            SchemaMetadataData,
            BaseReferences<
              _$AppDatabase,
              $SchemaMetadataTable,
              SchemaMetadataData
            >,
          ),
          SchemaMetadataData,
          PrefetchHooks Function()
        > {
  $$SchemaMetadataTableTableManager(
    _$AppDatabase db,
    $SchemaMetadataTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchemaMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchemaMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchemaMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> schemaVersion = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime> migratedAt = const Value.absent(),
              }) => SchemaMetadataCompanion(
                id: id,
                schemaVersion: schemaVersion,
                notes: notes,
                migratedAt: migratedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int schemaVersion,
                Value<String> notes = const Value.absent(),
                Value<DateTime> migratedAt = const Value.absent(),
              }) => SchemaMetadataCompanion.insert(
                id: id,
                schemaVersion: schemaVersion,
                notes: notes,
                migratedAt: migratedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SchemaMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SchemaMetadataTable,
      SchemaMetadataData,
      $$SchemaMetadataTableFilterComposer,
      $$SchemaMetadataTableOrderingComposer,
      $$SchemaMetadataTableAnnotationComposer,
      $$SchemaMetadataTableCreateCompanionBuilder,
      $$SchemaMetadataTableUpdateCompanionBuilder,
      (
        SchemaMetadataData,
        BaseReferences<_$AppDatabase, $SchemaMetadataTable, SchemaMetadataData>,
      ),
      SchemaMetadataData,
      PrefetchHooks Function()
    >;
typedef $$ActiveAttemptsTableCreateCompanionBuilder =
    ActiveAttemptsCompanion Function({
      required String id,
      required String levelDefinitionId,
      required String attemptId,
      required int seed,
      required String gameStateJson,
      required String rulesVersion,
      required int saveSchemaVersion,
      Value<String> generatorVersion,
      Value<int> revision,
      Value<DateTime> savedAt,
      Value<int> rowid,
    });
typedef $$ActiveAttemptsTableUpdateCompanionBuilder =
    ActiveAttemptsCompanion Function({
      Value<String> id,
      Value<String> levelDefinitionId,
      Value<String> attemptId,
      Value<int> seed,
      Value<String> gameStateJson,
      Value<String> rulesVersion,
      Value<int> saveSchemaVersion,
      Value<String> generatorVersion,
      Value<int> revision,
      Value<DateTime> savedAt,
      Value<int> rowid,
    });

class $$ActiveAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $ActiveAttemptsTable> {
  $$ActiveAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get levelDefinitionId => $composableBuilder(
    column: $table.levelDefinitionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attemptId => $composableBuilder(
    column: $table.attemptId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seed => $composableBuilder(
    column: $table.seed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gameStateJson => $composableBuilder(
    column: $table.gameStateJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rulesVersion => $composableBuilder(
    column: $table.rulesVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get saveSchemaVersion => $composableBuilder(
    column: $table.saveSchemaVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get generatorVersion => $composableBuilder(
    column: $table.generatorVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActiveAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActiveAttemptsTable> {
  $$ActiveAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get levelDefinitionId => $composableBuilder(
    column: $table.levelDefinitionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attemptId => $composableBuilder(
    column: $table.attemptId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seed => $composableBuilder(
    column: $table.seed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gameStateJson => $composableBuilder(
    column: $table.gameStateJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rulesVersion => $composableBuilder(
    column: $table.rulesVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get saveSchemaVersion => $composableBuilder(
    column: $table.saveSchemaVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get generatorVersion => $composableBuilder(
    column: $table.generatorVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActiveAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActiveAttemptsTable> {
  $$ActiveAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get levelDefinitionId => $composableBuilder(
    column: $table.levelDefinitionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get attemptId =>
      $composableBuilder(column: $table.attemptId, builder: (column) => column);

  GeneratedColumn<int> get seed =>
      $composableBuilder(column: $table.seed, builder: (column) => column);

  GeneratedColumn<String> get gameStateJson => $composableBuilder(
    column: $table.gameStateJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rulesVersion => $composableBuilder(
    column: $table.rulesVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get saveSchemaVersion => $composableBuilder(
    column: $table.saveSchemaVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get generatorVersion => $composableBuilder(
    column: $table.generatorVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<DateTime> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);
}

class $$ActiveAttemptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActiveAttemptsTable,
          ActiveAttempt,
          $$ActiveAttemptsTableFilterComposer,
          $$ActiveAttemptsTableOrderingComposer,
          $$ActiveAttemptsTableAnnotationComposer,
          $$ActiveAttemptsTableCreateCompanionBuilder,
          $$ActiveAttemptsTableUpdateCompanionBuilder,
          (
            ActiveAttempt,
            BaseReferences<_$AppDatabase, $ActiveAttemptsTable, ActiveAttempt>,
          ),
          ActiveAttempt,
          PrefetchHooks Function()
        > {
  $$ActiveAttemptsTableTableManager(
    _$AppDatabase db,
    $ActiveAttemptsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActiveAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActiveAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActiveAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> levelDefinitionId = const Value.absent(),
                Value<String> attemptId = const Value.absent(),
                Value<int> seed = const Value.absent(),
                Value<String> gameStateJson = const Value.absent(),
                Value<String> rulesVersion = const Value.absent(),
                Value<int> saveSchemaVersion = const Value.absent(),
                Value<String> generatorVersion = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<DateTime> savedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActiveAttemptsCompanion(
                id: id,
                levelDefinitionId: levelDefinitionId,
                attemptId: attemptId,
                seed: seed,
                gameStateJson: gameStateJson,
                rulesVersion: rulesVersion,
                saveSchemaVersion: saveSchemaVersion,
                generatorVersion: generatorVersion,
                revision: revision,
                savedAt: savedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String levelDefinitionId,
                required String attemptId,
                required int seed,
                required String gameStateJson,
                required String rulesVersion,
                required int saveSchemaVersion,
                Value<String> generatorVersion = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<DateTime> savedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActiveAttemptsCompanion.insert(
                id: id,
                levelDefinitionId: levelDefinitionId,
                attemptId: attemptId,
                seed: seed,
                gameStateJson: gameStateJson,
                rulesVersion: rulesVersion,
                saveSchemaVersion: saveSchemaVersion,
                generatorVersion: generatorVersion,
                revision: revision,
                savedAt: savedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActiveAttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActiveAttemptsTable,
      ActiveAttempt,
      $$ActiveAttemptsTableFilterComposer,
      $$ActiveAttemptsTableOrderingComposer,
      $$ActiveAttemptsTableAnnotationComposer,
      $$ActiveAttemptsTableCreateCompanionBuilder,
      $$ActiveAttemptsTableUpdateCompanionBuilder,
      (
        ActiveAttempt,
        BaseReferences<_$AppDatabase, $ActiveAttemptsTable, ActiveAttempt>,
      ),
      ActiveAttempt,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppMetadataTableTableManager get appMetadata =>
      $$AppMetadataTableTableManager(_db, _db.appMetadata);
  $$SchemaMetadataTableTableManager get schemaMetadata =>
      $$SchemaMetadataTableTableManager(_db, _db.schemaMetadata);
  $$ActiveAttemptsTableTableManager get activeAttempts =>
      $$ActiveAttemptsTableTableManager(_db, _db.activeAttempts);
}
