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

class $JourneyProgressRowsTable extends JourneyProgressRows
    with TableInfo<$JourneyProgressRowsTable, JourneyProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JourneyProgressRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _highestUnlockedLevelMeta =
      const VerificationMeta('highestUnlockedLevel');
  @override
  late final GeneratedColumn<int> highestUnlockedLevel = GeneratedColumn<int>(
    'highest_unlocked_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _highestCompletedLevelMeta =
      const VerificationMeta('highestCompletedLevel');
  @override
  late final GeneratedColumn<int> highestCompletedLevel = GeneratedColumn<int>(
    'highest_completed_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currentLevelIdMeta = const VerificationMeta(
    'currentLevelId',
  );
  @override
  late final GeneratedColumn<String> currentLevelId = GeneratedColumn<String>(
    'current_level_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedLevelIdsJsonMeta =
      const VerificationMeta('completedLevelIdsJson');
  @override
  late final GeneratedColumn<String> completedLevelIdsJson =
      GeneratedColumn<String>(
        'completed_level_ids_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _completedChapterIdsJsonMeta =
      const VerificationMeta('completedChapterIdsJson');
  @override
  late final GeneratedColumn<String> completedChapterIdsJson =
      GeneratedColumn<String>(
        'completed_chapter_ids_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _progressionSchemaVersionMeta =
      const VerificationMeta('progressionSchemaVersion');
  @override
  late final GeneratedColumn<int> progressionSchemaVersion =
      GeneratedColumn<int>(
        'progression_schema_version',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(1),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    highestUnlockedLevel,
    highestCompletedLevel,
    currentLevelId,
    completedLevelIdsJson,
    completedChapterIdsJson,
    progressionSchemaVersion,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journey_progress_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<JourneyProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('highest_unlocked_level')) {
      context.handle(
        _highestUnlockedLevelMeta,
        highestUnlockedLevel.isAcceptableOrUnknown(
          data['highest_unlocked_level']!,
          _highestUnlockedLevelMeta,
        ),
      );
    }
    if (data.containsKey('highest_completed_level')) {
      context.handle(
        _highestCompletedLevelMeta,
        highestCompletedLevel.isAcceptableOrUnknown(
          data['highest_completed_level']!,
          _highestCompletedLevelMeta,
        ),
      );
    }
    if (data.containsKey('current_level_id')) {
      context.handle(
        _currentLevelIdMeta,
        currentLevelId.isAcceptableOrUnknown(
          data['current_level_id']!,
          _currentLevelIdMeta,
        ),
      );
    }
    if (data.containsKey('completed_level_ids_json')) {
      context.handle(
        _completedLevelIdsJsonMeta,
        completedLevelIdsJson.isAcceptableOrUnknown(
          data['completed_level_ids_json']!,
          _completedLevelIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('completed_chapter_ids_json')) {
      context.handle(
        _completedChapterIdsJsonMeta,
        completedChapterIdsJson.isAcceptableOrUnknown(
          data['completed_chapter_ids_json']!,
          _completedChapterIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('progression_schema_version')) {
      context.handle(
        _progressionSchemaVersionMeta,
        progressionSchemaVersion.isAcceptableOrUnknown(
          data['progression_schema_version']!,
          _progressionSchemaVersionMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JourneyProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JourneyProgressRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      highestUnlockedLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}highest_unlocked_level'],
      )!,
      highestCompletedLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}highest_completed_level'],
      )!,
      currentLevelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_level_id'],
      ),
      completedLevelIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_level_ids_json'],
      )!,
      completedChapterIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_chapter_ids_json'],
      )!,
      progressionSchemaVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progression_schema_version'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $JourneyProgressRowsTable createAlias(String alias) {
    return $JourneyProgressRowsTable(attachedDatabase, alias);
  }
}

class JourneyProgressRow extends DataClass
    implements Insertable<JourneyProgressRow> {
  final String id;
  final int highestUnlockedLevel;
  final int highestCompletedLevel;
  final String? currentLevelId;
  final String completedLevelIdsJson;
  final String completedChapterIdsJson;
  final int progressionSchemaVersion;
  final DateTime updatedAt;
  const JourneyProgressRow({
    required this.id,
    required this.highestUnlockedLevel,
    required this.highestCompletedLevel,
    this.currentLevelId,
    required this.completedLevelIdsJson,
    required this.completedChapterIdsJson,
    required this.progressionSchemaVersion,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['highest_unlocked_level'] = Variable<int>(highestUnlockedLevel);
    map['highest_completed_level'] = Variable<int>(highestCompletedLevel);
    if (!nullToAbsent || currentLevelId != null) {
      map['current_level_id'] = Variable<String>(currentLevelId);
    }
    map['completed_level_ids_json'] = Variable<String>(completedLevelIdsJson);
    map['completed_chapter_ids_json'] = Variable<String>(
      completedChapterIdsJson,
    );
    map['progression_schema_version'] = Variable<int>(progressionSchemaVersion);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  JourneyProgressRowsCompanion toCompanion(bool nullToAbsent) {
    return JourneyProgressRowsCompanion(
      id: Value(id),
      highestUnlockedLevel: Value(highestUnlockedLevel),
      highestCompletedLevel: Value(highestCompletedLevel),
      currentLevelId: currentLevelId == null && nullToAbsent
          ? const Value.absent()
          : Value(currentLevelId),
      completedLevelIdsJson: Value(completedLevelIdsJson),
      completedChapterIdsJson: Value(completedChapterIdsJson),
      progressionSchemaVersion: Value(progressionSchemaVersion),
      updatedAt: Value(updatedAt),
    );
  }

  factory JourneyProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JourneyProgressRow(
      id: serializer.fromJson<String>(json['id']),
      highestUnlockedLevel: serializer.fromJson<int>(
        json['highestUnlockedLevel'],
      ),
      highestCompletedLevel: serializer.fromJson<int>(
        json['highestCompletedLevel'],
      ),
      currentLevelId: serializer.fromJson<String?>(json['currentLevelId']),
      completedLevelIdsJson: serializer.fromJson<String>(
        json['completedLevelIdsJson'],
      ),
      completedChapterIdsJson: serializer.fromJson<String>(
        json['completedChapterIdsJson'],
      ),
      progressionSchemaVersion: serializer.fromJson<int>(
        json['progressionSchemaVersion'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'highestUnlockedLevel': serializer.toJson<int>(highestUnlockedLevel),
      'highestCompletedLevel': serializer.toJson<int>(highestCompletedLevel),
      'currentLevelId': serializer.toJson<String?>(currentLevelId),
      'completedLevelIdsJson': serializer.toJson<String>(completedLevelIdsJson),
      'completedChapterIdsJson': serializer.toJson<String>(
        completedChapterIdsJson,
      ),
      'progressionSchemaVersion': serializer.toJson<int>(
        progressionSchemaVersion,
      ),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  JourneyProgressRow copyWith({
    String? id,
    int? highestUnlockedLevel,
    int? highestCompletedLevel,
    Value<String?> currentLevelId = const Value.absent(),
    String? completedLevelIdsJson,
    String? completedChapterIdsJson,
    int? progressionSchemaVersion,
    DateTime? updatedAt,
  }) => JourneyProgressRow(
    id: id ?? this.id,
    highestUnlockedLevel: highestUnlockedLevel ?? this.highestUnlockedLevel,
    highestCompletedLevel: highestCompletedLevel ?? this.highestCompletedLevel,
    currentLevelId: currentLevelId.present
        ? currentLevelId.value
        : this.currentLevelId,
    completedLevelIdsJson: completedLevelIdsJson ?? this.completedLevelIdsJson,
    completedChapterIdsJson:
        completedChapterIdsJson ?? this.completedChapterIdsJson,
    progressionSchemaVersion:
        progressionSchemaVersion ?? this.progressionSchemaVersion,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  JourneyProgressRow copyWithCompanion(JourneyProgressRowsCompanion data) {
    return JourneyProgressRow(
      id: data.id.present ? data.id.value : this.id,
      highestUnlockedLevel: data.highestUnlockedLevel.present
          ? data.highestUnlockedLevel.value
          : this.highestUnlockedLevel,
      highestCompletedLevel: data.highestCompletedLevel.present
          ? data.highestCompletedLevel.value
          : this.highestCompletedLevel,
      currentLevelId: data.currentLevelId.present
          ? data.currentLevelId.value
          : this.currentLevelId,
      completedLevelIdsJson: data.completedLevelIdsJson.present
          ? data.completedLevelIdsJson.value
          : this.completedLevelIdsJson,
      completedChapterIdsJson: data.completedChapterIdsJson.present
          ? data.completedChapterIdsJson.value
          : this.completedChapterIdsJson,
      progressionSchemaVersion: data.progressionSchemaVersion.present
          ? data.progressionSchemaVersion.value
          : this.progressionSchemaVersion,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JourneyProgressRow(')
          ..write('id: $id, ')
          ..write('highestUnlockedLevel: $highestUnlockedLevel, ')
          ..write('highestCompletedLevel: $highestCompletedLevel, ')
          ..write('currentLevelId: $currentLevelId, ')
          ..write('completedLevelIdsJson: $completedLevelIdsJson, ')
          ..write('completedChapterIdsJson: $completedChapterIdsJson, ')
          ..write('progressionSchemaVersion: $progressionSchemaVersion, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    highestUnlockedLevel,
    highestCompletedLevel,
    currentLevelId,
    completedLevelIdsJson,
    completedChapterIdsJson,
    progressionSchemaVersion,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JourneyProgressRow &&
          other.id == this.id &&
          other.highestUnlockedLevel == this.highestUnlockedLevel &&
          other.highestCompletedLevel == this.highestCompletedLevel &&
          other.currentLevelId == this.currentLevelId &&
          other.completedLevelIdsJson == this.completedLevelIdsJson &&
          other.completedChapterIdsJson == this.completedChapterIdsJson &&
          other.progressionSchemaVersion == this.progressionSchemaVersion &&
          other.updatedAt == this.updatedAt);
}

class JourneyProgressRowsCompanion extends UpdateCompanion<JourneyProgressRow> {
  final Value<String> id;
  final Value<int> highestUnlockedLevel;
  final Value<int> highestCompletedLevel;
  final Value<String?> currentLevelId;
  final Value<String> completedLevelIdsJson;
  final Value<String> completedChapterIdsJson;
  final Value<int> progressionSchemaVersion;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const JourneyProgressRowsCompanion({
    this.id = const Value.absent(),
    this.highestUnlockedLevel = const Value.absent(),
    this.highestCompletedLevel = const Value.absent(),
    this.currentLevelId = const Value.absent(),
    this.completedLevelIdsJson = const Value.absent(),
    this.completedChapterIdsJson = const Value.absent(),
    this.progressionSchemaVersion = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JourneyProgressRowsCompanion.insert({
    required String id,
    this.highestUnlockedLevel = const Value.absent(),
    this.highestCompletedLevel = const Value.absent(),
    this.currentLevelId = const Value.absent(),
    this.completedLevelIdsJson = const Value.absent(),
    this.completedChapterIdsJson = const Value.absent(),
    this.progressionSchemaVersion = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<JourneyProgressRow> custom({
    Expression<String>? id,
    Expression<int>? highestUnlockedLevel,
    Expression<int>? highestCompletedLevel,
    Expression<String>? currentLevelId,
    Expression<String>? completedLevelIdsJson,
    Expression<String>? completedChapterIdsJson,
    Expression<int>? progressionSchemaVersion,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (highestUnlockedLevel != null)
        'highest_unlocked_level': highestUnlockedLevel,
      if (highestCompletedLevel != null)
        'highest_completed_level': highestCompletedLevel,
      if (currentLevelId != null) 'current_level_id': currentLevelId,
      if (completedLevelIdsJson != null)
        'completed_level_ids_json': completedLevelIdsJson,
      if (completedChapterIdsJson != null)
        'completed_chapter_ids_json': completedChapterIdsJson,
      if (progressionSchemaVersion != null)
        'progression_schema_version': progressionSchemaVersion,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JourneyProgressRowsCompanion copyWith({
    Value<String>? id,
    Value<int>? highestUnlockedLevel,
    Value<int>? highestCompletedLevel,
    Value<String?>? currentLevelId,
    Value<String>? completedLevelIdsJson,
    Value<String>? completedChapterIdsJson,
    Value<int>? progressionSchemaVersion,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return JourneyProgressRowsCompanion(
      id: id ?? this.id,
      highestUnlockedLevel: highestUnlockedLevel ?? this.highestUnlockedLevel,
      highestCompletedLevel:
          highestCompletedLevel ?? this.highestCompletedLevel,
      currentLevelId: currentLevelId ?? this.currentLevelId,
      completedLevelIdsJson:
          completedLevelIdsJson ?? this.completedLevelIdsJson,
      completedChapterIdsJson:
          completedChapterIdsJson ?? this.completedChapterIdsJson,
      progressionSchemaVersion:
          progressionSchemaVersion ?? this.progressionSchemaVersion,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (highestUnlockedLevel.present) {
      map['highest_unlocked_level'] = Variable<int>(highestUnlockedLevel.value);
    }
    if (highestCompletedLevel.present) {
      map['highest_completed_level'] = Variable<int>(
        highestCompletedLevel.value,
      );
    }
    if (currentLevelId.present) {
      map['current_level_id'] = Variable<String>(currentLevelId.value);
    }
    if (completedLevelIdsJson.present) {
      map['completed_level_ids_json'] = Variable<String>(
        completedLevelIdsJson.value,
      );
    }
    if (completedChapterIdsJson.present) {
      map['completed_chapter_ids_json'] = Variable<String>(
        completedChapterIdsJson.value,
      );
    }
    if (progressionSchemaVersion.present) {
      map['progression_schema_version'] = Variable<int>(
        progressionSchemaVersion.value,
      );
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
    return (StringBuffer('JourneyProgressRowsCompanion(')
          ..write('id: $id, ')
          ..write('highestUnlockedLevel: $highestUnlockedLevel, ')
          ..write('highestCompletedLevel: $highestCompletedLevel, ')
          ..write('currentLevelId: $currentLevelId, ')
          ..write('completedLevelIdsJson: $completedLevelIdsJson, ')
          ..write('completedChapterIdsJson: $completedChapterIdsJson, ')
          ..write('progressionSchemaVersion: $progressionSchemaVersion, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlayerFlagRowsTable extends PlayerFlagRows
    with TableInfo<$PlayerFlagRowsTable, PlayerFlagRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayerFlagRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isFirstLaunchMeta = const VerificationMeta(
    'isFirstLaunch',
  );
  @override
  late final GeneratedColumn<bool> isFirstLaunch = GeneratedColumn<bool>(
    'is_first_launch',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_first_launch" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _tutorialCompletedMeta = const VerificationMeta(
    'tutorialCompleted',
  );
  @override
  late final GeneratedColumn<bool> tutorialCompleted = GeneratedColumn<bool>(
    'tutorial_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("tutorial_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _unlockedStoryBeatIdsJsonMeta =
      const VerificationMeta('unlockedStoryBeatIdsJson');
  @override
  late final GeneratedColumn<String> unlockedStoryBeatIdsJson =
      GeneratedColumn<String>(
        'unlocked_story_beat_ids_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _viewedStoryBeatIdsJsonMeta =
      const VerificationMeta('viewedStoryBeatIdsJson');
  @override
  late final GeneratedColumn<String> viewedStoryBeatIdsJson =
      GeneratedColumn<String>(
        'viewed_story_beat_ids_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    isFirstLaunch,
    onboardingCompleted,
    tutorialCompleted,
    unlockedStoryBeatIdsJson,
    viewedStoryBeatIdsJson,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'player_flag_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlayerFlagRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('is_first_launch')) {
      context.handle(
        _isFirstLaunchMeta,
        isFirstLaunch.isAcceptableOrUnknown(
          data['is_first_launch']!,
          _isFirstLaunchMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
        ),
      );
    }
    if (data.containsKey('tutorial_completed')) {
      context.handle(
        _tutorialCompletedMeta,
        tutorialCompleted.isAcceptableOrUnknown(
          data['tutorial_completed']!,
          _tutorialCompletedMeta,
        ),
      );
    }
    if (data.containsKey('unlocked_story_beat_ids_json')) {
      context.handle(
        _unlockedStoryBeatIdsJsonMeta,
        unlockedStoryBeatIdsJson.isAcceptableOrUnknown(
          data['unlocked_story_beat_ids_json']!,
          _unlockedStoryBeatIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('viewed_story_beat_ids_json')) {
      context.handle(
        _viewedStoryBeatIdsJsonMeta,
        viewedStoryBeatIdsJson.isAcceptableOrUnknown(
          data['viewed_story_beat_ids_json']!,
          _viewedStoryBeatIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayerFlagRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerFlagRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      isFirstLaunch: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_first_launch'],
      )!,
      onboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_completed'],
      )!,
      tutorialCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}tutorial_completed'],
      )!,
      unlockedStoryBeatIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unlocked_story_beat_ids_json'],
      )!,
      viewedStoryBeatIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}viewed_story_beat_ids_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PlayerFlagRowsTable createAlias(String alias) {
    return $PlayerFlagRowsTable(attachedDatabase, alias);
  }
}

class PlayerFlagRow extends DataClass implements Insertable<PlayerFlagRow> {
  final String id;
  final bool isFirstLaunch;
  final bool onboardingCompleted;
  final bool tutorialCompleted;
  final String unlockedStoryBeatIdsJson;
  final String viewedStoryBeatIdsJson;
  final DateTime updatedAt;
  const PlayerFlagRow({
    required this.id,
    required this.isFirstLaunch,
    required this.onboardingCompleted,
    required this.tutorialCompleted,
    required this.unlockedStoryBeatIdsJson,
    required this.viewedStoryBeatIdsJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['is_first_launch'] = Variable<bool>(isFirstLaunch);
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    map['tutorial_completed'] = Variable<bool>(tutorialCompleted);
    map['unlocked_story_beat_ids_json'] = Variable<String>(
      unlockedStoryBeatIdsJson,
    );
    map['viewed_story_beat_ids_json'] = Variable<String>(
      viewedStoryBeatIdsJson,
    );
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PlayerFlagRowsCompanion toCompanion(bool nullToAbsent) {
    return PlayerFlagRowsCompanion(
      id: Value(id),
      isFirstLaunch: Value(isFirstLaunch),
      onboardingCompleted: Value(onboardingCompleted),
      tutorialCompleted: Value(tutorialCompleted),
      unlockedStoryBeatIdsJson: Value(unlockedStoryBeatIdsJson),
      viewedStoryBeatIdsJson: Value(viewedStoryBeatIdsJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory PlayerFlagRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerFlagRow(
      id: serializer.fromJson<String>(json['id']),
      isFirstLaunch: serializer.fromJson<bool>(json['isFirstLaunch']),
      onboardingCompleted: serializer.fromJson<bool>(
        json['onboardingCompleted'],
      ),
      tutorialCompleted: serializer.fromJson<bool>(json['tutorialCompleted']),
      unlockedStoryBeatIdsJson: serializer.fromJson<String>(
        json['unlockedStoryBeatIdsJson'],
      ),
      viewedStoryBeatIdsJson: serializer.fromJson<String>(
        json['viewedStoryBeatIdsJson'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'isFirstLaunch': serializer.toJson<bool>(isFirstLaunch),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
      'tutorialCompleted': serializer.toJson<bool>(tutorialCompleted),
      'unlockedStoryBeatIdsJson': serializer.toJson<String>(
        unlockedStoryBeatIdsJson,
      ),
      'viewedStoryBeatIdsJson': serializer.toJson<String>(
        viewedStoryBeatIdsJson,
      ),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PlayerFlagRow copyWith({
    String? id,
    bool? isFirstLaunch,
    bool? onboardingCompleted,
    bool? tutorialCompleted,
    String? unlockedStoryBeatIdsJson,
    String? viewedStoryBeatIdsJson,
    DateTime? updatedAt,
  }) => PlayerFlagRow(
    id: id ?? this.id,
    isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    tutorialCompleted: tutorialCompleted ?? this.tutorialCompleted,
    unlockedStoryBeatIdsJson:
        unlockedStoryBeatIdsJson ?? this.unlockedStoryBeatIdsJson,
    viewedStoryBeatIdsJson:
        viewedStoryBeatIdsJson ?? this.viewedStoryBeatIdsJson,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PlayerFlagRow copyWithCompanion(PlayerFlagRowsCompanion data) {
    return PlayerFlagRow(
      id: data.id.present ? data.id.value : this.id,
      isFirstLaunch: data.isFirstLaunch.present
          ? data.isFirstLaunch.value
          : this.isFirstLaunch,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
      tutorialCompleted: data.tutorialCompleted.present
          ? data.tutorialCompleted.value
          : this.tutorialCompleted,
      unlockedStoryBeatIdsJson: data.unlockedStoryBeatIdsJson.present
          ? data.unlockedStoryBeatIdsJson.value
          : this.unlockedStoryBeatIdsJson,
      viewedStoryBeatIdsJson: data.viewedStoryBeatIdsJson.present
          ? data.viewedStoryBeatIdsJson.value
          : this.viewedStoryBeatIdsJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerFlagRow(')
          ..write('id: $id, ')
          ..write('isFirstLaunch: $isFirstLaunch, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('tutorialCompleted: $tutorialCompleted, ')
          ..write('unlockedStoryBeatIdsJson: $unlockedStoryBeatIdsJson, ')
          ..write('viewedStoryBeatIdsJson: $viewedStoryBeatIdsJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    isFirstLaunch,
    onboardingCompleted,
    tutorialCompleted,
    unlockedStoryBeatIdsJson,
    viewedStoryBeatIdsJson,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerFlagRow &&
          other.id == this.id &&
          other.isFirstLaunch == this.isFirstLaunch &&
          other.onboardingCompleted == this.onboardingCompleted &&
          other.tutorialCompleted == this.tutorialCompleted &&
          other.unlockedStoryBeatIdsJson == this.unlockedStoryBeatIdsJson &&
          other.viewedStoryBeatIdsJson == this.viewedStoryBeatIdsJson &&
          other.updatedAt == this.updatedAt);
}

class PlayerFlagRowsCompanion extends UpdateCompanion<PlayerFlagRow> {
  final Value<String> id;
  final Value<bool> isFirstLaunch;
  final Value<bool> onboardingCompleted;
  final Value<bool> tutorialCompleted;
  final Value<String> unlockedStoryBeatIdsJson;
  final Value<String> viewedStoryBeatIdsJson;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PlayerFlagRowsCompanion({
    this.id = const Value.absent(),
    this.isFirstLaunch = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.tutorialCompleted = const Value.absent(),
    this.unlockedStoryBeatIdsJson = const Value.absent(),
    this.viewedStoryBeatIdsJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlayerFlagRowsCompanion.insert({
    required String id,
    this.isFirstLaunch = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.tutorialCompleted = const Value.absent(),
    this.unlockedStoryBeatIdsJson = const Value.absent(),
    this.viewedStoryBeatIdsJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<PlayerFlagRow> custom({
    Expression<String>? id,
    Expression<bool>? isFirstLaunch,
    Expression<bool>? onboardingCompleted,
    Expression<bool>? tutorialCompleted,
    Expression<String>? unlockedStoryBeatIdsJson,
    Expression<String>? viewedStoryBeatIdsJson,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isFirstLaunch != null) 'is_first_launch': isFirstLaunch,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
      if (tutorialCompleted != null) 'tutorial_completed': tutorialCompleted,
      if (unlockedStoryBeatIdsJson != null)
        'unlocked_story_beat_ids_json': unlockedStoryBeatIdsJson,
      if (viewedStoryBeatIdsJson != null)
        'viewed_story_beat_ids_json': viewedStoryBeatIdsJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlayerFlagRowsCompanion copyWith({
    Value<String>? id,
    Value<bool>? isFirstLaunch,
    Value<bool>? onboardingCompleted,
    Value<bool>? tutorialCompleted,
    Value<String>? unlockedStoryBeatIdsJson,
    Value<String>? viewedStoryBeatIdsJson,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PlayerFlagRowsCompanion(
      id: id ?? this.id,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      tutorialCompleted: tutorialCompleted ?? this.tutorialCompleted,
      unlockedStoryBeatIdsJson:
          unlockedStoryBeatIdsJson ?? this.unlockedStoryBeatIdsJson,
      viewedStoryBeatIdsJson:
          viewedStoryBeatIdsJson ?? this.viewedStoryBeatIdsJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (isFirstLaunch.present) {
      map['is_first_launch'] = Variable<bool>(isFirstLaunch.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (tutorialCompleted.present) {
      map['tutorial_completed'] = Variable<bool>(tutorialCompleted.value);
    }
    if (unlockedStoryBeatIdsJson.present) {
      map['unlocked_story_beat_ids_json'] = Variable<String>(
        unlockedStoryBeatIdsJson.value,
      );
    }
    if (viewedStoryBeatIdsJson.present) {
      map['viewed_story_beat_ids_json'] = Variable<String>(
        viewedStoryBeatIdsJson.value,
      );
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
    return (StringBuffer('PlayerFlagRowsCompanion(')
          ..write('id: $id, ')
          ..write('isFirstLaunch: $isFirstLaunch, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('tutorialCompleted: $tutorialCompleted, ')
          ..write('unlockedStoryBeatIdsJson: $unlockedStoryBeatIdsJson, ')
          ..write('viewedStoryBeatIdsJson: $viewedStoryBeatIdsJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlayerIdentityRowsTable extends PlayerIdentityRows
    with TableInfo<$PlayerIdentityRowsTable, PlayerIdentityRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayerIdentityRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPlayerIdMeta = const VerificationMeta(
    'localPlayerId',
  );
  @override
  late final GeneratedColumn<String> localPlayerId = GeneratedColumn<String>(
    'local_player_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firebaseUidMeta = const VerificationMeta(
    'firebaseUid',
  );
  @override
  late final GeneratedColumn<String> firebaseUid = GeneratedColumn<String>(
    'firebase_uid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _identityStateMeta = const VerificationMeta(
    'identityState',
  );
  @override
  late final GeneratedColumn<String> identityState = GeneratedColumn<String>(
    'identity_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('offlineLocalOnly'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _cloudMigrationVersionMeta =
      const VerificationMeta('cloudMigrationVersion');
  @override
  late final GeneratedColumn<int> cloudMigrationVersion = GeneratedColumn<int>(
    'cloud_migration_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cloudMigrationCompletedAtMeta =
      const VerificationMeta('cloudMigrationCompletedAt');
  @override
  late final GeneratedColumn<DateTime> cloudMigrationCompletedAt =
      GeneratedColumn<DateTime>(
        'cloud_migration_completed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    localPlayerId,
    firebaseUid,
    identityState,
    createdAt,
    cloudMigrationVersion,
    cloudMigrationCompletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'player_identity_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlayerIdentityRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('local_player_id')) {
      context.handle(
        _localPlayerIdMeta,
        localPlayerId.isAcceptableOrUnknown(
          data['local_player_id']!,
          _localPlayerIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localPlayerIdMeta);
    }
    if (data.containsKey('firebase_uid')) {
      context.handle(
        _firebaseUidMeta,
        firebaseUid.isAcceptableOrUnknown(
          data['firebase_uid']!,
          _firebaseUidMeta,
        ),
      );
    }
    if (data.containsKey('identity_state')) {
      context.handle(
        _identityStateMeta,
        identityState.isAcceptableOrUnknown(
          data['identity_state']!,
          _identityStateMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('cloud_migration_version')) {
      context.handle(
        _cloudMigrationVersionMeta,
        cloudMigrationVersion.isAcceptableOrUnknown(
          data['cloud_migration_version']!,
          _cloudMigrationVersionMeta,
        ),
      );
    }
    if (data.containsKey('cloud_migration_completed_at')) {
      context.handle(
        _cloudMigrationCompletedAtMeta,
        cloudMigrationCompletedAt.isAcceptableOrUnknown(
          data['cloud_migration_completed_at']!,
          _cloudMigrationCompletedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayerIdentityRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerIdentityRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      localPlayerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_player_id'],
      )!,
      firebaseUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}firebase_uid'],
      ),
      identityState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identity_state'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      cloudMigrationVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cloud_migration_version'],
      )!,
      cloudMigrationCompletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cloud_migration_completed_at'],
      ),
    );
  }

  @override
  $PlayerIdentityRowsTable createAlias(String alias) {
    return $PlayerIdentityRowsTable(attachedDatabase, alias);
  }
}

class PlayerIdentityRow extends DataClass
    implements Insertable<PlayerIdentityRow> {
  final String id;
  final String localPlayerId;
  final String? firebaseUid;
  final String identityState;
  final DateTime createdAt;
  final int cloudMigrationVersion;
  final DateTime? cloudMigrationCompletedAt;
  const PlayerIdentityRow({
    required this.id,
    required this.localPlayerId,
    this.firebaseUid,
    required this.identityState,
    required this.createdAt,
    required this.cloudMigrationVersion,
    this.cloudMigrationCompletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['local_player_id'] = Variable<String>(localPlayerId);
    if (!nullToAbsent || firebaseUid != null) {
      map['firebase_uid'] = Variable<String>(firebaseUid);
    }
    map['identity_state'] = Variable<String>(identityState);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['cloud_migration_version'] = Variable<int>(cloudMigrationVersion);
    if (!nullToAbsent || cloudMigrationCompletedAt != null) {
      map['cloud_migration_completed_at'] = Variable<DateTime>(
        cloudMigrationCompletedAt,
      );
    }
    return map;
  }

  PlayerIdentityRowsCompanion toCompanion(bool nullToAbsent) {
    return PlayerIdentityRowsCompanion(
      id: Value(id),
      localPlayerId: Value(localPlayerId),
      firebaseUid: firebaseUid == null && nullToAbsent
          ? const Value.absent()
          : Value(firebaseUid),
      identityState: Value(identityState),
      createdAt: Value(createdAt),
      cloudMigrationVersion: Value(cloudMigrationVersion),
      cloudMigrationCompletedAt:
          cloudMigrationCompletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(cloudMigrationCompletedAt),
    );
  }

  factory PlayerIdentityRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerIdentityRow(
      id: serializer.fromJson<String>(json['id']),
      localPlayerId: serializer.fromJson<String>(json['localPlayerId']),
      firebaseUid: serializer.fromJson<String?>(json['firebaseUid']),
      identityState: serializer.fromJson<String>(json['identityState']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      cloudMigrationVersion: serializer.fromJson<int>(
        json['cloudMigrationVersion'],
      ),
      cloudMigrationCompletedAt: serializer.fromJson<DateTime?>(
        json['cloudMigrationCompletedAt'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'localPlayerId': serializer.toJson<String>(localPlayerId),
      'firebaseUid': serializer.toJson<String?>(firebaseUid),
      'identityState': serializer.toJson<String>(identityState),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'cloudMigrationVersion': serializer.toJson<int>(cloudMigrationVersion),
      'cloudMigrationCompletedAt': serializer.toJson<DateTime?>(
        cloudMigrationCompletedAt,
      ),
    };
  }

  PlayerIdentityRow copyWith({
    String? id,
    String? localPlayerId,
    Value<String?> firebaseUid = const Value.absent(),
    String? identityState,
    DateTime? createdAt,
    int? cloudMigrationVersion,
    Value<DateTime?> cloudMigrationCompletedAt = const Value.absent(),
  }) => PlayerIdentityRow(
    id: id ?? this.id,
    localPlayerId: localPlayerId ?? this.localPlayerId,
    firebaseUid: firebaseUid.present ? firebaseUid.value : this.firebaseUid,
    identityState: identityState ?? this.identityState,
    createdAt: createdAt ?? this.createdAt,
    cloudMigrationVersion: cloudMigrationVersion ?? this.cloudMigrationVersion,
    cloudMigrationCompletedAt: cloudMigrationCompletedAt.present
        ? cloudMigrationCompletedAt.value
        : this.cloudMigrationCompletedAt,
  );
  PlayerIdentityRow copyWithCompanion(PlayerIdentityRowsCompanion data) {
    return PlayerIdentityRow(
      id: data.id.present ? data.id.value : this.id,
      localPlayerId: data.localPlayerId.present
          ? data.localPlayerId.value
          : this.localPlayerId,
      firebaseUid: data.firebaseUid.present
          ? data.firebaseUid.value
          : this.firebaseUid,
      identityState: data.identityState.present
          ? data.identityState.value
          : this.identityState,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      cloudMigrationVersion: data.cloudMigrationVersion.present
          ? data.cloudMigrationVersion.value
          : this.cloudMigrationVersion,
      cloudMigrationCompletedAt: data.cloudMigrationCompletedAt.present
          ? data.cloudMigrationCompletedAt.value
          : this.cloudMigrationCompletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerIdentityRow(')
          ..write('id: $id, ')
          ..write('localPlayerId: $localPlayerId, ')
          ..write('firebaseUid: $firebaseUid, ')
          ..write('identityState: $identityState, ')
          ..write('createdAt: $createdAt, ')
          ..write('cloudMigrationVersion: $cloudMigrationVersion, ')
          ..write('cloudMigrationCompletedAt: $cloudMigrationCompletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    localPlayerId,
    firebaseUid,
    identityState,
    createdAt,
    cloudMigrationVersion,
    cloudMigrationCompletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerIdentityRow &&
          other.id == this.id &&
          other.localPlayerId == this.localPlayerId &&
          other.firebaseUid == this.firebaseUid &&
          other.identityState == this.identityState &&
          other.createdAt == this.createdAt &&
          other.cloudMigrationVersion == this.cloudMigrationVersion &&
          other.cloudMigrationCompletedAt == this.cloudMigrationCompletedAt);
}

class PlayerIdentityRowsCompanion extends UpdateCompanion<PlayerIdentityRow> {
  final Value<String> id;
  final Value<String> localPlayerId;
  final Value<String?> firebaseUid;
  final Value<String> identityState;
  final Value<DateTime> createdAt;
  final Value<int> cloudMigrationVersion;
  final Value<DateTime?> cloudMigrationCompletedAt;
  final Value<int> rowid;
  const PlayerIdentityRowsCompanion({
    this.id = const Value.absent(),
    this.localPlayerId = const Value.absent(),
    this.firebaseUid = const Value.absent(),
    this.identityState = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.cloudMigrationVersion = const Value.absent(),
    this.cloudMigrationCompletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlayerIdentityRowsCompanion.insert({
    required String id,
    required String localPlayerId,
    this.firebaseUid = const Value.absent(),
    this.identityState = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.cloudMigrationVersion = const Value.absent(),
    this.cloudMigrationCompletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       localPlayerId = Value(localPlayerId);
  static Insertable<PlayerIdentityRow> custom({
    Expression<String>? id,
    Expression<String>? localPlayerId,
    Expression<String>? firebaseUid,
    Expression<String>? identityState,
    Expression<DateTime>? createdAt,
    Expression<int>? cloudMigrationVersion,
    Expression<DateTime>? cloudMigrationCompletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localPlayerId != null) 'local_player_id': localPlayerId,
      if (firebaseUid != null) 'firebase_uid': firebaseUid,
      if (identityState != null) 'identity_state': identityState,
      if (createdAt != null) 'created_at': createdAt,
      if (cloudMigrationVersion != null)
        'cloud_migration_version': cloudMigrationVersion,
      if (cloudMigrationCompletedAt != null)
        'cloud_migration_completed_at': cloudMigrationCompletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlayerIdentityRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? localPlayerId,
    Value<String?>? firebaseUid,
    Value<String>? identityState,
    Value<DateTime>? createdAt,
    Value<int>? cloudMigrationVersion,
    Value<DateTime?>? cloudMigrationCompletedAt,
    Value<int>? rowid,
  }) {
    return PlayerIdentityRowsCompanion(
      id: id ?? this.id,
      localPlayerId: localPlayerId ?? this.localPlayerId,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      identityState: identityState ?? this.identityState,
      createdAt: createdAt ?? this.createdAt,
      cloudMigrationVersion:
          cloudMigrationVersion ?? this.cloudMigrationVersion,
      cloudMigrationCompletedAt:
          cloudMigrationCompletedAt ?? this.cloudMigrationCompletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (localPlayerId.present) {
      map['local_player_id'] = Variable<String>(localPlayerId.value);
    }
    if (firebaseUid.present) {
      map['firebase_uid'] = Variable<String>(firebaseUid.value);
    }
    if (identityState.present) {
      map['identity_state'] = Variable<String>(identityState.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (cloudMigrationVersion.present) {
      map['cloud_migration_version'] = Variable<int>(
        cloudMigrationVersion.value,
      );
    }
    if (cloudMigrationCompletedAt.present) {
      map['cloud_migration_completed_at'] = Variable<DateTime>(
        cloudMigrationCompletedAt.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayerIdentityRowsCompanion(')
          ..write('id: $id, ')
          ..write('localPlayerId: $localPlayerId, ')
          ..write('firebaseUid: $firebaseUid, ')
          ..write('identityState: $identityState, ')
          ..write('createdAt: $createdAt, ')
          ..write('cloudMigrationVersion: $cloudMigrationVersion, ')
          ..write('cloudMigrationCompletedAt: $cloudMigrationCompletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataRowsTable extends SyncMetadataRows
    with TableInfo<$SyncMetadataRowsTable, SyncMetadataRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSuccessfulSyncAtMeta =
      const VerificationMeta('lastSuccessfulSyncAt');
  @override
  late final GeneratedColumn<DateTime> lastSuccessfulSyncAt =
      GeneratedColumn<DateTime>(
        'last_successful_sync_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastCloudRevisionMeta = const VerificationMeta(
    'lastCloudRevision',
  );
  @override
  late final GeneratedColumn<int> lastCloudRevision = GeneratedColumn<int>(
    'last_cloud_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pendingOperationsCountMeta =
      const VerificationMeta('pendingOperationsCount');
  @override
  late final GeneratedColumn<int> pendingOperationsCount = GeneratedColumn<int>(
    'pending_operations_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastSyncErrorCodeMeta = const VerificationMeta(
    'lastSyncErrorCode',
  );
  @override
  late final GeneratedColumn<String> lastSyncErrorCode =
      GeneratedColumn<String>(
        'last_sync_error_code',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _identityUidMeta = const VerificationMeta(
    'identityUid',
  );
  @override
  late final GeneratedColumn<String> identityUid = GeneratedColumn<String>(
    'identity_uid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncSchemaVersionMeta = const VerificationMeta(
    'syncSchemaVersion',
  );
  @override
  late final GeneratedColumn<int> syncSchemaVersion = GeneratedColumn<int>(
    'sync_schema_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lastSuccessfulSyncAt,
    lastCloudRevision,
    pendingOperationsCount,
    lastSyncErrorCode,
    identityUid,
    syncSchemaVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetadataRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('last_successful_sync_at')) {
      context.handle(
        _lastSuccessfulSyncAtMeta,
        lastSuccessfulSyncAt.isAcceptableOrUnknown(
          data['last_successful_sync_at']!,
          _lastSuccessfulSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('last_cloud_revision')) {
      context.handle(
        _lastCloudRevisionMeta,
        lastCloudRevision.isAcceptableOrUnknown(
          data['last_cloud_revision']!,
          _lastCloudRevisionMeta,
        ),
      );
    }
    if (data.containsKey('pending_operations_count')) {
      context.handle(
        _pendingOperationsCountMeta,
        pendingOperationsCount.isAcceptableOrUnknown(
          data['pending_operations_count']!,
          _pendingOperationsCountMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_error_code')) {
      context.handle(
        _lastSyncErrorCodeMeta,
        lastSyncErrorCode.isAcceptableOrUnknown(
          data['last_sync_error_code']!,
          _lastSyncErrorCodeMeta,
        ),
      );
    }
    if (data.containsKey('identity_uid')) {
      context.handle(
        _identityUidMeta,
        identityUid.isAcceptableOrUnknown(
          data['identity_uid']!,
          _identityUidMeta,
        ),
      );
    }
    if (data.containsKey('sync_schema_version')) {
      context.handle(
        _syncSchemaVersionMeta,
        syncSchemaVersion.isAcceptableOrUnknown(
          data['sync_schema_version']!,
          _syncSchemaVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncMetadataRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadataRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      lastSuccessfulSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_successful_sync_at'],
      ),
      lastCloudRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_cloud_revision'],
      )!,
      pendingOperationsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pending_operations_count'],
      )!,
      lastSyncErrorCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_sync_error_code'],
      ),
      identityUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identity_uid'],
      ),
      syncSchemaVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_schema_version'],
      )!,
    );
  }

  @override
  $SyncMetadataRowsTable createAlias(String alias) {
    return $SyncMetadataRowsTable(attachedDatabase, alias);
  }
}

class SyncMetadataRow extends DataClass implements Insertable<SyncMetadataRow> {
  final String id;
  final DateTime? lastSuccessfulSyncAt;
  final int lastCloudRevision;
  final int pendingOperationsCount;
  final String? lastSyncErrorCode;
  final String? identityUid;
  final int syncSchemaVersion;
  const SyncMetadataRow({
    required this.id,
    this.lastSuccessfulSyncAt,
    required this.lastCloudRevision,
    required this.pendingOperationsCount,
    this.lastSyncErrorCode,
    this.identityUid,
    required this.syncSchemaVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || lastSuccessfulSyncAt != null) {
      map['last_successful_sync_at'] = Variable<DateTime>(lastSuccessfulSyncAt);
    }
    map['last_cloud_revision'] = Variable<int>(lastCloudRevision);
    map['pending_operations_count'] = Variable<int>(pendingOperationsCount);
    if (!nullToAbsent || lastSyncErrorCode != null) {
      map['last_sync_error_code'] = Variable<String>(lastSyncErrorCode);
    }
    if (!nullToAbsent || identityUid != null) {
      map['identity_uid'] = Variable<String>(identityUid);
    }
    map['sync_schema_version'] = Variable<int>(syncSchemaVersion);
    return map;
  }

  SyncMetadataRowsCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataRowsCompanion(
      id: Value(id),
      lastSuccessfulSyncAt: lastSuccessfulSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSuccessfulSyncAt),
      lastCloudRevision: Value(lastCloudRevision),
      pendingOperationsCount: Value(pendingOperationsCount),
      lastSyncErrorCode: lastSyncErrorCode == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncErrorCode),
      identityUid: identityUid == null && nullToAbsent
          ? const Value.absent()
          : Value(identityUid),
      syncSchemaVersion: Value(syncSchemaVersion),
    );
  }

  factory SyncMetadataRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadataRow(
      id: serializer.fromJson<String>(json['id']),
      lastSuccessfulSyncAt: serializer.fromJson<DateTime?>(
        json['lastSuccessfulSyncAt'],
      ),
      lastCloudRevision: serializer.fromJson<int>(json['lastCloudRevision']),
      pendingOperationsCount: serializer.fromJson<int>(
        json['pendingOperationsCount'],
      ),
      lastSyncErrorCode: serializer.fromJson<String?>(
        json['lastSyncErrorCode'],
      ),
      identityUid: serializer.fromJson<String?>(json['identityUid']),
      syncSchemaVersion: serializer.fromJson<int>(json['syncSchemaVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lastSuccessfulSyncAt': serializer.toJson<DateTime?>(
        lastSuccessfulSyncAt,
      ),
      'lastCloudRevision': serializer.toJson<int>(lastCloudRevision),
      'pendingOperationsCount': serializer.toJson<int>(pendingOperationsCount),
      'lastSyncErrorCode': serializer.toJson<String?>(lastSyncErrorCode),
      'identityUid': serializer.toJson<String?>(identityUid),
      'syncSchemaVersion': serializer.toJson<int>(syncSchemaVersion),
    };
  }

  SyncMetadataRow copyWith({
    String? id,
    Value<DateTime?> lastSuccessfulSyncAt = const Value.absent(),
    int? lastCloudRevision,
    int? pendingOperationsCount,
    Value<String?> lastSyncErrorCode = const Value.absent(),
    Value<String?> identityUid = const Value.absent(),
    int? syncSchemaVersion,
  }) => SyncMetadataRow(
    id: id ?? this.id,
    lastSuccessfulSyncAt: lastSuccessfulSyncAt.present
        ? lastSuccessfulSyncAt.value
        : this.lastSuccessfulSyncAt,
    lastCloudRevision: lastCloudRevision ?? this.lastCloudRevision,
    pendingOperationsCount:
        pendingOperationsCount ?? this.pendingOperationsCount,
    lastSyncErrorCode: lastSyncErrorCode.present
        ? lastSyncErrorCode.value
        : this.lastSyncErrorCode,
    identityUid: identityUid.present ? identityUid.value : this.identityUid,
    syncSchemaVersion: syncSchemaVersion ?? this.syncSchemaVersion,
  );
  SyncMetadataRow copyWithCompanion(SyncMetadataRowsCompanion data) {
    return SyncMetadataRow(
      id: data.id.present ? data.id.value : this.id,
      lastSuccessfulSyncAt: data.lastSuccessfulSyncAt.present
          ? data.lastSuccessfulSyncAt.value
          : this.lastSuccessfulSyncAt,
      lastCloudRevision: data.lastCloudRevision.present
          ? data.lastCloudRevision.value
          : this.lastCloudRevision,
      pendingOperationsCount: data.pendingOperationsCount.present
          ? data.pendingOperationsCount.value
          : this.pendingOperationsCount,
      lastSyncErrorCode: data.lastSyncErrorCode.present
          ? data.lastSyncErrorCode.value
          : this.lastSyncErrorCode,
      identityUid: data.identityUid.present
          ? data.identityUid.value
          : this.identityUid,
      syncSchemaVersion: data.syncSchemaVersion.present
          ? data.syncSchemaVersion.value
          : this.syncSchemaVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataRow(')
          ..write('id: $id, ')
          ..write('lastSuccessfulSyncAt: $lastSuccessfulSyncAt, ')
          ..write('lastCloudRevision: $lastCloudRevision, ')
          ..write('pendingOperationsCount: $pendingOperationsCount, ')
          ..write('lastSyncErrorCode: $lastSyncErrorCode, ')
          ..write('identityUid: $identityUid, ')
          ..write('syncSchemaVersion: $syncSchemaVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    lastSuccessfulSyncAt,
    lastCloudRevision,
    pendingOperationsCount,
    lastSyncErrorCode,
    identityUid,
    syncSchemaVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadataRow &&
          other.id == this.id &&
          other.lastSuccessfulSyncAt == this.lastSuccessfulSyncAt &&
          other.lastCloudRevision == this.lastCloudRevision &&
          other.pendingOperationsCount == this.pendingOperationsCount &&
          other.lastSyncErrorCode == this.lastSyncErrorCode &&
          other.identityUid == this.identityUid &&
          other.syncSchemaVersion == this.syncSchemaVersion);
}

class SyncMetadataRowsCompanion extends UpdateCompanion<SyncMetadataRow> {
  final Value<String> id;
  final Value<DateTime?> lastSuccessfulSyncAt;
  final Value<int> lastCloudRevision;
  final Value<int> pendingOperationsCount;
  final Value<String?> lastSyncErrorCode;
  final Value<String?> identityUid;
  final Value<int> syncSchemaVersion;
  final Value<int> rowid;
  const SyncMetadataRowsCompanion({
    this.id = const Value.absent(),
    this.lastSuccessfulSyncAt = const Value.absent(),
    this.lastCloudRevision = const Value.absent(),
    this.pendingOperationsCount = const Value.absent(),
    this.lastSyncErrorCode = const Value.absent(),
    this.identityUid = const Value.absent(),
    this.syncSchemaVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetadataRowsCompanion.insert({
    required String id,
    this.lastSuccessfulSyncAt = const Value.absent(),
    this.lastCloudRevision = const Value.absent(),
    this.pendingOperationsCount = const Value.absent(),
    this.lastSyncErrorCode = const Value.absent(),
    this.identityUid = const Value.absent(),
    this.syncSchemaVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<SyncMetadataRow> custom({
    Expression<String>? id,
    Expression<DateTime>? lastSuccessfulSyncAt,
    Expression<int>? lastCloudRevision,
    Expression<int>? pendingOperationsCount,
    Expression<String>? lastSyncErrorCode,
    Expression<String>? identityUid,
    Expression<int>? syncSchemaVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastSuccessfulSyncAt != null)
        'last_successful_sync_at': lastSuccessfulSyncAt,
      if (lastCloudRevision != null) 'last_cloud_revision': lastCloudRevision,
      if (pendingOperationsCount != null)
        'pending_operations_count': pendingOperationsCount,
      if (lastSyncErrorCode != null) 'last_sync_error_code': lastSyncErrorCode,
      if (identityUid != null) 'identity_uid': identityUid,
      if (syncSchemaVersion != null) 'sync_schema_version': syncSchemaVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetadataRowsCompanion copyWith({
    Value<String>? id,
    Value<DateTime?>? lastSuccessfulSyncAt,
    Value<int>? lastCloudRevision,
    Value<int>? pendingOperationsCount,
    Value<String?>? lastSyncErrorCode,
    Value<String?>? identityUid,
    Value<int>? syncSchemaVersion,
    Value<int>? rowid,
  }) {
    return SyncMetadataRowsCompanion(
      id: id ?? this.id,
      lastSuccessfulSyncAt: lastSuccessfulSyncAt ?? this.lastSuccessfulSyncAt,
      lastCloudRevision: lastCloudRevision ?? this.lastCloudRevision,
      pendingOperationsCount:
          pendingOperationsCount ?? this.pendingOperationsCount,
      lastSyncErrorCode: lastSyncErrorCode ?? this.lastSyncErrorCode,
      identityUid: identityUid ?? this.identityUid,
      syncSchemaVersion: syncSchemaVersion ?? this.syncSchemaVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lastSuccessfulSyncAt.present) {
      map['last_successful_sync_at'] = Variable<DateTime>(
        lastSuccessfulSyncAt.value,
      );
    }
    if (lastCloudRevision.present) {
      map['last_cloud_revision'] = Variable<int>(lastCloudRevision.value);
    }
    if (pendingOperationsCount.present) {
      map['pending_operations_count'] = Variable<int>(
        pendingOperationsCount.value,
      );
    }
    if (lastSyncErrorCode.present) {
      map['last_sync_error_code'] = Variable<String>(lastSyncErrorCode.value);
    }
    if (identityUid.present) {
      map['identity_uid'] = Variable<String>(identityUid.value);
    }
    if (syncSchemaVersion.present) {
      map['sync_schema_version'] = Variable<int>(syncSchemaVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataRowsCompanion(')
          ..write('id: $id, ')
          ..write('lastSuccessfulSyncAt: $lastSuccessfulSyncAt, ')
          ..write('lastCloudRevision: $lastCloudRevision, ')
          ..write('pendingOperationsCount: $pendingOperationsCount, ')
          ..write('lastSyncErrorCode: $lastSyncErrorCode, ')
          ..write('identityUid: $identityUid, ')
          ..write('syncSchemaVersion: $syncSchemaVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOperationRowsTable extends SyncOperationRows
    with TableInfo<$SyncOperationRowsTable, SyncOperationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOperationRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _operationIdMeta = const VerificationMeta(
    'operationId',
  );
  @override
  late final GeneratedColumn<String> operationId = GeneratedColumn<String>(
    'operation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationTypeMeta = const VerificationMeta(
    'operationType',
  );
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
    'operation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _nextRetryAtMeta = const VerificationMeta(
    'nextRetryAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextRetryAt = GeneratedColumn<DateTime>(
    'next_retry_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    operationId,
    operationType,
    payloadJson,
    createdAt,
    idempotencyKey,
    attemptCount,
    status,
    nextRetryAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_operation_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncOperationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('operation_id')) {
      context.handle(
        _operationIdMeta,
        operationId.isAcceptableOrUnknown(
          data['operation_id']!,
          _operationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationIdMeta);
    }
    if (data.containsKey('operation_type')) {
      context.handle(
        _operationTypeMeta,
        operationType.isAcceptableOrUnknown(
          data['operation_type']!,
          _operationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationTypeMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('next_retry_at')) {
      context.handle(
        _nextRetryAtMeta,
        nextRetryAt.isAcceptableOrUnknown(
          data['next_retry_at']!,
          _nextRetryAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {operationId};
  @override
  SyncOperationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOperationRow(
      operationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_id'],
      )!,
      operationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_type'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      nextRetryAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_retry_at'],
      ),
    );
  }

  @override
  $SyncOperationRowsTable createAlias(String alias) {
    return $SyncOperationRowsTable(attachedDatabase, alias);
  }
}

class SyncOperationRow extends DataClass
    implements Insertable<SyncOperationRow> {
  final String operationId;
  final String operationType;
  final String payloadJson;
  final DateTime createdAt;
  final String idempotencyKey;
  final int attemptCount;
  final String status;
  final DateTime? nextRetryAt;
  const SyncOperationRow({
    required this.operationId,
    required this.operationType,
    required this.payloadJson,
    required this.createdAt,
    required this.idempotencyKey,
    required this.attemptCount,
    required this.status,
    this.nextRetryAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['operation_id'] = Variable<String>(operationId);
    map['operation_type'] = Variable<String>(operationType);
    map['payload_json'] = Variable<String>(payloadJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['attempt_count'] = Variable<int>(attemptCount);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || nextRetryAt != null) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt);
    }
    return map;
  }

  SyncOperationRowsCompanion toCompanion(bool nullToAbsent) {
    return SyncOperationRowsCompanion(
      operationId: Value(operationId),
      operationType: Value(operationType),
      payloadJson: Value(payloadJson),
      createdAt: Value(createdAt),
      idempotencyKey: Value(idempotencyKey),
      attemptCount: Value(attemptCount),
      status: Value(status),
      nextRetryAt: nextRetryAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextRetryAt),
    );
  }

  factory SyncOperationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOperationRow(
      operationId: serializer.fromJson<String>(json['operationId']),
      operationType: serializer.fromJson<String>(json['operationType']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      status: serializer.fromJson<String>(json['status']),
      nextRetryAt: serializer.fromJson<DateTime?>(json['nextRetryAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'operationId': serializer.toJson<String>(operationId),
      'operationType': serializer.toJson<String>(operationType),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'status': serializer.toJson<String>(status),
      'nextRetryAt': serializer.toJson<DateTime?>(nextRetryAt),
    };
  }

  SyncOperationRow copyWith({
    String? operationId,
    String? operationType,
    String? payloadJson,
    DateTime? createdAt,
    String? idempotencyKey,
    int? attemptCount,
    String? status,
    Value<DateTime?> nextRetryAt = const Value.absent(),
  }) => SyncOperationRow(
    operationId: operationId ?? this.operationId,
    operationType: operationType ?? this.operationType,
    payloadJson: payloadJson ?? this.payloadJson,
    createdAt: createdAt ?? this.createdAt,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    attemptCount: attemptCount ?? this.attemptCount,
    status: status ?? this.status,
    nextRetryAt: nextRetryAt.present ? nextRetryAt.value : this.nextRetryAt,
  );
  SyncOperationRow copyWithCompanion(SyncOperationRowsCompanion data) {
    return SyncOperationRow(
      operationId: data.operationId.present
          ? data.operationId.value
          : this.operationId,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      status: data.status.present ? data.status.value : this.status,
      nextRetryAt: data.nextRetryAt.present
          ? data.nextRetryAt.value
          : this.nextRetryAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOperationRow(')
          ..write('operationId: $operationId, ')
          ..write('operationType: $operationType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('status: $status, ')
          ..write('nextRetryAt: $nextRetryAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    operationId,
    operationType,
    payloadJson,
    createdAt,
    idempotencyKey,
    attemptCount,
    status,
    nextRetryAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOperationRow &&
          other.operationId == this.operationId &&
          other.operationType == this.operationType &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt &&
          other.idempotencyKey == this.idempotencyKey &&
          other.attemptCount == this.attemptCount &&
          other.status == this.status &&
          other.nextRetryAt == this.nextRetryAt);
}

class SyncOperationRowsCompanion extends UpdateCompanion<SyncOperationRow> {
  final Value<String> operationId;
  final Value<String> operationType;
  final Value<String> payloadJson;
  final Value<DateTime> createdAt;
  final Value<String> idempotencyKey;
  final Value<int> attemptCount;
  final Value<String> status;
  final Value<DateTime?> nextRetryAt;
  final Value<int> rowid;
  const SyncOperationRowsCompanion({
    this.operationId = const Value.absent(),
    this.operationType = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.status = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOperationRowsCompanion.insert({
    required String operationId,
    required String operationType,
    required String payloadJson,
    this.createdAt = const Value.absent(),
    required String idempotencyKey,
    this.attemptCount = const Value.absent(),
    this.status = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : operationId = Value(operationId),
       operationType = Value(operationType),
       payloadJson = Value(payloadJson),
       idempotencyKey = Value(idempotencyKey);
  static Insertable<SyncOperationRow> custom({
    Expression<String>? operationId,
    Expression<String>? operationType,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAt,
    Expression<String>? idempotencyKey,
    Expression<int>? attemptCount,
    Expression<String>? status,
    Expression<DateTime>? nextRetryAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (operationId != null) 'operation_id': operationId,
      if (operationType != null) 'operation_type': operationType,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (status != null) 'status': status,
      if (nextRetryAt != null) 'next_retry_at': nextRetryAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOperationRowsCompanion copyWith({
    Value<String>? operationId,
    Value<String>? operationType,
    Value<String>? payloadJson,
    Value<DateTime>? createdAt,
    Value<String>? idempotencyKey,
    Value<int>? attemptCount,
    Value<String>? status,
    Value<DateTime?>? nextRetryAt,
    Value<int>? rowid,
  }) {
    return SyncOperationRowsCompanion(
      operationId: operationId ?? this.operationId,
      operationType: operationType ?? this.operationType,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      attemptCount: attemptCount ?? this.attemptCount,
      status: status ?? this.status,
      nextRetryAt: nextRetryAt ?? this.nextRetryAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (operationId.present) {
      map['operation_id'] = Variable<String>(operationId.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (nextRetryAt.present) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOperationRowsCompanion(')
          ..write('operationId: $operationId, ')
          ..write('operationType: $operationType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('status: $status, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WalletCacheRowsTable extends WalletCacheRows
    with TableInfo<$WalletCacheRowsTable, WalletCacheRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletCacheRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firebaseUidMeta = const VerificationMeta(
    'firebaseUid',
  );
  @override
  late final GeneratedColumn<String> firebaseUid = GeneratedColumn<String>(
    'firebase_uid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coinBalanceMeta = const VerificationMeta(
    'coinBalance',
  );
  @override
  late final GeneratedColumn<int> coinBalance = GeneratedColumn<int>(
    'coin_balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hintBalanceMeta = const VerificationMeta(
    'hintBalance',
  );
  @override
  late final GeneratedColumn<int> hintBalance = GeneratedColumn<int>(
    'hint_balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pendingCoinDeltaMeta = const VerificationMeta(
    'pendingCoinDelta',
  );
  @override
  late final GeneratedColumn<int> pendingCoinDelta = GeneratedColumn<int>(
    'pending_coin_delta',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pendingHintDeltaMeta = const VerificationMeta(
    'pendingHintDelta',
  );
  @override
  late final GeneratedColumn<int> pendingHintDelta = GeneratedColumn<int>(
    'pending_hint_delta',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _walletRevisionMeta = const VerificationMeta(
    'walletRevision',
  );
  @override
  late final GeneratedColumn<int> walletRevision = GeneratedColumn<int>(
    'wallet_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastReconciledAtMeta = const VerificationMeta(
    'lastReconciledAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastReconciledAt =
      GeneratedColumn<DateTime>(
        'last_reconciled_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isStaleMeta = const VerificationMeta(
    'isStale',
  );
  @override
  late final GeneratedColumn<bool> isStale = GeneratedColumn<bool>(
    'is_stale',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_stale" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _walletSchemaVersionMeta =
      const VerificationMeta('walletSchemaVersion');
  @override
  late final GeneratedColumn<int> walletSchemaVersion = GeneratedColumn<int>(
    'wallet_schema_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    firebaseUid,
    coinBalance,
    hintBalance,
    pendingCoinDelta,
    pendingHintDelta,
    walletRevision,
    lastReconciledAt,
    isStale,
    walletSchemaVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_cache_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletCacheRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('firebase_uid')) {
      context.handle(
        _firebaseUidMeta,
        firebaseUid.isAcceptableOrUnknown(
          data['firebase_uid']!,
          _firebaseUidMeta,
        ),
      );
    }
    if (data.containsKey('coin_balance')) {
      context.handle(
        _coinBalanceMeta,
        coinBalance.isAcceptableOrUnknown(
          data['coin_balance']!,
          _coinBalanceMeta,
        ),
      );
    }
    if (data.containsKey('hint_balance')) {
      context.handle(
        _hintBalanceMeta,
        hintBalance.isAcceptableOrUnknown(
          data['hint_balance']!,
          _hintBalanceMeta,
        ),
      );
    }
    if (data.containsKey('pending_coin_delta')) {
      context.handle(
        _pendingCoinDeltaMeta,
        pendingCoinDelta.isAcceptableOrUnknown(
          data['pending_coin_delta']!,
          _pendingCoinDeltaMeta,
        ),
      );
    }
    if (data.containsKey('pending_hint_delta')) {
      context.handle(
        _pendingHintDeltaMeta,
        pendingHintDelta.isAcceptableOrUnknown(
          data['pending_hint_delta']!,
          _pendingHintDeltaMeta,
        ),
      );
    }
    if (data.containsKey('wallet_revision')) {
      context.handle(
        _walletRevisionMeta,
        walletRevision.isAcceptableOrUnknown(
          data['wallet_revision']!,
          _walletRevisionMeta,
        ),
      );
    }
    if (data.containsKey('last_reconciled_at')) {
      context.handle(
        _lastReconciledAtMeta,
        lastReconciledAt.isAcceptableOrUnknown(
          data['last_reconciled_at']!,
          _lastReconciledAtMeta,
        ),
      );
    }
    if (data.containsKey('is_stale')) {
      context.handle(
        _isStaleMeta,
        isStale.isAcceptableOrUnknown(data['is_stale']!, _isStaleMeta),
      );
    }
    if (data.containsKey('wallet_schema_version')) {
      context.handle(
        _walletSchemaVersionMeta,
        walletSchemaVersion.isAcceptableOrUnknown(
          data['wallet_schema_version']!,
          _walletSchemaVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletCacheRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletCacheRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      firebaseUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}firebase_uid'],
      ),
      coinBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}coin_balance'],
      )!,
      hintBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hint_balance'],
      )!,
      pendingCoinDelta: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pending_coin_delta'],
      )!,
      pendingHintDelta: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pending_hint_delta'],
      )!,
      walletRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_revision'],
      )!,
      lastReconciledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_reconciled_at'],
      ),
      isStale: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_stale'],
      )!,
      walletSchemaVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wallet_schema_version'],
      )!,
    );
  }

  @override
  $WalletCacheRowsTable createAlias(String alias) {
    return $WalletCacheRowsTable(attachedDatabase, alias);
  }
}

class WalletCacheRow extends DataClass implements Insertable<WalletCacheRow> {
  final String id;
  final String? firebaseUid;
  final int coinBalance;
  final int hintBalance;
  final int pendingCoinDelta;
  final int pendingHintDelta;
  final int walletRevision;
  final DateTime? lastReconciledAt;
  final bool isStale;
  final int walletSchemaVersion;
  const WalletCacheRow({
    required this.id,
    this.firebaseUid,
    required this.coinBalance,
    required this.hintBalance,
    required this.pendingCoinDelta,
    required this.pendingHintDelta,
    required this.walletRevision,
    this.lastReconciledAt,
    required this.isStale,
    required this.walletSchemaVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || firebaseUid != null) {
      map['firebase_uid'] = Variable<String>(firebaseUid);
    }
    map['coin_balance'] = Variable<int>(coinBalance);
    map['hint_balance'] = Variable<int>(hintBalance);
    map['pending_coin_delta'] = Variable<int>(pendingCoinDelta);
    map['pending_hint_delta'] = Variable<int>(pendingHintDelta);
    map['wallet_revision'] = Variable<int>(walletRevision);
    if (!nullToAbsent || lastReconciledAt != null) {
      map['last_reconciled_at'] = Variable<DateTime>(lastReconciledAt);
    }
    map['is_stale'] = Variable<bool>(isStale);
    map['wallet_schema_version'] = Variable<int>(walletSchemaVersion);
    return map;
  }

  WalletCacheRowsCompanion toCompanion(bool nullToAbsent) {
    return WalletCacheRowsCompanion(
      id: Value(id),
      firebaseUid: firebaseUid == null && nullToAbsent
          ? const Value.absent()
          : Value(firebaseUid),
      coinBalance: Value(coinBalance),
      hintBalance: Value(hintBalance),
      pendingCoinDelta: Value(pendingCoinDelta),
      pendingHintDelta: Value(pendingHintDelta),
      walletRevision: Value(walletRevision),
      lastReconciledAt: lastReconciledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReconciledAt),
      isStale: Value(isStale),
      walletSchemaVersion: Value(walletSchemaVersion),
    );
  }

  factory WalletCacheRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletCacheRow(
      id: serializer.fromJson<String>(json['id']),
      firebaseUid: serializer.fromJson<String?>(json['firebaseUid']),
      coinBalance: serializer.fromJson<int>(json['coinBalance']),
      hintBalance: serializer.fromJson<int>(json['hintBalance']),
      pendingCoinDelta: serializer.fromJson<int>(json['pendingCoinDelta']),
      pendingHintDelta: serializer.fromJson<int>(json['pendingHintDelta']),
      walletRevision: serializer.fromJson<int>(json['walletRevision']),
      lastReconciledAt: serializer.fromJson<DateTime?>(
        json['lastReconciledAt'],
      ),
      isStale: serializer.fromJson<bool>(json['isStale']),
      walletSchemaVersion: serializer.fromJson<int>(
        json['walletSchemaVersion'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'firebaseUid': serializer.toJson<String?>(firebaseUid),
      'coinBalance': serializer.toJson<int>(coinBalance),
      'hintBalance': serializer.toJson<int>(hintBalance),
      'pendingCoinDelta': serializer.toJson<int>(pendingCoinDelta),
      'pendingHintDelta': serializer.toJson<int>(pendingHintDelta),
      'walletRevision': serializer.toJson<int>(walletRevision),
      'lastReconciledAt': serializer.toJson<DateTime?>(lastReconciledAt),
      'isStale': serializer.toJson<bool>(isStale),
      'walletSchemaVersion': serializer.toJson<int>(walletSchemaVersion),
    };
  }

  WalletCacheRow copyWith({
    String? id,
    Value<String?> firebaseUid = const Value.absent(),
    int? coinBalance,
    int? hintBalance,
    int? pendingCoinDelta,
    int? pendingHintDelta,
    int? walletRevision,
    Value<DateTime?> lastReconciledAt = const Value.absent(),
    bool? isStale,
    int? walletSchemaVersion,
  }) => WalletCacheRow(
    id: id ?? this.id,
    firebaseUid: firebaseUid.present ? firebaseUid.value : this.firebaseUid,
    coinBalance: coinBalance ?? this.coinBalance,
    hintBalance: hintBalance ?? this.hintBalance,
    pendingCoinDelta: pendingCoinDelta ?? this.pendingCoinDelta,
    pendingHintDelta: pendingHintDelta ?? this.pendingHintDelta,
    walletRevision: walletRevision ?? this.walletRevision,
    lastReconciledAt: lastReconciledAt.present
        ? lastReconciledAt.value
        : this.lastReconciledAt,
    isStale: isStale ?? this.isStale,
    walletSchemaVersion: walletSchemaVersion ?? this.walletSchemaVersion,
  );
  WalletCacheRow copyWithCompanion(WalletCacheRowsCompanion data) {
    return WalletCacheRow(
      id: data.id.present ? data.id.value : this.id,
      firebaseUid: data.firebaseUid.present
          ? data.firebaseUid.value
          : this.firebaseUid,
      coinBalance: data.coinBalance.present
          ? data.coinBalance.value
          : this.coinBalance,
      hintBalance: data.hintBalance.present
          ? data.hintBalance.value
          : this.hintBalance,
      pendingCoinDelta: data.pendingCoinDelta.present
          ? data.pendingCoinDelta.value
          : this.pendingCoinDelta,
      pendingHintDelta: data.pendingHintDelta.present
          ? data.pendingHintDelta.value
          : this.pendingHintDelta,
      walletRevision: data.walletRevision.present
          ? data.walletRevision.value
          : this.walletRevision,
      lastReconciledAt: data.lastReconciledAt.present
          ? data.lastReconciledAt.value
          : this.lastReconciledAt,
      isStale: data.isStale.present ? data.isStale.value : this.isStale,
      walletSchemaVersion: data.walletSchemaVersion.present
          ? data.walletSchemaVersion.value
          : this.walletSchemaVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletCacheRow(')
          ..write('id: $id, ')
          ..write('firebaseUid: $firebaseUid, ')
          ..write('coinBalance: $coinBalance, ')
          ..write('hintBalance: $hintBalance, ')
          ..write('pendingCoinDelta: $pendingCoinDelta, ')
          ..write('pendingHintDelta: $pendingHintDelta, ')
          ..write('walletRevision: $walletRevision, ')
          ..write('lastReconciledAt: $lastReconciledAt, ')
          ..write('isStale: $isStale, ')
          ..write('walletSchemaVersion: $walletSchemaVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    firebaseUid,
    coinBalance,
    hintBalance,
    pendingCoinDelta,
    pendingHintDelta,
    walletRevision,
    lastReconciledAt,
    isStale,
    walletSchemaVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletCacheRow &&
          other.id == this.id &&
          other.firebaseUid == this.firebaseUid &&
          other.coinBalance == this.coinBalance &&
          other.hintBalance == this.hintBalance &&
          other.pendingCoinDelta == this.pendingCoinDelta &&
          other.pendingHintDelta == this.pendingHintDelta &&
          other.walletRevision == this.walletRevision &&
          other.lastReconciledAt == this.lastReconciledAt &&
          other.isStale == this.isStale &&
          other.walletSchemaVersion == this.walletSchemaVersion);
}

class WalletCacheRowsCompanion extends UpdateCompanion<WalletCacheRow> {
  final Value<String> id;
  final Value<String?> firebaseUid;
  final Value<int> coinBalance;
  final Value<int> hintBalance;
  final Value<int> pendingCoinDelta;
  final Value<int> pendingHintDelta;
  final Value<int> walletRevision;
  final Value<DateTime?> lastReconciledAt;
  final Value<bool> isStale;
  final Value<int> walletSchemaVersion;
  final Value<int> rowid;
  const WalletCacheRowsCompanion({
    this.id = const Value.absent(),
    this.firebaseUid = const Value.absent(),
    this.coinBalance = const Value.absent(),
    this.hintBalance = const Value.absent(),
    this.pendingCoinDelta = const Value.absent(),
    this.pendingHintDelta = const Value.absent(),
    this.walletRevision = const Value.absent(),
    this.lastReconciledAt = const Value.absent(),
    this.isStale = const Value.absent(),
    this.walletSchemaVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WalletCacheRowsCompanion.insert({
    required String id,
    this.firebaseUid = const Value.absent(),
    this.coinBalance = const Value.absent(),
    this.hintBalance = const Value.absent(),
    this.pendingCoinDelta = const Value.absent(),
    this.pendingHintDelta = const Value.absent(),
    this.walletRevision = const Value.absent(),
    this.lastReconciledAt = const Value.absent(),
    this.isStale = const Value.absent(),
    this.walletSchemaVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<WalletCacheRow> custom({
    Expression<String>? id,
    Expression<String>? firebaseUid,
    Expression<int>? coinBalance,
    Expression<int>? hintBalance,
    Expression<int>? pendingCoinDelta,
    Expression<int>? pendingHintDelta,
    Expression<int>? walletRevision,
    Expression<DateTime>? lastReconciledAt,
    Expression<bool>? isStale,
    Expression<int>? walletSchemaVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firebaseUid != null) 'firebase_uid': firebaseUid,
      if (coinBalance != null) 'coin_balance': coinBalance,
      if (hintBalance != null) 'hint_balance': hintBalance,
      if (pendingCoinDelta != null) 'pending_coin_delta': pendingCoinDelta,
      if (pendingHintDelta != null) 'pending_hint_delta': pendingHintDelta,
      if (walletRevision != null) 'wallet_revision': walletRevision,
      if (lastReconciledAt != null) 'last_reconciled_at': lastReconciledAt,
      if (isStale != null) 'is_stale': isStale,
      if (walletSchemaVersion != null)
        'wallet_schema_version': walletSchemaVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WalletCacheRowsCompanion copyWith({
    Value<String>? id,
    Value<String?>? firebaseUid,
    Value<int>? coinBalance,
    Value<int>? hintBalance,
    Value<int>? pendingCoinDelta,
    Value<int>? pendingHintDelta,
    Value<int>? walletRevision,
    Value<DateTime?>? lastReconciledAt,
    Value<bool>? isStale,
    Value<int>? walletSchemaVersion,
    Value<int>? rowid,
  }) {
    return WalletCacheRowsCompanion(
      id: id ?? this.id,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      coinBalance: coinBalance ?? this.coinBalance,
      hintBalance: hintBalance ?? this.hintBalance,
      pendingCoinDelta: pendingCoinDelta ?? this.pendingCoinDelta,
      pendingHintDelta: pendingHintDelta ?? this.pendingHintDelta,
      walletRevision: walletRevision ?? this.walletRevision,
      lastReconciledAt: lastReconciledAt ?? this.lastReconciledAt,
      isStale: isStale ?? this.isStale,
      walletSchemaVersion: walletSchemaVersion ?? this.walletSchemaVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (firebaseUid.present) {
      map['firebase_uid'] = Variable<String>(firebaseUid.value);
    }
    if (coinBalance.present) {
      map['coin_balance'] = Variable<int>(coinBalance.value);
    }
    if (hintBalance.present) {
      map['hint_balance'] = Variable<int>(hintBalance.value);
    }
    if (pendingCoinDelta.present) {
      map['pending_coin_delta'] = Variable<int>(pendingCoinDelta.value);
    }
    if (pendingHintDelta.present) {
      map['pending_hint_delta'] = Variable<int>(pendingHintDelta.value);
    }
    if (walletRevision.present) {
      map['wallet_revision'] = Variable<int>(walletRevision.value);
    }
    if (lastReconciledAt.present) {
      map['last_reconciled_at'] = Variable<DateTime>(lastReconciledAt.value);
    }
    if (isStale.present) {
      map['is_stale'] = Variable<bool>(isStale.value);
    }
    if (walletSchemaVersion.present) {
      map['wallet_schema_version'] = Variable<int>(walletSchemaVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletCacheRowsCompanion(')
          ..write('id: $id, ')
          ..write('firebaseUid: $firebaseUid, ')
          ..write('coinBalance: $coinBalance, ')
          ..write('hintBalance: $hintBalance, ')
          ..write('pendingCoinDelta: $pendingCoinDelta, ')
          ..write('pendingHintDelta: $pendingHintDelta, ')
          ..write('walletRevision: $walletRevision, ')
          ..write('lastReconciledAt: $lastReconciledAt, ')
          ..write('isStale: $isStale, ')
          ..write('walletSchemaVersion: $walletSchemaVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EconomyOperationRowsTable extends EconomyOperationRows
    with TableInfo<$EconomyOperationRowsTable, EconomyOperationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EconomyOperationRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _operationIdMeta = const VerificationMeta(
    'operationId',
  );
  @override
  late final GeneratedColumn<String> operationId = GeneratedColumn<String>(
    'operation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationTypeMeta = const VerificationMeta(
    'operationType',
  );
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
    'operation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _coinDeltaMeta = const VerificationMeta(
    'coinDelta',
  );
  @override
  late final GeneratedColumn<int> coinDelta = GeneratedColumn<int>(
    'coin_delta',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hintDeltaMeta = const VerificationMeta(
    'hintDelta',
  );
  @override
  late final GeneratedColumn<int> hintDelta = GeneratedColumn<int>(
    'hint_delta',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextRetryAtMeta = const VerificationMeta(
    'nextRetryAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextRetryAt = GeneratedColumn<DateTime>(
    'next_retry_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverTransactionIdMeta =
      const VerificationMeta('serverTransactionId');
  @override
  late final GeneratedColumn<String> serverTransactionId =
      GeneratedColumn<String>(
        'server_transaction_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    operationId,
    operationType,
    idempotencyKey,
    payloadJson,
    createdAt,
    coinDelta,
    hintDelta,
    status,
    attemptCount,
    nextRetryAt,
    serverTransactionId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'economy_operation_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<EconomyOperationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('operation_id')) {
      context.handle(
        _operationIdMeta,
        operationId.isAcceptableOrUnknown(
          data['operation_id']!,
          _operationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationIdMeta);
    }
    if (data.containsKey('operation_type')) {
      context.handle(
        _operationTypeMeta,
        operationType.isAcceptableOrUnknown(
          data['operation_type']!,
          _operationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationTypeMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('coin_delta')) {
      context.handle(
        _coinDeltaMeta,
        coinDelta.isAcceptableOrUnknown(data['coin_delta']!, _coinDeltaMeta),
      );
    }
    if (data.containsKey('hint_delta')) {
      context.handle(
        _hintDeltaMeta,
        hintDelta.isAcceptableOrUnknown(data['hint_delta']!, _hintDeltaMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('next_retry_at')) {
      context.handle(
        _nextRetryAtMeta,
        nextRetryAt.isAcceptableOrUnknown(
          data['next_retry_at']!,
          _nextRetryAtMeta,
        ),
      );
    }
    if (data.containsKey('server_transaction_id')) {
      context.handle(
        _serverTransactionIdMeta,
        serverTransactionId.isAcceptableOrUnknown(
          data['server_transaction_id']!,
          _serverTransactionIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {operationId};
  @override
  EconomyOperationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EconomyOperationRow(
      operationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_id'],
      )!,
      operationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_type'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      coinDelta: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}coin_delta'],
      )!,
      hintDelta: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hint_delta'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      nextRetryAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_retry_at'],
      ),
      serverTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_transaction_id'],
      ),
    );
  }

  @override
  $EconomyOperationRowsTable createAlias(String alias) {
    return $EconomyOperationRowsTable(attachedDatabase, alias);
  }
}

class EconomyOperationRow extends DataClass
    implements Insertable<EconomyOperationRow> {
  final String operationId;
  final String operationType;
  final String idempotencyKey;
  final String payloadJson;
  final DateTime createdAt;
  final int coinDelta;
  final int hintDelta;
  final String status;
  final int attemptCount;
  final DateTime? nextRetryAt;
  final String? serverTransactionId;
  const EconomyOperationRow({
    required this.operationId,
    required this.operationType,
    required this.idempotencyKey,
    required this.payloadJson,
    required this.createdAt,
    required this.coinDelta,
    required this.hintDelta,
    required this.status,
    required this.attemptCount,
    this.nextRetryAt,
    this.serverTransactionId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['operation_id'] = Variable<String>(operationId);
    map['operation_type'] = Variable<String>(operationType);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['payload_json'] = Variable<String>(payloadJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['coin_delta'] = Variable<int>(coinDelta);
    map['hint_delta'] = Variable<int>(hintDelta);
    map['status'] = Variable<String>(status);
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || nextRetryAt != null) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt);
    }
    if (!nullToAbsent || serverTransactionId != null) {
      map['server_transaction_id'] = Variable<String>(serverTransactionId);
    }
    return map;
  }

  EconomyOperationRowsCompanion toCompanion(bool nullToAbsent) {
    return EconomyOperationRowsCompanion(
      operationId: Value(operationId),
      operationType: Value(operationType),
      idempotencyKey: Value(idempotencyKey),
      payloadJson: Value(payloadJson),
      createdAt: Value(createdAt),
      coinDelta: Value(coinDelta),
      hintDelta: Value(hintDelta),
      status: Value(status),
      attemptCount: Value(attemptCount),
      nextRetryAt: nextRetryAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextRetryAt),
      serverTransactionId: serverTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverTransactionId),
    );
  }

  factory EconomyOperationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EconomyOperationRow(
      operationId: serializer.fromJson<String>(json['operationId']),
      operationType: serializer.fromJson<String>(json['operationType']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      coinDelta: serializer.fromJson<int>(json['coinDelta']),
      hintDelta: serializer.fromJson<int>(json['hintDelta']),
      status: serializer.fromJson<String>(json['status']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      nextRetryAt: serializer.fromJson<DateTime?>(json['nextRetryAt']),
      serverTransactionId: serializer.fromJson<String?>(
        json['serverTransactionId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'operationId': serializer.toJson<String>(operationId),
      'operationType': serializer.toJson<String>(operationType),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'coinDelta': serializer.toJson<int>(coinDelta),
      'hintDelta': serializer.toJson<int>(hintDelta),
      'status': serializer.toJson<String>(status),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'nextRetryAt': serializer.toJson<DateTime?>(nextRetryAt),
      'serverTransactionId': serializer.toJson<String?>(serverTransactionId),
    };
  }

  EconomyOperationRow copyWith({
    String? operationId,
    String? operationType,
    String? idempotencyKey,
    String? payloadJson,
    DateTime? createdAt,
    int? coinDelta,
    int? hintDelta,
    String? status,
    int? attemptCount,
    Value<DateTime?> nextRetryAt = const Value.absent(),
    Value<String?> serverTransactionId = const Value.absent(),
  }) => EconomyOperationRow(
    operationId: operationId ?? this.operationId,
    operationType: operationType ?? this.operationType,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    payloadJson: payloadJson ?? this.payloadJson,
    createdAt: createdAt ?? this.createdAt,
    coinDelta: coinDelta ?? this.coinDelta,
    hintDelta: hintDelta ?? this.hintDelta,
    status: status ?? this.status,
    attemptCount: attemptCount ?? this.attemptCount,
    nextRetryAt: nextRetryAt.present ? nextRetryAt.value : this.nextRetryAt,
    serverTransactionId: serverTransactionId.present
        ? serverTransactionId.value
        : this.serverTransactionId,
  );
  EconomyOperationRow copyWithCompanion(EconomyOperationRowsCompanion data) {
    return EconomyOperationRow(
      operationId: data.operationId.present
          ? data.operationId.value
          : this.operationId,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      coinDelta: data.coinDelta.present ? data.coinDelta.value : this.coinDelta,
      hintDelta: data.hintDelta.present ? data.hintDelta.value : this.hintDelta,
      status: data.status.present ? data.status.value : this.status,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      nextRetryAt: data.nextRetryAt.present
          ? data.nextRetryAt.value
          : this.nextRetryAt,
      serverTransactionId: data.serverTransactionId.present
          ? data.serverTransactionId.value
          : this.serverTransactionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EconomyOperationRow(')
          ..write('operationId: $operationId, ')
          ..write('operationType: $operationType, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('coinDelta: $coinDelta, ')
          ..write('hintDelta: $hintDelta, ')
          ..write('status: $status, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('serverTransactionId: $serverTransactionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    operationId,
    operationType,
    idempotencyKey,
    payloadJson,
    createdAt,
    coinDelta,
    hintDelta,
    status,
    attemptCount,
    nextRetryAt,
    serverTransactionId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EconomyOperationRow &&
          other.operationId == this.operationId &&
          other.operationType == this.operationType &&
          other.idempotencyKey == this.idempotencyKey &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt &&
          other.coinDelta == this.coinDelta &&
          other.hintDelta == this.hintDelta &&
          other.status == this.status &&
          other.attemptCount == this.attemptCount &&
          other.nextRetryAt == this.nextRetryAt &&
          other.serverTransactionId == this.serverTransactionId);
}

class EconomyOperationRowsCompanion
    extends UpdateCompanion<EconomyOperationRow> {
  final Value<String> operationId;
  final Value<String> operationType;
  final Value<String> idempotencyKey;
  final Value<String> payloadJson;
  final Value<DateTime> createdAt;
  final Value<int> coinDelta;
  final Value<int> hintDelta;
  final Value<String> status;
  final Value<int> attemptCount;
  final Value<DateTime?> nextRetryAt;
  final Value<String?> serverTransactionId;
  final Value<int> rowid;
  const EconomyOperationRowsCompanion({
    this.operationId = const Value.absent(),
    this.operationType = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.coinDelta = const Value.absent(),
    this.hintDelta = const Value.absent(),
    this.status = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.serverTransactionId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EconomyOperationRowsCompanion.insert({
    required String operationId,
    required String operationType,
    required String idempotencyKey,
    required String payloadJson,
    this.createdAt = const Value.absent(),
    this.coinDelta = const Value.absent(),
    this.hintDelta = const Value.absent(),
    this.status = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.serverTransactionId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : operationId = Value(operationId),
       operationType = Value(operationType),
       idempotencyKey = Value(idempotencyKey),
       payloadJson = Value(payloadJson);
  static Insertable<EconomyOperationRow> custom({
    Expression<String>? operationId,
    Expression<String>? operationType,
    Expression<String>? idempotencyKey,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAt,
    Expression<int>? coinDelta,
    Expression<int>? hintDelta,
    Expression<String>? status,
    Expression<int>? attemptCount,
    Expression<DateTime>? nextRetryAt,
    Expression<String>? serverTransactionId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (operationId != null) 'operation_id': operationId,
      if (operationType != null) 'operation_type': operationType,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (coinDelta != null) 'coin_delta': coinDelta,
      if (hintDelta != null) 'hint_delta': hintDelta,
      if (status != null) 'status': status,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (nextRetryAt != null) 'next_retry_at': nextRetryAt,
      if (serverTransactionId != null)
        'server_transaction_id': serverTransactionId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EconomyOperationRowsCompanion copyWith({
    Value<String>? operationId,
    Value<String>? operationType,
    Value<String>? idempotencyKey,
    Value<String>? payloadJson,
    Value<DateTime>? createdAt,
    Value<int>? coinDelta,
    Value<int>? hintDelta,
    Value<String>? status,
    Value<int>? attemptCount,
    Value<DateTime?>? nextRetryAt,
    Value<String?>? serverTransactionId,
    Value<int>? rowid,
  }) {
    return EconomyOperationRowsCompanion(
      operationId: operationId ?? this.operationId,
      operationType: operationType ?? this.operationType,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      coinDelta: coinDelta ?? this.coinDelta,
      hintDelta: hintDelta ?? this.hintDelta,
      status: status ?? this.status,
      attemptCount: attemptCount ?? this.attemptCount,
      nextRetryAt: nextRetryAt ?? this.nextRetryAt,
      serverTransactionId: serverTransactionId ?? this.serverTransactionId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (operationId.present) {
      map['operation_id'] = Variable<String>(operationId.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (coinDelta.present) {
      map['coin_delta'] = Variable<int>(coinDelta.value);
    }
    if (hintDelta.present) {
      map['hint_delta'] = Variable<int>(hintDelta.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (nextRetryAt.present) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt.value);
    }
    if (serverTransactionId.present) {
      map['server_transaction_id'] = Variable<String>(
        serverTransactionId.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EconomyOperationRowsCompanion(')
          ..write('operationId: $operationId, ')
          ..write('operationType: $operationType, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('coinDelta: $coinDelta, ')
          ..write('hintDelta: $hintDelta, ')
          ..write('status: $status, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('serverTransactionId: $serverTransactionId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntitlementRowsTable extends EntitlementRows
    with TableInfo<$EntitlementRowsTable, EntitlementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntitlementRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entitlementTypeMeta = const VerificationMeta(
    'entitlementType',
  );
  @override
  late final GeneratedColumn<String> entitlementType = GeneratedColumn<String>(
    'entitlement_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _storeProductIdMeta = const VerificationMeta(
    'storeProductId',
  );
  @override
  late final GeneratedColumn<String> storeProductId = GeneratedColumn<String>(
    'store_product_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchaseIdMeta = const VerificationMeta(
    'purchaseId',
  );
  @override
  late final GeneratedColumn<String> purchaseId = GeneratedColumn<String>(
    'purchase_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _validatedAtMeta = const VerificationMeta(
    'validatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> validatedAt = GeneratedColumn<DateTime>(
    'validated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    entitlementType,
    active,
    source,
    storeProductId,
    purchaseId,
    validatedAt,
    revision,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entitlement_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntitlementRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entitlement_type')) {
      context.handle(
        _entitlementTypeMeta,
        entitlementType.isAcceptableOrUnknown(
          data['entitlement_type']!,
          _entitlementTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entitlementTypeMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('store_product_id')) {
      context.handle(
        _storeProductIdMeta,
        storeProductId.isAcceptableOrUnknown(
          data['store_product_id']!,
          _storeProductIdMeta,
        ),
      );
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
        _purchaseIdMeta,
        purchaseId.isAcceptableOrUnknown(data['purchase_id']!, _purchaseIdMeta),
      );
    }
    if (data.containsKey('validated_at')) {
      context.handle(
        _validatedAtMeta,
        validatedAt.isAcceptableOrUnknown(
          data['validated_at']!,
          _validatedAtMeta,
        ),
      );
    }
    if (data.containsKey('revision')) {
      context.handle(
        _revisionMeta,
        revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entitlementType};
  @override
  EntitlementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntitlementRow(
      entitlementType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entitlement_type'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      storeProductId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_product_id'],
      ),
      purchaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_id'],
      ),
      validatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}validated_at'],
      ),
      revision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EntitlementRowsTable createAlias(String alias) {
    return $EntitlementRowsTable(attachedDatabase, alias);
  }
}

class EntitlementRow extends DataClass implements Insertable<EntitlementRow> {
  final String entitlementType;
  final bool active;
  final String source;
  final String? storeProductId;
  final String? purchaseId;
  final DateTime? validatedAt;
  final int revision;
  final DateTime updatedAt;
  const EntitlementRow({
    required this.entitlementType,
    required this.active,
    required this.source,
    this.storeProductId,
    this.purchaseId,
    this.validatedAt,
    required this.revision,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entitlement_type'] = Variable<String>(entitlementType);
    map['active'] = Variable<bool>(active);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || storeProductId != null) {
      map['store_product_id'] = Variable<String>(storeProductId);
    }
    if (!nullToAbsent || purchaseId != null) {
      map['purchase_id'] = Variable<String>(purchaseId);
    }
    if (!nullToAbsent || validatedAt != null) {
      map['validated_at'] = Variable<DateTime>(validatedAt);
    }
    map['revision'] = Variable<int>(revision);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EntitlementRowsCompanion toCompanion(bool nullToAbsent) {
    return EntitlementRowsCompanion(
      entitlementType: Value(entitlementType),
      active: Value(active),
      source: Value(source),
      storeProductId: storeProductId == null && nullToAbsent
          ? const Value.absent()
          : Value(storeProductId),
      purchaseId: purchaseId == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseId),
      validatedAt: validatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(validatedAt),
      revision: Value(revision),
      updatedAt: Value(updatedAt),
    );
  }

  factory EntitlementRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntitlementRow(
      entitlementType: serializer.fromJson<String>(json['entitlementType']),
      active: serializer.fromJson<bool>(json['active']),
      source: serializer.fromJson<String>(json['source']),
      storeProductId: serializer.fromJson<String?>(json['storeProductId']),
      purchaseId: serializer.fromJson<String?>(json['purchaseId']),
      validatedAt: serializer.fromJson<DateTime?>(json['validatedAt']),
      revision: serializer.fromJson<int>(json['revision']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entitlementType': serializer.toJson<String>(entitlementType),
      'active': serializer.toJson<bool>(active),
      'source': serializer.toJson<String>(source),
      'storeProductId': serializer.toJson<String?>(storeProductId),
      'purchaseId': serializer.toJson<String?>(purchaseId),
      'validatedAt': serializer.toJson<DateTime?>(validatedAt),
      'revision': serializer.toJson<int>(revision),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  EntitlementRow copyWith({
    String? entitlementType,
    bool? active,
    String? source,
    Value<String?> storeProductId = const Value.absent(),
    Value<String?> purchaseId = const Value.absent(),
    Value<DateTime?> validatedAt = const Value.absent(),
    int? revision,
    DateTime? updatedAt,
  }) => EntitlementRow(
    entitlementType: entitlementType ?? this.entitlementType,
    active: active ?? this.active,
    source: source ?? this.source,
    storeProductId: storeProductId.present
        ? storeProductId.value
        : this.storeProductId,
    purchaseId: purchaseId.present ? purchaseId.value : this.purchaseId,
    validatedAt: validatedAt.present ? validatedAt.value : this.validatedAt,
    revision: revision ?? this.revision,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  EntitlementRow copyWithCompanion(EntitlementRowsCompanion data) {
    return EntitlementRow(
      entitlementType: data.entitlementType.present
          ? data.entitlementType.value
          : this.entitlementType,
      active: data.active.present ? data.active.value : this.active,
      source: data.source.present ? data.source.value : this.source,
      storeProductId: data.storeProductId.present
          ? data.storeProductId.value
          : this.storeProductId,
      purchaseId: data.purchaseId.present
          ? data.purchaseId.value
          : this.purchaseId,
      validatedAt: data.validatedAt.present
          ? data.validatedAt.value
          : this.validatedAt,
      revision: data.revision.present ? data.revision.value : this.revision,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntitlementRow(')
          ..write('entitlementType: $entitlementType, ')
          ..write('active: $active, ')
          ..write('source: $source, ')
          ..write('storeProductId: $storeProductId, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('validatedAt: $validatedAt, ')
          ..write('revision: $revision, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    entitlementType,
    active,
    source,
    storeProductId,
    purchaseId,
    validatedAt,
    revision,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntitlementRow &&
          other.entitlementType == this.entitlementType &&
          other.active == this.active &&
          other.source == this.source &&
          other.storeProductId == this.storeProductId &&
          other.purchaseId == this.purchaseId &&
          other.validatedAt == this.validatedAt &&
          other.revision == this.revision &&
          other.updatedAt == this.updatedAt);
}

class EntitlementRowsCompanion extends UpdateCompanion<EntitlementRow> {
  final Value<String> entitlementType;
  final Value<bool> active;
  final Value<String> source;
  final Value<String?> storeProductId;
  final Value<String?> purchaseId;
  final Value<DateTime?> validatedAt;
  final Value<int> revision;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const EntitlementRowsCompanion({
    this.entitlementType = const Value.absent(),
    this.active = const Value.absent(),
    this.source = const Value.absent(),
    this.storeProductId = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.validatedAt = const Value.absent(),
    this.revision = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntitlementRowsCompanion.insert({
    required String entitlementType,
    this.active = const Value.absent(),
    this.source = const Value.absent(),
    this.storeProductId = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.validatedAt = const Value.absent(),
    this.revision = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : entitlementType = Value(entitlementType);
  static Insertable<EntitlementRow> custom({
    Expression<String>? entitlementType,
    Expression<bool>? active,
    Expression<String>? source,
    Expression<String>? storeProductId,
    Expression<String>? purchaseId,
    Expression<DateTime>? validatedAt,
    Expression<int>? revision,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entitlementType != null) 'entitlement_type': entitlementType,
      if (active != null) 'active': active,
      if (source != null) 'source': source,
      if (storeProductId != null) 'store_product_id': storeProductId,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (validatedAt != null) 'validated_at': validatedAt,
      if (revision != null) 'revision': revision,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntitlementRowsCompanion copyWith({
    Value<String>? entitlementType,
    Value<bool>? active,
    Value<String>? source,
    Value<String?>? storeProductId,
    Value<String?>? purchaseId,
    Value<DateTime?>? validatedAt,
    Value<int>? revision,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return EntitlementRowsCompanion(
      entitlementType: entitlementType ?? this.entitlementType,
      active: active ?? this.active,
      source: source ?? this.source,
      storeProductId: storeProductId ?? this.storeProductId,
      purchaseId: purchaseId ?? this.purchaseId,
      validatedAt: validatedAt ?? this.validatedAt,
      revision: revision ?? this.revision,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entitlementType.present) {
      map['entitlement_type'] = Variable<String>(entitlementType.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (storeProductId.present) {
      map['store_product_id'] = Variable<String>(storeProductId.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<String>(purchaseId.value);
    }
    if (validatedAt.present) {
      map['validated_at'] = Variable<DateTime>(validatedAt.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
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
    return (StringBuffer('EntitlementRowsCompanion(')
          ..write('entitlementType: $entitlementType, ')
          ..write('active: $active, ')
          ..write('source: $source, ')
          ..write('storeProductId: $storeProductId, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('validatedAt: $validatedAt, ')
          ..write('revision: $revision, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MonetizationStateRowsTable extends MonetizationStateRows
    with TableInfo<$MonetizationStateRowsTable, MonetizationStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonetizationStateRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelsSinceLastInterstitialMeta =
      const VerificationMeta('levelsSinceLastInterstitial');
  @override
  late final GeneratedColumn<int> levelsSinceLastInterstitial =
      GeneratedColumn<int>(
        'levels_since_last_interstitial',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _lastRewardedAdAtMeta = const VerificationMeta(
    'lastRewardedAdAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastRewardedAdAt =
      GeneratedColumn<DateTime>(
        'last_rewarded_ad_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastPurchaseAtMeta = const VerificationMeta(
    'lastPurchaseAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastPurchaseAt =
      GeneratedColumn<DateTime>(
        'last_purchase_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastTutorialCompletedAtMeta =
      const VerificationMeta('lastTutorialCompletedAt');
  @override
  late final GeneratedColumn<DateTime> lastTutorialCompletedAt =
      GeneratedColumn<DateTime>(
        'last_tutorial_completed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    levelsSinceLastInterstitial,
    lastRewardedAdAt,
    lastPurchaseAt,
    lastTutorialCompletedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monetization_state_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<MonetizationStateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('levels_since_last_interstitial')) {
      context.handle(
        _levelsSinceLastInterstitialMeta,
        levelsSinceLastInterstitial.isAcceptableOrUnknown(
          data['levels_since_last_interstitial']!,
          _levelsSinceLastInterstitialMeta,
        ),
      );
    }
    if (data.containsKey('last_rewarded_ad_at')) {
      context.handle(
        _lastRewardedAdAtMeta,
        lastRewardedAdAt.isAcceptableOrUnknown(
          data['last_rewarded_ad_at']!,
          _lastRewardedAdAtMeta,
        ),
      );
    }
    if (data.containsKey('last_purchase_at')) {
      context.handle(
        _lastPurchaseAtMeta,
        lastPurchaseAt.isAcceptableOrUnknown(
          data['last_purchase_at']!,
          _lastPurchaseAtMeta,
        ),
      );
    }
    if (data.containsKey('last_tutorial_completed_at')) {
      context.handle(
        _lastTutorialCompletedAtMeta,
        lastTutorialCompletedAt.isAcceptableOrUnknown(
          data['last_tutorial_completed_at']!,
          _lastTutorialCompletedAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MonetizationStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonetizationStateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      levelsSinceLastInterstitial: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}levels_since_last_interstitial'],
      )!,
      lastRewardedAdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_rewarded_ad_at'],
      ),
      lastPurchaseAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_purchase_at'],
      ),
      lastTutorialCompletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_tutorial_completed_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MonetizationStateRowsTable createAlias(String alias) {
    return $MonetizationStateRowsTable(attachedDatabase, alias);
  }
}

class MonetizationStateRow extends DataClass
    implements Insertable<MonetizationStateRow> {
  final String id;
  final int levelsSinceLastInterstitial;
  final DateTime? lastRewardedAdAt;
  final DateTime? lastPurchaseAt;
  final DateTime? lastTutorialCompletedAt;
  final DateTime updatedAt;
  const MonetizationStateRow({
    required this.id,
    required this.levelsSinceLastInterstitial,
    this.lastRewardedAdAt,
    this.lastPurchaseAt,
    this.lastTutorialCompletedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['levels_since_last_interstitial'] = Variable<int>(
      levelsSinceLastInterstitial,
    );
    if (!nullToAbsent || lastRewardedAdAt != null) {
      map['last_rewarded_ad_at'] = Variable<DateTime>(lastRewardedAdAt);
    }
    if (!nullToAbsent || lastPurchaseAt != null) {
      map['last_purchase_at'] = Variable<DateTime>(lastPurchaseAt);
    }
    if (!nullToAbsent || lastTutorialCompletedAt != null) {
      map['last_tutorial_completed_at'] = Variable<DateTime>(
        lastTutorialCompletedAt,
      );
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MonetizationStateRowsCompanion toCompanion(bool nullToAbsent) {
    return MonetizationStateRowsCompanion(
      id: Value(id),
      levelsSinceLastInterstitial: Value(levelsSinceLastInterstitial),
      lastRewardedAdAt: lastRewardedAdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRewardedAdAt),
      lastPurchaseAt: lastPurchaseAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPurchaseAt),
      lastTutorialCompletedAt: lastTutorialCompletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastTutorialCompletedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MonetizationStateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonetizationStateRow(
      id: serializer.fromJson<String>(json['id']),
      levelsSinceLastInterstitial: serializer.fromJson<int>(
        json['levelsSinceLastInterstitial'],
      ),
      lastRewardedAdAt: serializer.fromJson<DateTime?>(
        json['lastRewardedAdAt'],
      ),
      lastPurchaseAt: serializer.fromJson<DateTime?>(json['lastPurchaseAt']),
      lastTutorialCompletedAt: serializer.fromJson<DateTime?>(
        json['lastTutorialCompletedAt'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'levelsSinceLastInterstitial': serializer.toJson<int>(
        levelsSinceLastInterstitial,
      ),
      'lastRewardedAdAt': serializer.toJson<DateTime?>(lastRewardedAdAt),
      'lastPurchaseAt': serializer.toJson<DateTime?>(lastPurchaseAt),
      'lastTutorialCompletedAt': serializer.toJson<DateTime?>(
        lastTutorialCompletedAt,
      ),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MonetizationStateRow copyWith({
    String? id,
    int? levelsSinceLastInterstitial,
    Value<DateTime?> lastRewardedAdAt = const Value.absent(),
    Value<DateTime?> lastPurchaseAt = const Value.absent(),
    Value<DateTime?> lastTutorialCompletedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => MonetizationStateRow(
    id: id ?? this.id,
    levelsSinceLastInterstitial:
        levelsSinceLastInterstitial ?? this.levelsSinceLastInterstitial,
    lastRewardedAdAt: lastRewardedAdAt.present
        ? lastRewardedAdAt.value
        : this.lastRewardedAdAt,
    lastPurchaseAt: lastPurchaseAt.present
        ? lastPurchaseAt.value
        : this.lastPurchaseAt,
    lastTutorialCompletedAt: lastTutorialCompletedAt.present
        ? lastTutorialCompletedAt.value
        : this.lastTutorialCompletedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MonetizationStateRow copyWithCompanion(MonetizationStateRowsCompanion data) {
    return MonetizationStateRow(
      id: data.id.present ? data.id.value : this.id,
      levelsSinceLastInterstitial: data.levelsSinceLastInterstitial.present
          ? data.levelsSinceLastInterstitial.value
          : this.levelsSinceLastInterstitial,
      lastRewardedAdAt: data.lastRewardedAdAt.present
          ? data.lastRewardedAdAt.value
          : this.lastRewardedAdAt,
      lastPurchaseAt: data.lastPurchaseAt.present
          ? data.lastPurchaseAt.value
          : this.lastPurchaseAt,
      lastTutorialCompletedAt: data.lastTutorialCompletedAt.present
          ? data.lastTutorialCompletedAt.value
          : this.lastTutorialCompletedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonetizationStateRow(')
          ..write('id: $id, ')
          ..write('levelsSinceLastInterstitial: $levelsSinceLastInterstitial, ')
          ..write('lastRewardedAdAt: $lastRewardedAdAt, ')
          ..write('lastPurchaseAt: $lastPurchaseAt, ')
          ..write('lastTutorialCompletedAt: $lastTutorialCompletedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    levelsSinceLastInterstitial,
    lastRewardedAdAt,
    lastPurchaseAt,
    lastTutorialCompletedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonetizationStateRow &&
          other.id == this.id &&
          other.levelsSinceLastInterstitial ==
              this.levelsSinceLastInterstitial &&
          other.lastRewardedAdAt == this.lastRewardedAdAt &&
          other.lastPurchaseAt == this.lastPurchaseAt &&
          other.lastTutorialCompletedAt == this.lastTutorialCompletedAt &&
          other.updatedAt == this.updatedAt);
}

class MonetizationStateRowsCompanion
    extends UpdateCompanion<MonetizationStateRow> {
  final Value<String> id;
  final Value<int> levelsSinceLastInterstitial;
  final Value<DateTime?> lastRewardedAdAt;
  final Value<DateTime?> lastPurchaseAt;
  final Value<DateTime?> lastTutorialCompletedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MonetizationStateRowsCompanion({
    this.id = const Value.absent(),
    this.levelsSinceLastInterstitial = const Value.absent(),
    this.lastRewardedAdAt = const Value.absent(),
    this.lastPurchaseAt = const Value.absent(),
    this.lastTutorialCompletedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MonetizationStateRowsCompanion.insert({
    required String id,
    this.levelsSinceLastInterstitial = const Value.absent(),
    this.lastRewardedAdAt = const Value.absent(),
    this.lastPurchaseAt = const Value.absent(),
    this.lastTutorialCompletedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<MonetizationStateRow> custom({
    Expression<String>? id,
    Expression<int>? levelsSinceLastInterstitial,
    Expression<DateTime>? lastRewardedAdAt,
    Expression<DateTime>? lastPurchaseAt,
    Expression<DateTime>? lastTutorialCompletedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (levelsSinceLastInterstitial != null)
        'levels_since_last_interstitial': levelsSinceLastInterstitial,
      if (lastRewardedAdAt != null) 'last_rewarded_ad_at': lastRewardedAdAt,
      if (lastPurchaseAt != null) 'last_purchase_at': lastPurchaseAt,
      if (lastTutorialCompletedAt != null)
        'last_tutorial_completed_at': lastTutorialCompletedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MonetizationStateRowsCompanion copyWith({
    Value<String>? id,
    Value<int>? levelsSinceLastInterstitial,
    Value<DateTime?>? lastRewardedAdAt,
    Value<DateTime?>? lastPurchaseAt,
    Value<DateTime?>? lastTutorialCompletedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return MonetizationStateRowsCompanion(
      id: id ?? this.id,
      levelsSinceLastInterstitial:
          levelsSinceLastInterstitial ?? this.levelsSinceLastInterstitial,
      lastRewardedAdAt: lastRewardedAdAt ?? this.lastRewardedAdAt,
      lastPurchaseAt: lastPurchaseAt ?? this.lastPurchaseAt,
      lastTutorialCompletedAt:
          lastTutorialCompletedAt ?? this.lastTutorialCompletedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (levelsSinceLastInterstitial.present) {
      map['levels_since_last_interstitial'] = Variable<int>(
        levelsSinceLastInterstitial.value,
      );
    }
    if (lastRewardedAdAt.present) {
      map['last_rewarded_ad_at'] = Variable<DateTime>(lastRewardedAdAt.value);
    }
    if (lastPurchaseAt.present) {
      map['last_purchase_at'] = Variable<DateTime>(lastPurchaseAt.value);
    }
    if (lastTutorialCompletedAt.present) {
      map['last_tutorial_completed_at'] = Variable<DateTime>(
        lastTutorialCompletedAt.value,
      );
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
    return (StringBuffer('MonetizationStateRowsCompanion(')
          ..write('id: $id, ')
          ..write('levelsSinceLastInterstitial: $levelsSinceLastInterstitial, ')
          ..write('lastRewardedAdAt: $lastRewardedAdAt, ')
          ..write('lastPurchaseAt: $lastPurchaseAt, ')
          ..write('lastTutorialCompletedAt: $lastTutorialCompletedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RewardedAdReceiptRowsTable extends RewardedAdReceiptRows
    with TableInfo<$RewardedAdReceiptRowsTable, RewardedAdReceiptRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RewardedAdReceiptRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _operationIdMeta = const VerificationMeta(
    'operationId',
  );
  @override
  late final GeneratedColumn<String> operationId = GeneratedColumn<String>(
    'operation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rewardTypeMeta = const VerificationMeta(
    'rewardType',
  );
  @override
  late final GeneratedColumn<String> rewardType = GeneratedColumn<String>(
    'reward_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _adCompletedMeta = const VerificationMeta(
    'adCompleted',
  );
  @override
  late final GeneratedColumn<bool> adCompleted = GeneratedColumn<bool>(
    'ad_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ad_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _attemptIdMeta = const VerificationMeta(
    'attemptId',
  );
  @override
  late final GeneratedColumn<String> attemptId = GeneratedColumn<String>(
    'attempt_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _backendGrantedMeta = const VerificationMeta(
    'backendGranted',
  );
  @override
  late final GeneratedColumn<bool> backendGranted = GeneratedColumn<bool>(
    'backend_granted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("backend_granted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _localEffectAppliedMeta =
      const VerificationMeta('localEffectApplied');
  @override
  late final GeneratedColumn<bool> localEffectApplied = GeneratedColumn<bool>(
    'local_effect_applied',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("local_effect_applied" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    operationId,
    rewardType,
    adCompleted,
    attemptId,
    backendGranted,
    localEffectApplied,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rewarded_ad_receipt_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<RewardedAdReceiptRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('operation_id')) {
      context.handle(
        _operationIdMeta,
        operationId.isAcceptableOrUnknown(
          data['operation_id']!,
          _operationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationIdMeta);
    }
    if (data.containsKey('reward_type')) {
      context.handle(
        _rewardTypeMeta,
        rewardType.isAcceptableOrUnknown(data['reward_type']!, _rewardTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_rewardTypeMeta);
    }
    if (data.containsKey('ad_completed')) {
      context.handle(
        _adCompletedMeta,
        adCompleted.isAcceptableOrUnknown(
          data['ad_completed']!,
          _adCompletedMeta,
        ),
      );
    }
    if (data.containsKey('attempt_id')) {
      context.handle(
        _attemptIdMeta,
        attemptId.isAcceptableOrUnknown(data['attempt_id']!, _attemptIdMeta),
      );
    }
    if (data.containsKey('backend_granted')) {
      context.handle(
        _backendGrantedMeta,
        backendGranted.isAcceptableOrUnknown(
          data['backend_granted']!,
          _backendGrantedMeta,
        ),
      );
    }
    if (data.containsKey('local_effect_applied')) {
      context.handle(
        _localEffectAppliedMeta,
        localEffectApplied.isAcceptableOrUnknown(
          data['local_effect_applied']!,
          _localEffectAppliedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {operationId};
  @override
  RewardedAdReceiptRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RewardedAdReceiptRow(
      operationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_id'],
      )!,
      rewardType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reward_type'],
      )!,
      adCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ad_completed'],
      )!,
      attemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attempt_id'],
      ),
      backendGranted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}backend_granted'],
      )!,
      localEffectApplied: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}local_effect_applied'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RewardedAdReceiptRowsTable createAlias(String alias) {
    return $RewardedAdReceiptRowsTable(attachedDatabase, alias);
  }
}

class RewardedAdReceiptRow extends DataClass
    implements Insertable<RewardedAdReceiptRow> {
  final String operationId;
  final String rewardType;
  final bool adCompleted;
  final String? attemptId;
  final bool backendGranted;
  final bool localEffectApplied;
  final DateTime createdAt;
  const RewardedAdReceiptRow({
    required this.operationId,
    required this.rewardType,
    required this.adCompleted,
    this.attemptId,
    required this.backendGranted,
    required this.localEffectApplied,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['operation_id'] = Variable<String>(operationId);
    map['reward_type'] = Variable<String>(rewardType);
    map['ad_completed'] = Variable<bool>(adCompleted);
    if (!nullToAbsent || attemptId != null) {
      map['attempt_id'] = Variable<String>(attemptId);
    }
    map['backend_granted'] = Variable<bool>(backendGranted);
    map['local_effect_applied'] = Variable<bool>(localEffectApplied);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RewardedAdReceiptRowsCompanion toCompanion(bool nullToAbsent) {
    return RewardedAdReceiptRowsCompanion(
      operationId: Value(operationId),
      rewardType: Value(rewardType),
      adCompleted: Value(adCompleted),
      attemptId: attemptId == null && nullToAbsent
          ? const Value.absent()
          : Value(attemptId),
      backendGranted: Value(backendGranted),
      localEffectApplied: Value(localEffectApplied),
      createdAt: Value(createdAt),
    );
  }

  factory RewardedAdReceiptRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RewardedAdReceiptRow(
      operationId: serializer.fromJson<String>(json['operationId']),
      rewardType: serializer.fromJson<String>(json['rewardType']),
      adCompleted: serializer.fromJson<bool>(json['adCompleted']),
      attemptId: serializer.fromJson<String?>(json['attemptId']),
      backendGranted: serializer.fromJson<bool>(json['backendGranted']),
      localEffectApplied: serializer.fromJson<bool>(json['localEffectApplied']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'operationId': serializer.toJson<String>(operationId),
      'rewardType': serializer.toJson<String>(rewardType),
      'adCompleted': serializer.toJson<bool>(adCompleted),
      'attemptId': serializer.toJson<String?>(attemptId),
      'backendGranted': serializer.toJson<bool>(backendGranted),
      'localEffectApplied': serializer.toJson<bool>(localEffectApplied),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RewardedAdReceiptRow copyWith({
    String? operationId,
    String? rewardType,
    bool? adCompleted,
    Value<String?> attemptId = const Value.absent(),
    bool? backendGranted,
    bool? localEffectApplied,
    DateTime? createdAt,
  }) => RewardedAdReceiptRow(
    operationId: operationId ?? this.operationId,
    rewardType: rewardType ?? this.rewardType,
    adCompleted: adCompleted ?? this.adCompleted,
    attemptId: attemptId.present ? attemptId.value : this.attemptId,
    backendGranted: backendGranted ?? this.backendGranted,
    localEffectApplied: localEffectApplied ?? this.localEffectApplied,
    createdAt: createdAt ?? this.createdAt,
  );
  RewardedAdReceiptRow copyWithCompanion(RewardedAdReceiptRowsCompanion data) {
    return RewardedAdReceiptRow(
      operationId: data.operationId.present
          ? data.operationId.value
          : this.operationId,
      rewardType: data.rewardType.present
          ? data.rewardType.value
          : this.rewardType,
      adCompleted: data.adCompleted.present
          ? data.adCompleted.value
          : this.adCompleted,
      attemptId: data.attemptId.present ? data.attemptId.value : this.attemptId,
      backendGranted: data.backendGranted.present
          ? data.backendGranted.value
          : this.backendGranted,
      localEffectApplied: data.localEffectApplied.present
          ? data.localEffectApplied.value
          : this.localEffectApplied,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RewardedAdReceiptRow(')
          ..write('operationId: $operationId, ')
          ..write('rewardType: $rewardType, ')
          ..write('adCompleted: $adCompleted, ')
          ..write('attemptId: $attemptId, ')
          ..write('backendGranted: $backendGranted, ')
          ..write('localEffectApplied: $localEffectApplied, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    operationId,
    rewardType,
    adCompleted,
    attemptId,
    backendGranted,
    localEffectApplied,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RewardedAdReceiptRow &&
          other.operationId == this.operationId &&
          other.rewardType == this.rewardType &&
          other.adCompleted == this.adCompleted &&
          other.attemptId == this.attemptId &&
          other.backendGranted == this.backendGranted &&
          other.localEffectApplied == this.localEffectApplied &&
          other.createdAt == this.createdAt);
}

class RewardedAdReceiptRowsCompanion
    extends UpdateCompanion<RewardedAdReceiptRow> {
  final Value<String> operationId;
  final Value<String> rewardType;
  final Value<bool> adCompleted;
  final Value<String?> attemptId;
  final Value<bool> backendGranted;
  final Value<bool> localEffectApplied;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RewardedAdReceiptRowsCompanion({
    this.operationId = const Value.absent(),
    this.rewardType = const Value.absent(),
    this.adCompleted = const Value.absent(),
    this.attemptId = const Value.absent(),
    this.backendGranted = const Value.absent(),
    this.localEffectApplied = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RewardedAdReceiptRowsCompanion.insert({
    required String operationId,
    required String rewardType,
    this.adCompleted = const Value.absent(),
    this.attemptId = const Value.absent(),
    this.backendGranted = const Value.absent(),
    this.localEffectApplied = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : operationId = Value(operationId),
       rewardType = Value(rewardType);
  static Insertable<RewardedAdReceiptRow> custom({
    Expression<String>? operationId,
    Expression<String>? rewardType,
    Expression<bool>? adCompleted,
    Expression<String>? attemptId,
    Expression<bool>? backendGranted,
    Expression<bool>? localEffectApplied,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (operationId != null) 'operation_id': operationId,
      if (rewardType != null) 'reward_type': rewardType,
      if (adCompleted != null) 'ad_completed': adCompleted,
      if (attemptId != null) 'attempt_id': attemptId,
      if (backendGranted != null) 'backend_granted': backendGranted,
      if (localEffectApplied != null)
        'local_effect_applied': localEffectApplied,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RewardedAdReceiptRowsCompanion copyWith({
    Value<String>? operationId,
    Value<String>? rewardType,
    Value<bool>? adCompleted,
    Value<String?>? attemptId,
    Value<bool>? backendGranted,
    Value<bool>? localEffectApplied,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RewardedAdReceiptRowsCompanion(
      operationId: operationId ?? this.operationId,
      rewardType: rewardType ?? this.rewardType,
      adCompleted: adCompleted ?? this.adCompleted,
      attemptId: attemptId ?? this.attemptId,
      backendGranted: backendGranted ?? this.backendGranted,
      localEffectApplied: localEffectApplied ?? this.localEffectApplied,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (operationId.present) {
      map['operation_id'] = Variable<String>(operationId.value);
    }
    if (rewardType.present) {
      map['reward_type'] = Variable<String>(rewardType.value);
    }
    if (adCompleted.present) {
      map['ad_completed'] = Variable<bool>(adCompleted.value);
    }
    if (attemptId.present) {
      map['attempt_id'] = Variable<String>(attemptId.value);
    }
    if (backendGranted.present) {
      map['backend_granted'] = Variable<bool>(backendGranted.value);
    }
    if (localEffectApplied.present) {
      map['local_effect_applied'] = Variable<bool>(localEffectApplied.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RewardedAdReceiptRowsCompanion(')
          ..write('operationId: $operationId, ')
          ..write('rewardType: $rewardType, ')
          ..write('adCompleted: $adCompleted, ')
          ..write('attemptId: $attemptId, ')
          ..write('backendGranted: $backendGranted, ')
          ..write('localEffectApplied: $localEffectApplied, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyStateCacheRowsTable extends DailyStateCacheRows
    with TableInfo<$DailyStateCacheRowsTable, DailyStateCacheRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyStateCacheRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayKeyMeta = const VerificationMeta('dayKey');
  @override
  late final GeneratedColumn<String> dayKey = GeneratedColumn<String>(
    'day_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timezoneIdMeta = const VerificationMeta(
    'timezoneId',
  );
  @override
  late final GeneratedColumn<String> timezoneId = GeneratedColumn<String>(
    'timezone_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UTC'),
  );
  static const VerificationMeta _timezoneOffsetMinutesMeta =
      const VerificationMeta('timezoneOffsetMinutes');
  @override
  late final GeneratedColumn<int> timezoneOffsetMinutes = GeneratedColumn<int>(
    'timezone_offset_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _rewardCalendarDayIndexMeta =
      const VerificationMeta('rewardCalendarDayIndex');
  @override
  late final GeneratedColumn<int> rewardCalendarDayIndex = GeneratedColumn<int>(
    'reward_calendar_day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _rewardLastClaimedDayKeyMeta =
      const VerificationMeta('rewardLastClaimedDayKey');
  @override
  late final GeneratedColumn<String> rewardLastClaimedDayKey =
      GeneratedColumn<String>(
        'reward_last_claimed_day_key',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _rewardLastClaimedAtMeta =
      const VerificationMeta('rewardLastClaimedAt');
  @override
  late final GeneratedColumn<DateTime> rewardLastClaimedAt =
      GeneratedColumn<DateTime>(
        'reward_last_claimed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _rewardRevisionMeta = const VerificationMeta(
    'rewardRevision',
  );
  @override
  late final GeneratedColumn<int> rewardRevision = GeneratedColumn<int>(
    'reward_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _streakCurrentDaysMeta = const VerificationMeta(
    'streakCurrentDays',
  );
  @override
  late final GeneratedColumn<int> streakCurrentDays = GeneratedColumn<int>(
    'streak_current_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _streakLastQualifiedDayKeyMeta =
      const VerificationMeta('streakLastQualifiedDayKey');
  @override
  late final GeneratedColumn<String> streakLastQualifiedDayKey =
      GeneratedColumn<String>(
        'streak_last_qualified_day_key',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _streakLongestDaysMeta = const VerificationMeta(
    'streakLongestDays',
  );
  @override
  late final GeneratedColumn<int> streakLongestDays = GeneratedColumn<int>(
    'streak_longest_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _streakClaimedMilestonesJsonMeta =
      const VerificationMeta('streakClaimedMilestonesJson');
  @override
  late final GeneratedColumn<String> streakClaimedMilestonesJson =
      GeneratedColumn<String>(
        'streak_claimed_milestones_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _streakCycleIdMeta = const VerificationMeta(
    'streakCycleId',
  );
  @override
  late final GeneratedColumn<String> streakCycleId = GeneratedColumn<String>(
    'streak_cycle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('init'),
  );
  static const VerificationMeta _streakRevisionMeta = const VerificationMeta(
    'streakRevision',
  );
  @override
  late final GeneratedColumn<int> streakRevision = GeneratedColumn<int>(
    'streak_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _challengeCurrentDayKeyMeta =
      const VerificationMeta('challengeCurrentDayKey');
  @override
  late final GeneratedColumn<String> challengeCurrentDayKey =
      GeneratedColumn<String>(
        'challenge_current_day_key',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _challengeIdMeta = const VerificationMeta(
    'challengeId',
  );
  @override
  late final GeneratedColumn<String> challengeId = GeneratedColumn<String>(
    'challenge_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _challengeCompletedMeta =
      const VerificationMeta('challengeCompleted');
  @override
  late final GeneratedColumn<bool> challengeCompleted = GeneratedColumn<bool>(
    'challenge_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("challenge_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _challengeRewardGrantedMeta =
      const VerificationMeta('challengeRewardGranted');
  @override
  late final GeneratedColumn<bool> challengeRewardGranted =
      GeneratedColumn<bool>(
        'challenge_reward_granted',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("challenge_reward_granted" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _challengeCompletedAtMeta =
      const VerificationMeta('challengeCompletedAt');
  @override
  late final GeneratedColumn<DateTime> challengeCompletedAt =
      GeneratedColumn<DateTime>(
        'challenge_completed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _challengeAttemptCountMeta =
      const VerificationMeta('challengeAttemptCount');
  @override
  late final GeneratedColumn<int> challengeAttemptCount = GeneratedColumn<int>(
    'challenge_attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dayKey,
    timezoneId,
    timezoneOffsetMinutes,
    rewardCalendarDayIndex,
    rewardLastClaimedDayKey,
    rewardLastClaimedAt,
    rewardRevision,
    streakCurrentDays,
    streakLastQualifiedDayKey,
    streakLongestDays,
    streakClaimedMilestonesJson,
    streakCycleId,
    streakRevision,
    challengeCurrentDayKey,
    challengeId,
    challengeCompleted,
    challengeRewardGranted,
    challengeCompletedAt,
    challengeAttemptCount,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_state_cache_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyStateCacheRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('day_key')) {
      context.handle(
        _dayKeyMeta,
        dayKey.isAcceptableOrUnknown(data['day_key']!, _dayKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dayKeyMeta);
    }
    if (data.containsKey('timezone_id')) {
      context.handle(
        _timezoneIdMeta,
        timezoneId.isAcceptableOrUnknown(data['timezone_id']!, _timezoneIdMeta),
      );
    }
    if (data.containsKey('timezone_offset_minutes')) {
      context.handle(
        _timezoneOffsetMinutesMeta,
        timezoneOffsetMinutes.isAcceptableOrUnknown(
          data['timezone_offset_minutes']!,
          _timezoneOffsetMinutesMeta,
        ),
      );
    }
    if (data.containsKey('reward_calendar_day_index')) {
      context.handle(
        _rewardCalendarDayIndexMeta,
        rewardCalendarDayIndex.isAcceptableOrUnknown(
          data['reward_calendar_day_index']!,
          _rewardCalendarDayIndexMeta,
        ),
      );
    }
    if (data.containsKey('reward_last_claimed_day_key')) {
      context.handle(
        _rewardLastClaimedDayKeyMeta,
        rewardLastClaimedDayKey.isAcceptableOrUnknown(
          data['reward_last_claimed_day_key']!,
          _rewardLastClaimedDayKeyMeta,
        ),
      );
    }
    if (data.containsKey('reward_last_claimed_at')) {
      context.handle(
        _rewardLastClaimedAtMeta,
        rewardLastClaimedAt.isAcceptableOrUnknown(
          data['reward_last_claimed_at']!,
          _rewardLastClaimedAtMeta,
        ),
      );
    }
    if (data.containsKey('reward_revision')) {
      context.handle(
        _rewardRevisionMeta,
        rewardRevision.isAcceptableOrUnknown(
          data['reward_revision']!,
          _rewardRevisionMeta,
        ),
      );
    }
    if (data.containsKey('streak_current_days')) {
      context.handle(
        _streakCurrentDaysMeta,
        streakCurrentDays.isAcceptableOrUnknown(
          data['streak_current_days']!,
          _streakCurrentDaysMeta,
        ),
      );
    }
    if (data.containsKey('streak_last_qualified_day_key')) {
      context.handle(
        _streakLastQualifiedDayKeyMeta,
        streakLastQualifiedDayKey.isAcceptableOrUnknown(
          data['streak_last_qualified_day_key']!,
          _streakLastQualifiedDayKeyMeta,
        ),
      );
    }
    if (data.containsKey('streak_longest_days')) {
      context.handle(
        _streakLongestDaysMeta,
        streakLongestDays.isAcceptableOrUnknown(
          data['streak_longest_days']!,
          _streakLongestDaysMeta,
        ),
      );
    }
    if (data.containsKey('streak_claimed_milestones_json')) {
      context.handle(
        _streakClaimedMilestonesJsonMeta,
        streakClaimedMilestonesJson.isAcceptableOrUnknown(
          data['streak_claimed_milestones_json']!,
          _streakClaimedMilestonesJsonMeta,
        ),
      );
    }
    if (data.containsKey('streak_cycle_id')) {
      context.handle(
        _streakCycleIdMeta,
        streakCycleId.isAcceptableOrUnknown(
          data['streak_cycle_id']!,
          _streakCycleIdMeta,
        ),
      );
    }
    if (data.containsKey('streak_revision')) {
      context.handle(
        _streakRevisionMeta,
        streakRevision.isAcceptableOrUnknown(
          data['streak_revision']!,
          _streakRevisionMeta,
        ),
      );
    }
    if (data.containsKey('challenge_current_day_key')) {
      context.handle(
        _challengeCurrentDayKeyMeta,
        challengeCurrentDayKey.isAcceptableOrUnknown(
          data['challenge_current_day_key']!,
          _challengeCurrentDayKeyMeta,
        ),
      );
    }
    if (data.containsKey('challenge_id')) {
      context.handle(
        _challengeIdMeta,
        challengeId.isAcceptableOrUnknown(
          data['challenge_id']!,
          _challengeIdMeta,
        ),
      );
    }
    if (data.containsKey('challenge_completed')) {
      context.handle(
        _challengeCompletedMeta,
        challengeCompleted.isAcceptableOrUnknown(
          data['challenge_completed']!,
          _challengeCompletedMeta,
        ),
      );
    }
    if (data.containsKey('challenge_reward_granted')) {
      context.handle(
        _challengeRewardGrantedMeta,
        challengeRewardGranted.isAcceptableOrUnknown(
          data['challenge_reward_granted']!,
          _challengeRewardGrantedMeta,
        ),
      );
    }
    if (data.containsKey('challenge_completed_at')) {
      context.handle(
        _challengeCompletedAtMeta,
        challengeCompletedAt.isAcceptableOrUnknown(
          data['challenge_completed_at']!,
          _challengeCompletedAtMeta,
        ),
      );
    }
    if (data.containsKey('challenge_attempt_count')) {
      context.handle(
        _challengeAttemptCountMeta,
        challengeAttemptCount.isAcceptableOrUnknown(
          data['challenge_attempt_count']!,
          _challengeAttemptCountMeta,
        ),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyStateCacheRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyStateCacheRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_key'],
      )!,
      timezoneId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone_id'],
      )!,
      timezoneOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timezone_offset_minutes'],
      )!,
      rewardCalendarDayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reward_calendar_day_index'],
      )!,
      rewardLastClaimedDayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reward_last_claimed_day_key'],
      ),
      rewardLastClaimedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reward_last_claimed_at'],
      ),
      rewardRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reward_revision'],
      )!,
      streakCurrentDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak_current_days'],
      )!,
      streakLastQualifiedDayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}streak_last_qualified_day_key'],
      ),
      streakLongestDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak_longest_days'],
      )!,
      streakClaimedMilestonesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}streak_claimed_milestones_json'],
      )!,
      streakCycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}streak_cycle_id'],
      )!,
      streakRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak_revision'],
      )!,
      challengeCurrentDayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}challenge_current_day_key'],
      ),
      challengeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}challenge_id'],
      ),
      challengeCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}challenge_completed'],
      )!,
      challengeRewardGranted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}challenge_reward_granted'],
      )!,
      challengeCompletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}challenge_completed_at'],
      ),
      challengeAttemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}challenge_attempt_count'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $DailyStateCacheRowsTable createAlias(String alias) {
    return $DailyStateCacheRowsTable(attachedDatabase, alias);
  }
}

class DailyStateCacheRow extends DataClass
    implements Insertable<DailyStateCacheRow> {
  final String id;
  final String dayKey;
  final String timezoneId;
  final int timezoneOffsetMinutes;
  final int rewardCalendarDayIndex;
  final String? rewardLastClaimedDayKey;
  final DateTime? rewardLastClaimedAt;
  final int rewardRevision;
  final int streakCurrentDays;
  final String? streakLastQualifiedDayKey;
  final int streakLongestDays;
  final String streakClaimedMilestonesJson;
  final String streakCycleId;
  final int streakRevision;
  final String? challengeCurrentDayKey;
  final String? challengeId;
  final bool challengeCompleted;
  final bool challengeRewardGranted;
  final DateTime? challengeCompletedAt;
  final int challengeAttemptCount;
  final DateTime fetchedAt;
  const DailyStateCacheRow({
    required this.id,
    required this.dayKey,
    required this.timezoneId,
    required this.timezoneOffsetMinutes,
    required this.rewardCalendarDayIndex,
    this.rewardLastClaimedDayKey,
    this.rewardLastClaimedAt,
    required this.rewardRevision,
    required this.streakCurrentDays,
    this.streakLastQualifiedDayKey,
    required this.streakLongestDays,
    required this.streakClaimedMilestonesJson,
    required this.streakCycleId,
    required this.streakRevision,
    this.challengeCurrentDayKey,
    this.challengeId,
    required this.challengeCompleted,
    required this.challengeRewardGranted,
    this.challengeCompletedAt,
    required this.challengeAttemptCount,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['day_key'] = Variable<String>(dayKey);
    map['timezone_id'] = Variable<String>(timezoneId);
    map['timezone_offset_minutes'] = Variable<int>(timezoneOffsetMinutes);
    map['reward_calendar_day_index'] = Variable<int>(rewardCalendarDayIndex);
    if (!nullToAbsent || rewardLastClaimedDayKey != null) {
      map['reward_last_claimed_day_key'] = Variable<String>(
        rewardLastClaimedDayKey,
      );
    }
    if (!nullToAbsent || rewardLastClaimedAt != null) {
      map['reward_last_claimed_at'] = Variable<DateTime>(rewardLastClaimedAt);
    }
    map['reward_revision'] = Variable<int>(rewardRevision);
    map['streak_current_days'] = Variable<int>(streakCurrentDays);
    if (!nullToAbsent || streakLastQualifiedDayKey != null) {
      map['streak_last_qualified_day_key'] = Variable<String>(
        streakLastQualifiedDayKey,
      );
    }
    map['streak_longest_days'] = Variable<int>(streakLongestDays);
    map['streak_claimed_milestones_json'] = Variable<String>(
      streakClaimedMilestonesJson,
    );
    map['streak_cycle_id'] = Variable<String>(streakCycleId);
    map['streak_revision'] = Variable<int>(streakRevision);
    if (!nullToAbsent || challengeCurrentDayKey != null) {
      map['challenge_current_day_key'] = Variable<String>(
        challengeCurrentDayKey,
      );
    }
    if (!nullToAbsent || challengeId != null) {
      map['challenge_id'] = Variable<String>(challengeId);
    }
    map['challenge_completed'] = Variable<bool>(challengeCompleted);
    map['challenge_reward_granted'] = Variable<bool>(challengeRewardGranted);
    if (!nullToAbsent || challengeCompletedAt != null) {
      map['challenge_completed_at'] = Variable<DateTime>(challengeCompletedAt);
    }
    map['challenge_attempt_count'] = Variable<int>(challengeAttemptCount);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  DailyStateCacheRowsCompanion toCompanion(bool nullToAbsent) {
    return DailyStateCacheRowsCompanion(
      id: Value(id),
      dayKey: Value(dayKey),
      timezoneId: Value(timezoneId),
      timezoneOffsetMinutes: Value(timezoneOffsetMinutes),
      rewardCalendarDayIndex: Value(rewardCalendarDayIndex),
      rewardLastClaimedDayKey: rewardLastClaimedDayKey == null && nullToAbsent
          ? const Value.absent()
          : Value(rewardLastClaimedDayKey),
      rewardLastClaimedAt: rewardLastClaimedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(rewardLastClaimedAt),
      rewardRevision: Value(rewardRevision),
      streakCurrentDays: Value(streakCurrentDays),
      streakLastQualifiedDayKey:
          streakLastQualifiedDayKey == null && nullToAbsent
          ? const Value.absent()
          : Value(streakLastQualifiedDayKey),
      streakLongestDays: Value(streakLongestDays),
      streakClaimedMilestonesJson: Value(streakClaimedMilestonesJson),
      streakCycleId: Value(streakCycleId),
      streakRevision: Value(streakRevision),
      challengeCurrentDayKey: challengeCurrentDayKey == null && nullToAbsent
          ? const Value.absent()
          : Value(challengeCurrentDayKey),
      challengeId: challengeId == null && nullToAbsent
          ? const Value.absent()
          : Value(challengeId),
      challengeCompleted: Value(challengeCompleted),
      challengeRewardGranted: Value(challengeRewardGranted),
      challengeCompletedAt: challengeCompletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(challengeCompletedAt),
      challengeAttemptCount: Value(challengeAttemptCount),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory DailyStateCacheRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyStateCacheRow(
      id: serializer.fromJson<String>(json['id']),
      dayKey: serializer.fromJson<String>(json['dayKey']),
      timezoneId: serializer.fromJson<String>(json['timezoneId']),
      timezoneOffsetMinutes: serializer.fromJson<int>(
        json['timezoneOffsetMinutes'],
      ),
      rewardCalendarDayIndex: serializer.fromJson<int>(
        json['rewardCalendarDayIndex'],
      ),
      rewardLastClaimedDayKey: serializer.fromJson<String?>(
        json['rewardLastClaimedDayKey'],
      ),
      rewardLastClaimedAt: serializer.fromJson<DateTime?>(
        json['rewardLastClaimedAt'],
      ),
      rewardRevision: serializer.fromJson<int>(json['rewardRevision']),
      streakCurrentDays: serializer.fromJson<int>(json['streakCurrentDays']),
      streakLastQualifiedDayKey: serializer.fromJson<String?>(
        json['streakLastQualifiedDayKey'],
      ),
      streakLongestDays: serializer.fromJson<int>(json['streakLongestDays']),
      streakClaimedMilestonesJson: serializer.fromJson<String>(
        json['streakClaimedMilestonesJson'],
      ),
      streakCycleId: serializer.fromJson<String>(json['streakCycleId']),
      streakRevision: serializer.fromJson<int>(json['streakRevision']),
      challengeCurrentDayKey: serializer.fromJson<String?>(
        json['challengeCurrentDayKey'],
      ),
      challengeId: serializer.fromJson<String?>(json['challengeId']),
      challengeCompleted: serializer.fromJson<bool>(json['challengeCompleted']),
      challengeRewardGranted: serializer.fromJson<bool>(
        json['challengeRewardGranted'],
      ),
      challengeCompletedAt: serializer.fromJson<DateTime?>(
        json['challengeCompletedAt'],
      ),
      challengeAttemptCount: serializer.fromJson<int>(
        json['challengeAttemptCount'],
      ),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dayKey': serializer.toJson<String>(dayKey),
      'timezoneId': serializer.toJson<String>(timezoneId),
      'timezoneOffsetMinutes': serializer.toJson<int>(timezoneOffsetMinutes),
      'rewardCalendarDayIndex': serializer.toJson<int>(rewardCalendarDayIndex),
      'rewardLastClaimedDayKey': serializer.toJson<String?>(
        rewardLastClaimedDayKey,
      ),
      'rewardLastClaimedAt': serializer.toJson<DateTime?>(rewardLastClaimedAt),
      'rewardRevision': serializer.toJson<int>(rewardRevision),
      'streakCurrentDays': serializer.toJson<int>(streakCurrentDays),
      'streakLastQualifiedDayKey': serializer.toJson<String?>(
        streakLastQualifiedDayKey,
      ),
      'streakLongestDays': serializer.toJson<int>(streakLongestDays),
      'streakClaimedMilestonesJson': serializer.toJson<String>(
        streakClaimedMilestonesJson,
      ),
      'streakCycleId': serializer.toJson<String>(streakCycleId),
      'streakRevision': serializer.toJson<int>(streakRevision),
      'challengeCurrentDayKey': serializer.toJson<String?>(
        challengeCurrentDayKey,
      ),
      'challengeId': serializer.toJson<String?>(challengeId),
      'challengeCompleted': serializer.toJson<bool>(challengeCompleted),
      'challengeRewardGranted': serializer.toJson<bool>(challengeRewardGranted),
      'challengeCompletedAt': serializer.toJson<DateTime?>(
        challengeCompletedAt,
      ),
      'challengeAttemptCount': serializer.toJson<int>(challengeAttemptCount),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  DailyStateCacheRow copyWith({
    String? id,
    String? dayKey,
    String? timezoneId,
    int? timezoneOffsetMinutes,
    int? rewardCalendarDayIndex,
    Value<String?> rewardLastClaimedDayKey = const Value.absent(),
    Value<DateTime?> rewardLastClaimedAt = const Value.absent(),
    int? rewardRevision,
    int? streakCurrentDays,
    Value<String?> streakLastQualifiedDayKey = const Value.absent(),
    int? streakLongestDays,
    String? streakClaimedMilestonesJson,
    String? streakCycleId,
    int? streakRevision,
    Value<String?> challengeCurrentDayKey = const Value.absent(),
    Value<String?> challengeId = const Value.absent(),
    bool? challengeCompleted,
    bool? challengeRewardGranted,
    Value<DateTime?> challengeCompletedAt = const Value.absent(),
    int? challengeAttemptCount,
    DateTime? fetchedAt,
  }) => DailyStateCacheRow(
    id: id ?? this.id,
    dayKey: dayKey ?? this.dayKey,
    timezoneId: timezoneId ?? this.timezoneId,
    timezoneOffsetMinutes: timezoneOffsetMinutes ?? this.timezoneOffsetMinutes,
    rewardCalendarDayIndex:
        rewardCalendarDayIndex ?? this.rewardCalendarDayIndex,
    rewardLastClaimedDayKey: rewardLastClaimedDayKey.present
        ? rewardLastClaimedDayKey.value
        : this.rewardLastClaimedDayKey,
    rewardLastClaimedAt: rewardLastClaimedAt.present
        ? rewardLastClaimedAt.value
        : this.rewardLastClaimedAt,
    rewardRevision: rewardRevision ?? this.rewardRevision,
    streakCurrentDays: streakCurrentDays ?? this.streakCurrentDays,
    streakLastQualifiedDayKey: streakLastQualifiedDayKey.present
        ? streakLastQualifiedDayKey.value
        : this.streakLastQualifiedDayKey,
    streakLongestDays: streakLongestDays ?? this.streakLongestDays,
    streakClaimedMilestonesJson:
        streakClaimedMilestonesJson ?? this.streakClaimedMilestonesJson,
    streakCycleId: streakCycleId ?? this.streakCycleId,
    streakRevision: streakRevision ?? this.streakRevision,
    challengeCurrentDayKey: challengeCurrentDayKey.present
        ? challengeCurrentDayKey.value
        : this.challengeCurrentDayKey,
    challengeId: challengeId.present ? challengeId.value : this.challengeId,
    challengeCompleted: challengeCompleted ?? this.challengeCompleted,
    challengeRewardGranted:
        challengeRewardGranted ?? this.challengeRewardGranted,
    challengeCompletedAt: challengeCompletedAt.present
        ? challengeCompletedAt.value
        : this.challengeCompletedAt,
    challengeAttemptCount: challengeAttemptCount ?? this.challengeAttemptCount,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  DailyStateCacheRow copyWithCompanion(DailyStateCacheRowsCompanion data) {
    return DailyStateCacheRow(
      id: data.id.present ? data.id.value : this.id,
      dayKey: data.dayKey.present ? data.dayKey.value : this.dayKey,
      timezoneId: data.timezoneId.present
          ? data.timezoneId.value
          : this.timezoneId,
      timezoneOffsetMinutes: data.timezoneOffsetMinutes.present
          ? data.timezoneOffsetMinutes.value
          : this.timezoneOffsetMinutes,
      rewardCalendarDayIndex: data.rewardCalendarDayIndex.present
          ? data.rewardCalendarDayIndex.value
          : this.rewardCalendarDayIndex,
      rewardLastClaimedDayKey: data.rewardLastClaimedDayKey.present
          ? data.rewardLastClaimedDayKey.value
          : this.rewardLastClaimedDayKey,
      rewardLastClaimedAt: data.rewardLastClaimedAt.present
          ? data.rewardLastClaimedAt.value
          : this.rewardLastClaimedAt,
      rewardRevision: data.rewardRevision.present
          ? data.rewardRevision.value
          : this.rewardRevision,
      streakCurrentDays: data.streakCurrentDays.present
          ? data.streakCurrentDays.value
          : this.streakCurrentDays,
      streakLastQualifiedDayKey: data.streakLastQualifiedDayKey.present
          ? data.streakLastQualifiedDayKey.value
          : this.streakLastQualifiedDayKey,
      streakLongestDays: data.streakLongestDays.present
          ? data.streakLongestDays.value
          : this.streakLongestDays,
      streakClaimedMilestonesJson: data.streakClaimedMilestonesJson.present
          ? data.streakClaimedMilestonesJson.value
          : this.streakClaimedMilestonesJson,
      streakCycleId: data.streakCycleId.present
          ? data.streakCycleId.value
          : this.streakCycleId,
      streakRevision: data.streakRevision.present
          ? data.streakRevision.value
          : this.streakRevision,
      challengeCurrentDayKey: data.challengeCurrentDayKey.present
          ? data.challengeCurrentDayKey.value
          : this.challengeCurrentDayKey,
      challengeId: data.challengeId.present
          ? data.challengeId.value
          : this.challengeId,
      challengeCompleted: data.challengeCompleted.present
          ? data.challengeCompleted.value
          : this.challengeCompleted,
      challengeRewardGranted: data.challengeRewardGranted.present
          ? data.challengeRewardGranted.value
          : this.challengeRewardGranted,
      challengeCompletedAt: data.challengeCompletedAt.present
          ? data.challengeCompletedAt.value
          : this.challengeCompletedAt,
      challengeAttemptCount: data.challengeAttemptCount.present
          ? data.challengeAttemptCount.value
          : this.challengeAttemptCount,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyStateCacheRow(')
          ..write('id: $id, ')
          ..write('dayKey: $dayKey, ')
          ..write('timezoneId: $timezoneId, ')
          ..write('timezoneOffsetMinutes: $timezoneOffsetMinutes, ')
          ..write('rewardCalendarDayIndex: $rewardCalendarDayIndex, ')
          ..write('rewardLastClaimedDayKey: $rewardLastClaimedDayKey, ')
          ..write('rewardLastClaimedAt: $rewardLastClaimedAt, ')
          ..write('rewardRevision: $rewardRevision, ')
          ..write('streakCurrentDays: $streakCurrentDays, ')
          ..write('streakLastQualifiedDayKey: $streakLastQualifiedDayKey, ')
          ..write('streakLongestDays: $streakLongestDays, ')
          ..write('streakClaimedMilestonesJson: $streakClaimedMilestonesJson, ')
          ..write('streakCycleId: $streakCycleId, ')
          ..write('streakRevision: $streakRevision, ')
          ..write('challengeCurrentDayKey: $challengeCurrentDayKey, ')
          ..write('challengeId: $challengeId, ')
          ..write('challengeCompleted: $challengeCompleted, ')
          ..write('challengeRewardGranted: $challengeRewardGranted, ')
          ..write('challengeCompletedAt: $challengeCompletedAt, ')
          ..write('challengeAttemptCount: $challengeAttemptCount, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    dayKey,
    timezoneId,
    timezoneOffsetMinutes,
    rewardCalendarDayIndex,
    rewardLastClaimedDayKey,
    rewardLastClaimedAt,
    rewardRevision,
    streakCurrentDays,
    streakLastQualifiedDayKey,
    streakLongestDays,
    streakClaimedMilestonesJson,
    streakCycleId,
    streakRevision,
    challengeCurrentDayKey,
    challengeId,
    challengeCompleted,
    challengeRewardGranted,
    challengeCompletedAt,
    challengeAttemptCount,
    fetchedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyStateCacheRow &&
          other.id == this.id &&
          other.dayKey == this.dayKey &&
          other.timezoneId == this.timezoneId &&
          other.timezoneOffsetMinutes == this.timezoneOffsetMinutes &&
          other.rewardCalendarDayIndex == this.rewardCalendarDayIndex &&
          other.rewardLastClaimedDayKey == this.rewardLastClaimedDayKey &&
          other.rewardLastClaimedAt == this.rewardLastClaimedAt &&
          other.rewardRevision == this.rewardRevision &&
          other.streakCurrentDays == this.streakCurrentDays &&
          other.streakLastQualifiedDayKey == this.streakLastQualifiedDayKey &&
          other.streakLongestDays == this.streakLongestDays &&
          other.streakClaimedMilestonesJson ==
              this.streakClaimedMilestonesJson &&
          other.streakCycleId == this.streakCycleId &&
          other.streakRevision == this.streakRevision &&
          other.challengeCurrentDayKey == this.challengeCurrentDayKey &&
          other.challengeId == this.challengeId &&
          other.challengeCompleted == this.challengeCompleted &&
          other.challengeRewardGranted == this.challengeRewardGranted &&
          other.challengeCompletedAt == this.challengeCompletedAt &&
          other.challengeAttemptCount == this.challengeAttemptCount &&
          other.fetchedAt == this.fetchedAt);
}

class DailyStateCacheRowsCompanion extends UpdateCompanion<DailyStateCacheRow> {
  final Value<String> id;
  final Value<String> dayKey;
  final Value<String> timezoneId;
  final Value<int> timezoneOffsetMinutes;
  final Value<int> rewardCalendarDayIndex;
  final Value<String?> rewardLastClaimedDayKey;
  final Value<DateTime?> rewardLastClaimedAt;
  final Value<int> rewardRevision;
  final Value<int> streakCurrentDays;
  final Value<String?> streakLastQualifiedDayKey;
  final Value<int> streakLongestDays;
  final Value<String> streakClaimedMilestonesJson;
  final Value<String> streakCycleId;
  final Value<int> streakRevision;
  final Value<String?> challengeCurrentDayKey;
  final Value<String?> challengeId;
  final Value<bool> challengeCompleted;
  final Value<bool> challengeRewardGranted;
  final Value<DateTime?> challengeCompletedAt;
  final Value<int> challengeAttemptCount;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const DailyStateCacheRowsCompanion({
    this.id = const Value.absent(),
    this.dayKey = const Value.absent(),
    this.timezoneId = const Value.absent(),
    this.timezoneOffsetMinutes = const Value.absent(),
    this.rewardCalendarDayIndex = const Value.absent(),
    this.rewardLastClaimedDayKey = const Value.absent(),
    this.rewardLastClaimedAt = const Value.absent(),
    this.rewardRevision = const Value.absent(),
    this.streakCurrentDays = const Value.absent(),
    this.streakLastQualifiedDayKey = const Value.absent(),
    this.streakLongestDays = const Value.absent(),
    this.streakClaimedMilestonesJson = const Value.absent(),
    this.streakCycleId = const Value.absent(),
    this.streakRevision = const Value.absent(),
    this.challengeCurrentDayKey = const Value.absent(),
    this.challengeId = const Value.absent(),
    this.challengeCompleted = const Value.absent(),
    this.challengeRewardGranted = const Value.absent(),
    this.challengeCompletedAt = const Value.absent(),
    this.challengeAttemptCount = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyStateCacheRowsCompanion.insert({
    required String id,
    required String dayKey,
    this.timezoneId = const Value.absent(),
    this.timezoneOffsetMinutes = const Value.absent(),
    this.rewardCalendarDayIndex = const Value.absent(),
    this.rewardLastClaimedDayKey = const Value.absent(),
    this.rewardLastClaimedAt = const Value.absent(),
    this.rewardRevision = const Value.absent(),
    this.streakCurrentDays = const Value.absent(),
    this.streakLastQualifiedDayKey = const Value.absent(),
    this.streakLongestDays = const Value.absent(),
    this.streakClaimedMilestonesJson = const Value.absent(),
    this.streakCycleId = const Value.absent(),
    this.streakRevision = const Value.absent(),
    this.challengeCurrentDayKey = const Value.absent(),
    this.challengeId = const Value.absent(),
    this.challengeCompleted = const Value.absent(),
    this.challengeRewardGranted = const Value.absent(),
    this.challengeCompletedAt = const Value.absent(),
    this.challengeAttemptCount = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       dayKey = Value(dayKey);
  static Insertable<DailyStateCacheRow> custom({
    Expression<String>? id,
    Expression<String>? dayKey,
    Expression<String>? timezoneId,
    Expression<int>? timezoneOffsetMinutes,
    Expression<int>? rewardCalendarDayIndex,
    Expression<String>? rewardLastClaimedDayKey,
    Expression<DateTime>? rewardLastClaimedAt,
    Expression<int>? rewardRevision,
    Expression<int>? streakCurrentDays,
    Expression<String>? streakLastQualifiedDayKey,
    Expression<int>? streakLongestDays,
    Expression<String>? streakClaimedMilestonesJson,
    Expression<String>? streakCycleId,
    Expression<int>? streakRevision,
    Expression<String>? challengeCurrentDayKey,
    Expression<String>? challengeId,
    Expression<bool>? challengeCompleted,
    Expression<bool>? challengeRewardGranted,
    Expression<DateTime>? challengeCompletedAt,
    Expression<int>? challengeAttemptCount,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayKey != null) 'day_key': dayKey,
      if (timezoneId != null) 'timezone_id': timezoneId,
      if (timezoneOffsetMinutes != null)
        'timezone_offset_minutes': timezoneOffsetMinutes,
      if (rewardCalendarDayIndex != null)
        'reward_calendar_day_index': rewardCalendarDayIndex,
      if (rewardLastClaimedDayKey != null)
        'reward_last_claimed_day_key': rewardLastClaimedDayKey,
      if (rewardLastClaimedAt != null)
        'reward_last_claimed_at': rewardLastClaimedAt,
      if (rewardRevision != null) 'reward_revision': rewardRevision,
      if (streakCurrentDays != null) 'streak_current_days': streakCurrentDays,
      if (streakLastQualifiedDayKey != null)
        'streak_last_qualified_day_key': streakLastQualifiedDayKey,
      if (streakLongestDays != null) 'streak_longest_days': streakLongestDays,
      if (streakClaimedMilestonesJson != null)
        'streak_claimed_milestones_json': streakClaimedMilestonesJson,
      if (streakCycleId != null) 'streak_cycle_id': streakCycleId,
      if (streakRevision != null) 'streak_revision': streakRevision,
      if (challengeCurrentDayKey != null)
        'challenge_current_day_key': challengeCurrentDayKey,
      if (challengeId != null) 'challenge_id': challengeId,
      if (challengeCompleted != null) 'challenge_completed': challengeCompleted,
      if (challengeRewardGranted != null)
        'challenge_reward_granted': challengeRewardGranted,
      if (challengeCompletedAt != null)
        'challenge_completed_at': challengeCompletedAt,
      if (challengeAttemptCount != null)
        'challenge_attempt_count': challengeAttemptCount,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyStateCacheRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? dayKey,
    Value<String>? timezoneId,
    Value<int>? timezoneOffsetMinutes,
    Value<int>? rewardCalendarDayIndex,
    Value<String?>? rewardLastClaimedDayKey,
    Value<DateTime?>? rewardLastClaimedAt,
    Value<int>? rewardRevision,
    Value<int>? streakCurrentDays,
    Value<String?>? streakLastQualifiedDayKey,
    Value<int>? streakLongestDays,
    Value<String>? streakClaimedMilestonesJson,
    Value<String>? streakCycleId,
    Value<int>? streakRevision,
    Value<String?>? challengeCurrentDayKey,
    Value<String?>? challengeId,
    Value<bool>? challengeCompleted,
    Value<bool>? challengeRewardGranted,
    Value<DateTime?>? challengeCompletedAt,
    Value<int>? challengeAttemptCount,
    Value<DateTime>? fetchedAt,
    Value<int>? rowid,
  }) {
    return DailyStateCacheRowsCompanion(
      id: id ?? this.id,
      dayKey: dayKey ?? this.dayKey,
      timezoneId: timezoneId ?? this.timezoneId,
      timezoneOffsetMinutes:
          timezoneOffsetMinutes ?? this.timezoneOffsetMinutes,
      rewardCalendarDayIndex:
          rewardCalendarDayIndex ?? this.rewardCalendarDayIndex,
      rewardLastClaimedDayKey:
          rewardLastClaimedDayKey ?? this.rewardLastClaimedDayKey,
      rewardLastClaimedAt: rewardLastClaimedAt ?? this.rewardLastClaimedAt,
      rewardRevision: rewardRevision ?? this.rewardRevision,
      streakCurrentDays: streakCurrentDays ?? this.streakCurrentDays,
      streakLastQualifiedDayKey:
          streakLastQualifiedDayKey ?? this.streakLastQualifiedDayKey,
      streakLongestDays: streakLongestDays ?? this.streakLongestDays,
      streakClaimedMilestonesJson:
          streakClaimedMilestonesJson ?? this.streakClaimedMilestonesJson,
      streakCycleId: streakCycleId ?? this.streakCycleId,
      streakRevision: streakRevision ?? this.streakRevision,
      challengeCurrentDayKey:
          challengeCurrentDayKey ?? this.challengeCurrentDayKey,
      challengeId: challengeId ?? this.challengeId,
      challengeCompleted: challengeCompleted ?? this.challengeCompleted,
      challengeRewardGranted:
          challengeRewardGranted ?? this.challengeRewardGranted,
      challengeCompletedAt: challengeCompletedAt ?? this.challengeCompletedAt,
      challengeAttemptCount:
          challengeAttemptCount ?? this.challengeAttemptCount,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dayKey.present) {
      map['day_key'] = Variable<String>(dayKey.value);
    }
    if (timezoneId.present) {
      map['timezone_id'] = Variable<String>(timezoneId.value);
    }
    if (timezoneOffsetMinutes.present) {
      map['timezone_offset_minutes'] = Variable<int>(
        timezoneOffsetMinutes.value,
      );
    }
    if (rewardCalendarDayIndex.present) {
      map['reward_calendar_day_index'] = Variable<int>(
        rewardCalendarDayIndex.value,
      );
    }
    if (rewardLastClaimedDayKey.present) {
      map['reward_last_claimed_day_key'] = Variable<String>(
        rewardLastClaimedDayKey.value,
      );
    }
    if (rewardLastClaimedAt.present) {
      map['reward_last_claimed_at'] = Variable<DateTime>(
        rewardLastClaimedAt.value,
      );
    }
    if (rewardRevision.present) {
      map['reward_revision'] = Variable<int>(rewardRevision.value);
    }
    if (streakCurrentDays.present) {
      map['streak_current_days'] = Variable<int>(streakCurrentDays.value);
    }
    if (streakLastQualifiedDayKey.present) {
      map['streak_last_qualified_day_key'] = Variable<String>(
        streakLastQualifiedDayKey.value,
      );
    }
    if (streakLongestDays.present) {
      map['streak_longest_days'] = Variable<int>(streakLongestDays.value);
    }
    if (streakClaimedMilestonesJson.present) {
      map['streak_claimed_milestones_json'] = Variable<String>(
        streakClaimedMilestonesJson.value,
      );
    }
    if (streakCycleId.present) {
      map['streak_cycle_id'] = Variable<String>(streakCycleId.value);
    }
    if (streakRevision.present) {
      map['streak_revision'] = Variable<int>(streakRevision.value);
    }
    if (challengeCurrentDayKey.present) {
      map['challenge_current_day_key'] = Variable<String>(
        challengeCurrentDayKey.value,
      );
    }
    if (challengeId.present) {
      map['challenge_id'] = Variable<String>(challengeId.value);
    }
    if (challengeCompleted.present) {
      map['challenge_completed'] = Variable<bool>(challengeCompleted.value);
    }
    if (challengeRewardGranted.present) {
      map['challenge_reward_granted'] = Variable<bool>(
        challengeRewardGranted.value,
      );
    }
    if (challengeCompletedAt.present) {
      map['challenge_completed_at'] = Variable<DateTime>(
        challengeCompletedAt.value,
      );
    }
    if (challengeAttemptCount.present) {
      map['challenge_attempt_count'] = Variable<int>(
        challengeAttemptCount.value,
      );
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyStateCacheRowsCompanion(')
          ..write('id: $id, ')
          ..write('dayKey: $dayKey, ')
          ..write('timezoneId: $timezoneId, ')
          ..write('timezoneOffsetMinutes: $timezoneOffsetMinutes, ')
          ..write('rewardCalendarDayIndex: $rewardCalendarDayIndex, ')
          ..write('rewardLastClaimedDayKey: $rewardLastClaimedDayKey, ')
          ..write('rewardLastClaimedAt: $rewardLastClaimedAt, ')
          ..write('rewardRevision: $rewardRevision, ')
          ..write('streakCurrentDays: $streakCurrentDays, ')
          ..write('streakLastQualifiedDayKey: $streakLastQualifiedDayKey, ')
          ..write('streakLongestDays: $streakLongestDays, ')
          ..write('streakClaimedMilestonesJson: $streakClaimedMilestonesJson, ')
          ..write('streakCycleId: $streakCycleId, ')
          ..write('streakRevision: $streakRevision, ')
          ..write('challengeCurrentDayKey: $challengeCurrentDayKey, ')
          ..write('challengeId: $challengeId, ')
          ..write('challengeCompleted: $challengeCompleted, ')
          ..write('challengeRewardGranted: $challengeRewardGranted, ')
          ..write('challengeCompletedAt: $challengeCompletedAt, ')
          ..write('challengeAttemptCount: $challengeAttemptCount, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyChallengeCacheRowsTable extends DailyChallengeCacheRows
    with TableInfo<$DailyChallengeCacheRowsTable, DailyChallengeCacheRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyChallengeCacheRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _challengeIdMeta = const VerificationMeta(
    'challengeId',
  );
  @override
  late final GeneratedColumn<String> challengeId = GeneratedColumn<String>(
    'challenge_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayKeyMeta = const VerificationMeta('dayKey');
  @override
  late final GeneratedColumn<String> dayKey = GeneratedColumn<String>(
    'day_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cohortKeyMeta = const VerificationMeta(
    'cohortKey',
  );
  @override
  late final GeneratedColumn<String> cohortKey = GeneratedColumn<String>(
    'cohort_key',
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
  static const VerificationMeta _rewardAmountMeta = const VerificationMeta(
    'rewardAmount',
  );
  @override
  late final GeneratedColumn<int> rewardAmount = GeneratedColumn<int>(
    'reward_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeFromMeta = const VerificationMeta(
    'activeFrom',
  );
  @override
  late final GeneratedColumn<DateTime> activeFrom = GeneratedColumn<DateTime>(
    'active_from',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeUntilMeta = const VerificationMeta(
    'activeUntil',
  );
  @override
  late final GeneratedColumn<DateTime> activeUntil = GeneratedColumn<DateTime>(
    'active_until',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rulesVersionMeta = const VerificationMeta(
    'rulesVersion',
  );
  @override
  late final GeneratedColumn<int> rulesVersion = GeneratedColumn<int>(
    'rules_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _generatorVersionMeta = const VerificationMeta(
    'generatorVersion',
  );
  @override
  late final GeneratedColumn<int> generatorVersion = GeneratedColumn<int>(
    'generator_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _solverVersionMeta = const VerificationMeta(
    'solverVersion',
  );
  @override
  late final GeneratedColumn<int> solverVersion = GeneratedColumn<int>(
    'solver_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentBundleVersionMeta =
      const VerificationMeta('contentBundleVersion');
  @override
  late final GeneratedColumn<String> contentBundleVersion =
      GeneratedColumn<String>(
        'content_bundle_version',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _boardFingerprintMeta = const VerificationMeta(
    'boardFingerprint',
  );
  @override
  late final GeneratedColumn<String> boardFingerprint = GeneratedColumn<String>(
    'board_fingerprint',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    challengeId,
    dayKey,
    cohortKey,
    seed,
    rewardAmount,
    activeFrom,
    activeUntil,
    rulesVersion,
    generatorVersion,
    solverVersion,
    contentBundleVersion,
    boardFingerprint,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_challenge_cache_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyChallengeCacheRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('challenge_id')) {
      context.handle(
        _challengeIdMeta,
        challengeId.isAcceptableOrUnknown(
          data['challenge_id']!,
          _challengeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_challengeIdMeta);
    }
    if (data.containsKey('day_key')) {
      context.handle(
        _dayKeyMeta,
        dayKey.isAcceptableOrUnknown(data['day_key']!, _dayKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dayKeyMeta);
    }
    if (data.containsKey('cohort_key')) {
      context.handle(
        _cohortKeyMeta,
        cohortKey.isAcceptableOrUnknown(data['cohort_key']!, _cohortKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_cohortKeyMeta);
    }
    if (data.containsKey('seed')) {
      context.handle(
        _seedMeta,
        seed.isAcceptableOrUnknown(data['seed']!, _seedMeta),
      );
    } else if (isInserting) {
      context.missing(_seedMeta);
    }
    if (data.containsKey('reward_amount')) {
      context.handle(
        _rewardAmountMeta,
        rewardAmount.isAcceptableOrUnknown(
          data['reward_amount']!,
          _rewardAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rewardAmountMeta);
    }
    if (data.containsKey('active_from')) {
      context.handle(
        _activeFromMeta,
        activeFrom.isAcceptableOrUnknown(data['active_from']!, _activeFromMeta),
      );
    } else if (isInserting) {
      context.missing(_activeFromMeta);
    }
    if (data.containsKey('active_until')) {
      context.handle(
        _activeUntilMeta,
        activeUntil.isAcceptableOrUnknown(
          data['active_until']!,
          _activeUntilMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activeUntilMeta);
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
    if (data.containsKey('generator_version')) {
      context.handle(
        _generatorVersionMeta,
        generatorVersion.isAcceptableOrUnknown(
          data['generator_version']!,
          _generatorVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_generatorVersionMeta);
    }
    if (data.containsKey('solver_version')) {
      context.handle(
        _solverVersionMeta,
        solverVersion.isAcceptableOrUnknown(
          data['solver_version']!,
          _solverVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_solverVersionMeta);
    }
    if (data.containsKey('content_bundle_version')) {
      context.handle(
        _contentBundleVersionMeta,
        contentBundleVersion.isAcceptableOrUnknown(
          data['content_bundle_version']!,
          _contentBundleVersionMeta,
        ),
      );
    }
    if (data.containsKey('board_fingerprint')) {
      context.handle(
        _boardFingerprintMeta,
        boardFingerprint.isAcceptableOrUnknown(
          data['board_fingerprint']!,
          _boardFingerprintMeta,
        ),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {challengeId};
  @override
  DailyChallengeCacheRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyChallengeCacheRow(
      challengeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}challenge_id'],
      )!,
      dayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_key'],
      )!,
      cohortKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cohort_key'],
      )!,
      seed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seed'],
      )!,
      rewardAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reward_amount'],
      )!,
      activeFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}active_from'],
      )!,
      activeUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}active_until'],
      )!,
      rulesVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rules_version'],
      )!,
      generatorVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}generator_version'],
      )!,
      solverVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}solver_version'],
      )!,
      contentBundleVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_bundle_version'],
      ),
      boardFingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}board_fingerprint'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $DailyChallengeCacheRowsTable createAlias(String alias) {
    return $DailyChallengeCacheRowsTable(attachedDatabase, alias);
  }
}

class DailyChallengeCacheRow extends DataClass
    implements Insertable<DailyChallengeCacheRow> {
  final String challengeId;
  final String dayKey;
  final String cohortKey;
  final int seed;
  final int rewardAmount;
  final DateTime activeFrom;
  final DateTime activeUntil;
  final int rulesVersion;
  final int generatorVersion;
  final int solverVersion;
  final String? contentBundleVersion;
  final String? boardFingerprint;
  final DateTime cachedAt;
  const DailyChallengeCacheRow({
    required this.challengeId,
    required this.dayKey,
    required this.cohortKey,
    required this.seed,
    required this.rewardAmount,
    required this.activeFrom,
    required this.activeUntil,
    required this.rulesVersion,
    required this.generatorVersion,
    required this.solverVersion,
    this.contentBundleVersion,
    this.boardFingerprint,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['challenge_id'] = Variable<String>(challengeId);
    map['day_key'] = Variable<String>(dayKey);
    map['cohort_key'] = Variable<String>(cohortKey);
    map['seed'] = Variable<int>(seed);
    map['reward_amount'] = Variable<int>(rewardAmount);
    map['active_from'] = Variable<DateTime>(activeFrom);
    map['active_until'] = Variable<DateTime>(activeUntil);
    map['rules_version'] = Variable<int>(rulesVersion);
    map['generator_version'] = Variable<int>(generatorVersion);
    map['solver_version'] = Variable<int>(solverVersion);
    if (!nullToAbsent || contentBundleVersion != null) {
      map['content_bundle_version'] = Variable<String>(contentBundleVersion);
    }
    if (!nullToAbsent || boardFingerprint != null) {
      map['board_fingerprint'] = Variable<String>(boardFingerprint);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  DailyChallengeCacheRowsCompanion toCompanion(bool nullToAbsent) {
    return DailyChallengeCacheRowsCompanion(
      challengeId: Value(challengeId),
      dayKey: Value(dayKey),
      cohortKey: Value(cohortKey),
      seed: Value(seed),
      rewardAmount: Value(rewardAmount),
      activeFrom: Value(activeFrom),
      activeUntil: Value(activeUntil),
      rulesVersion: Value(rulesVersion),
      generatorVersion: Value(generatorVersion),
      solverVersion: Value(solverVersion),
      contentBundleVersion: contentBundleVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(contentBundleVersion),
      boardFingerprint: boardFingerprint == null && nullToAbsent
          ? const Value.absent()
          : Value(boardFingerprint),
      cachedAt: Value(cachedAt),
    );
  }

  factory DailyChallengeCacheRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyChallengeCacheRow(
      challengeId: serializer.fromJson<String>(json['challengeId']),
      dayKey: serializer.fromJson<String>(json['dayKey']),
      cohortKey: serializer.fromJson<String>(json['cohortKey']),
      seed: serializer.fromJson<int>(json['seed']),
      rewardAmount: serializer.fromJson<int>(json['rewardAmount']),
      activeFrom: serializer.fromJson<DateTime>(json['activeFrom']),
      activeUntil: serializer.fromJson<DateTime>(json['activeUntil']),
      rulesVersion: serializer.fromJson<int>(json['rulesVersion']),
      generatorVersion: serializer.fromJson<int>(json['generatorVersion']),
      solverVersion: serializer.fromJson<int>(json['solverVersion']),
      contentBundleVersion: serializer.fromJson<String?>(
        json['contentBundleVersion'],
      ),
      boardFingerprint: serializer.fromJson<String?>(json['boardFingerprint']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'challengeId': serializer.toJson<String>(challengeId),
      'dayKey': serializer.toJson<String>(dayKey),
      'cohortKey': serializer.toJson<String>(cohortKey),
      'seed': serializer.toJson<int>(seed),
      'rewardAmount': serializer.toJson<int>(rewardAmount),
      'activeFrom': serializer.toJson<DateTime>(activeFrom),
      'activeUntil': serializer.toJson<DateTime>(activeUntil),
      'rulesVersion': serializer.toJson<int>(rulesVersion),
      'generatorVersion': serializer.toJson<int>(generatorVersion),
      'solverVersion': serializer.toJson<int>(solverVersion),
      'contentBundleVersion': serializer.toJson<String?>(contentBundleVersion),
      'boardFingerprint': serializer.toJson<String?>(boardFingerprint),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  DailyChallengeCacheRow copyWith({
    String? challengeId,
    String? dayKey,
    String? cohortKey,
    int? seed,
    int? rewardAmount,
    DateTime? activeFrom,
    DateTime? activeUntil,
    int? rulesVersion,
    int? generatorVersion,
    int? solverVersion,
    Value<String?> contentBundleVersion = const Value.absent(),
    Value<String?> boardFingerprint = const Value.absent(),
    DateTime? cachedAt,
  }) => DailyChallengeCacheRow(
    challengeId: challengeId ?? this.challengeId,
    dayKey: dayKey ?? this.dayKey,
    cohortKey: cohortKey ?? this.cohortKey,
    seed: seed ?? this.seed,
    rewardAmount: rewardAmount ?? this.rewardAmount,
    activeFrom: activeFrom ?? this.activeFrom,
    activeUntil: activeUntil ?? this.activeUntil,
    rulesVersion: rulesVersion ?? this.rulesVersion,
    generatorVersion: generatorVersion ?? this.generatorVersion,
    solverVersion: solverVersion ?? this.solverVersion,
    contentBundleVersion: contentBundleVersion.present
        ? contentBundleVersion.value
        : this.contentBundleVersion,
    boardFingerprint: boardFingerprint.present
        ? boardFingerprint.value
        : this.boardFingerprint,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  DailyChallengeCacheRow copyWithCompanion(
    DailyChallengeCacheRowsCompanion data,
  ) {
    return DailyChallengeCacheRow(
      challengeId: data.challengeId.present
          ? data.challengeId.value
          : this.challengeId,
      dayKey: data.dayKey.present ? data.dayKey.value : this.dayKey,
      cohortKey: data.cohortKey.present ? data.cohortKey.value : this.cohortKey,
      seed: data.seed.present ? data.seed.value : this.seed,
      rewardAmount: data.rewardAmount.present
          ? data.rewardAmount.value
          : this.rewardAmount,
      activeFrom: data.activeFrom.present
          ? data.activeFrom.value
          : this.activeFrom,
      activeUntil: data.activeUntil.present
          ? data.activeUntil.value
          : this.activeUntil,
      rulesVersion: data.rulesVersion.present
          ? data.rulesVersion.value
          : this.rulesVersion,
      generatorVersion: data.generatorVersion.present
          ? data.generatorVersion.value
          : this.generatorVersion,
      solverVersion: data.solverVersion.present
          ? data.solverVersion.value
          : this.solverVersion,
      contentBundleVersion: data.contentBundleVersion.present
          ? data.contentBundleVersion.value
          : this.contentBundleVersion,
      boardFingerprint: data.boardFingerprint.present
          ? data.boardFingerprint.value
          : this.boardFingerprint,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyChallengeCacheRow(')
          ..write('challengeId: $challengeId, ')
          ..write('dayKey: $dayKey, ')
          ..write('cohortKey: $cohortKey, ')
          ..write('seed: $seed, ')
          ..write('rewardAmount: $rewardAmount, ')
          ..write('activeFrom: $activeFrom, ')
          ..write('activeUntil: $activeUntil, ')
          ..write('rulesVersion: $rulesVersion, ')
          ..write('generatorVersion: $generatorVersion, ')
          ..write('solverVersion: $solverVersion, ')
          ..write('contentBundleVersion: $contentBundleVersion, ')
          ..write('boardFingerprint: $boardFingerprint, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    challengeId,
    dayKey,
    cohortKey,
    seed,
    rewardAmount,
    activeFrom,
    activeUntil,
    rulesVersion,
    generatorVersion,
    solverVersion,
    contentBundleVersion,
    boardFingerprint,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyChallengeCacheRow &&
          other.challengeId == this.challengeId &&
          other.dayKey == this.dayKey &&
          other.cohortKey == this.cohortKey &&
          other.seed == this.seed &&
          other.rewardAmount == this.rewardAmount &&
          other.activeFrom == this.activeFrom &&
          other.activeUntil == this.activeUntil &&
          other.rulesVersion == this.rulesVersion &&
          other.generatorVersion == this.generatorVersion &&
          other.solverVersion == this.solverVersion &&
          other.contentBundleVersion == this.contentBundleVersion &&
          other.boardFingerprint == this.boardFingerprint &&
          other.cachedAt == this.cachedAt);
}

class DailyChallengeCacheRowsCompanion
    extends UpdateCompanion<DailyChallengeCacheRow> {
  final Value<String> challengeId;
  final Value<String> dayKey;
  final Value<String> cohortKey;
  final Value<int> seed;
  final Value<int> rewardAmount;
  final Value<DateTime> activeFrom;
  final Value<DateTime> activeUntil;
  final Value<int> rulesVersion;
  final Value<int> generatorVersion;
  final Value<int> solverVersion;
  final Value<String?> contentBundleVersion;
  final Value<String?> boardFingerprint;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const DailyChallengeCacheRowsCompanion({
    this.challengeId = const Value.absent(),
    this.dayKey = const Value.absent(),
    this.cohortKey = const Value.absent(),
    this.seed = const Value.absent(),
    this.rewardAmount = const Value.absent(),
    this.activeFrom = const Value.absent(),
    this.activeUntil = const Value.absent(),
    this.rulesVersion = const Value.absent(),
    this.generatorVersion = const Value.absent(),
    this.solverVersion = const Value.absent(),
    this.contentBundleVersion = const Value.absent(),
    this.boardFingerprint = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyChallengeCacheRowsCompanion.insert({
    required String challengeId,
    required String dayKey,
    required String cohortKey,
    required int seed,
    required int rewardAmount,
    required DateTime activeFrom,
    required DateTime activeUntil,
    required int rulesVersion,
    required int generatorVersion,
    required int solverVersion,
    this.contentBundleVersion = const Value.absent(),
    this.boardFingerprint = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : challengeId = Value(challengeId),
       dayKey = Value(dayKey),
       cohortKey = Value(cohortKey),
       seed = Value(seed),
       rewardAmount = Value(rewardAmount),
       activeFrom = Value(activeFrom),
       activeUntil = Value(activeUntil),
       rulesVersion = Value(rulesVersion),
       generatorVersion = Value(generatorVersion),
       solverVersion = Value(solverVersion);
  static Insertable<DailyChallengeCacheRow> custom({
    Expression<String>? challengeId,
    Expression<String>? dayKey,
    Expression<String>? cohortKey,
    Expression<int>? seed,
    Expression<int>? rewardAmount,
    Expression<DateTime>? activeFrom,
    Expression<DateTime>? activeUntil,
    Expression<int>? rulesVersion,
    Expression<int>? generatorVersion,
    Expression<int>? solverVersion,
    Expression<String>? contentBundleVersion,
    Expression<String>? boardFingerprint,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (challengeId != null) 'challenge_id': challengeId,
      if (dayKey != null) 'day_key': dayKey,
      if (cohortKey != null) 'cohort_key': cohortKey,
      if (seed != null) 'seed': seed,
      if (rewardAmount != null) 'reward_amount': rewardAmount,
      if (activeFrom != null) 'active_from': activeFrom,
      if (activeUntil != null) 'active_until': activeUntil,
      if (rulesVersion != null) 'rules_version': rulesVersion,
      if (generatorVersion != null) 'generator_version': generatorVersion,
      if (solverVersion != null) 'solver_version': solverVersion,
      if (contentBundleVersion != null)
        'content_bundle_version': contentBundleVersion,
      if (boardFingerprint != null) 'board_fingerprint': boardFingerprint,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyChallengeCacheRowsCompanion copyWith({
    Value<String>? challengeId,
    Value<String>? dayKey,
    Value<String>? cohortKey,
    Value<int>? seed,
    Value<int>? rewardAmount,
    Value<DateTime>? activeFrom,
    Value<DateTime>? activeUntil,
    Value<int>? rulesVersion,
    Value<int>? generatorVersion,
    Value<int>? solverVersion,
    Value<String?>? contentBundleVersion,
    Value<String?>? boardFingerprint,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return DailyChallengeCacheRowsCompanion(
      challengeId: challengeId ?? this.challengeId,
      dayKey: dayKey ?? this.dayKey,
      cohortKey: cohortKey ?? this.cohortKey,
      seed: seed ?? this.seed,
      rewardAmount: rewardAmount ?? this.rewardAmount,
      activeFrom: activeFrom ?? this.activeFrom,
      activeUntil: activeUntil ?? this.activeUntil,
      rulesVersion: rulesVersion ?? this.rulesVersion,
      generatorVersion: generatorVersion ?? this.generatorVersion,
      solverVersion: solverVersion ?? this.solverVersion,
      contentBundleVersion: contentBundleVersion ?? this.contentBundleVersion,
      boardFingerprint: boardFingerprint ?? this.boardFingerprint,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (challengeId.present) {
      map['challenge_id'] = Variable<String>(challengeId.value);
    }
    if (dayKey.present) {
      map['day_key'] = Variable<String>(dayKey.value);
    }
    if (cohortKey.present) {
      map['cohort_key'] = Variable<String>(cohortKey.value);
    }
    if (seed.present) {
      map['seed'] = Variable<int>(seed.value);
    }
    if (rewardAmount.present) {
      map['reward_amount'] = Variable<int>(rewardAmount.value);
    }
    if (activeFrom.present) {
      map['active_from'] = Variable<DateTime>(activeFrom.value);
    }
    if (activeUntil.present) {
      map['active_until'] = Variable<DateTime>(activeUntil.value);
    }
    if (rulesVersion.present) {
      map['rules_version'] = Variable<int>(rulesVersion.value);
    }
    if (generatorVersion.present) {
      map['generator_version'] = Variable<int>(generatorVersion.value);
    }
    if (solverVersion.present) {
      map['solver_version'] = Variable<int>(solverVersion.value);
    }
    if (contentBundleVersion.present) {
      map['content_bundle_version'] = Variable<String>(
        contentBundleVersion.value,
      );
    }
    if (boardFingerprint.present) {
      map['board_fingerprint'] = Variable<String>(boardFingerprint.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyChallengeCacheRowsCompanion(')
          ..write('challengeId: $challengeId, ')
          ..write('dayKey: $dayKey, ')
          ..write('cohortKey: $cohortKey, ')
          ..write('seed: $seed, ')
          ..write('rewardAmount: $rewardAmount, ')
          ..write('activeFrom: $activeFrom, ')
          ..write('activeUntil: $activeUntil, ')
          ..write('rulesVersion: $rulesVersion, ')
          ..write('generatorVersion: $generatorVersion, ')
          ..write('solverVersion: $solverVersion, ')
          ..write('contentBundleVersion: $contentBundleVersion, ')
          ..write('boardFingerprint: $boardFingerprint, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationPreferenceRowsTable extends NotificationPreferenceRows
    with
        TableInfo<$NotificationPreferenceRowsTable, NotificationPreferenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationPreferenceRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dailyChallengeEnabledMeta =
      const VerificationMeta('dailyChallengeEnabled');
  @override
  late final GeneratedColumn<bool> dailyChallengeEnabled =
      GeneratedColumn<bool>(
        'daily_challenge_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("daily_challenge_enabled" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _streakRiskEnabledMeta = const VerificationMeta(
    'streakRiskEnabled',
  );
  @override
  late final GeneratedColumn<bool> streakRiskEnabled = GeneratedColumn<bool>(
    'streak_risk_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("streak_risk_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dailyChallengeEnabled,
    streakRiskEnabled,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_preference_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationPreferenceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('daily_challenge_enabled')) {
      context.handle(
        _dailyChallengeEnabledMeta,
        dailyChallengeEnabled.isAcceptableOrUnknown(
          data['daily_challenge_enabled']!,
          _dailyChallengeEnabledMeta,
        ),
      );
    }
    if (data.containsKey('streak_risk_enabled')) {
      context.handle(
        _streakRiskEnabledMeta,
        streakRiskEnabled.isAcceptableOrUnknown(
          data['streak_risk_enabled']!,
          _streakRiskEnabledMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationPreferenceRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationPreferenceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dailyChallengeEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}daily_challenge_enabled'],
      )!,
      streakRiskEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}streak_risk_enabled'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NotificationPreferenceRowsTable createAlias(String alias) {
    return $NotificationPreferenceRowsTable(attachedDatabase, alias);
  }
}

class NotificationPreferenceRow extends DataClass
    implements Insertable<NotificationPreferenceRow> {
  final String id;
  final bool dailyChallengeEnabled;
  final bool streakRiskEnabled;
  final DateTime updatedAt;
  const NotificationPreferenceRow({
    required this.id,
    required this.dailyChallengeEnabled,
    required this.streakRiskEnabled,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['daily_challenge_enabled'] = Variable<bool>(dailyChallengeEnabled);
    map['streak_risk_enabled'] = Variable<bool>(streakRiskEnabled);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NotificationPreferenceRowsCompanion toCompanion(bool nullToAbsent) {
    return NotificationPreferenceRowsCompanion(
      id: Value(id),
      dailyChallengeEnabled: Value(dailyChallengeEnabled),
      streakRiskEnabled: Value(streakRiskEnabled),
      updatedAt: Value(updatedAt),
    );
  }

  factory NotificationPreferenceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationPreferenceRow(
      id: serializer.fromJson<String>(json['id']),
      dailyChallengeEnabled: serializer.fromJson<bool>(
        json['dailyChallengeEnabled'],
      ),
      streakRiskEnabled: serializer.fromJson<bool>(json['streakRiskEnabled']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dailyChallengeEnabled': serializer.toJson<bool>(dailyChallengeEnabled),
      'streakRiskEnabled': serializer.toJson<bool>(streakRiskEnabled),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  NotificationPreferenceRow copyWith({
    String? id,
    bool? dailyChallengeEnabled,
    bool? streakRiskEnabled,
    DateTime? updatedAt,
  }) => NotificationPreferenceRow(
    id: id ?? this.id,
    dailyChallengeEnabled: dailyChallengeEnabled ?? this.dailyChallengeEnabled,
    streakRiskEnabled: streakRiskEnabled ?? this.streakRiskEnabled,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  NotificationPreferenceRow copyWithCompanion(
    NotificationPreferenceRowsCompanion data,
  ) {
    return NotificationPreferenceRow(
      id: data.id.present ? data.id.value : this.id,
      dailyChallengeEnabled: data.dailyChallengeEnabled.present
          ? data.dailyChallengeEnabled.value
          : this.dailyChallengeEnabled,
      streakRiskEnabled: data.streakRiskEnabled.present
          ? data.streakRiskEnabled.value
          : this.streakRiskEnabled,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationPreferenceRow(')
          ..write('id: $id, ')
          ..write('dailyChallengeEnabled: $dailyChallengeEnabled, ')
          ..write('streakRiskEnabled: $streakRiskEnabled, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, dailyChallengeEnabled, streakRiskEnabled, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationPreferenceRow &&
          other.id == this.id &&
          other.dailyChallengeEnabled == this.dailyChallengeEnabled &&
          other.streakRiskEnabled == this.streakRiskEnabled &&
          other.updatedAt == this.updatedAt);
}

class NotificationPreferenceRowsCompanion
    extends UpdateCompanion<NotificationPreferenceRow> {
  final Value<String> id;
  final Value<bool> dailyChallengeEnabled;
  final Value<bool> streakRiskEnabled;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const NotificationPreferenceRowsCompanion({
    this.id = const Value.absent(),
    this.dailyChallengeEnabled = const Value.absent(),
    this.streakRiskEnabled = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationPreferenceRowsCompanion.insert({
    required String id,
    this.dailyChallengeEnabled = const Value.absent(),
    this.streakRiskEnabled = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<NotificationPreferenceRow> custom({
    Expression<String>? id,
    Expression<bool>? dailyChallengeEnabled,
    Expression<bool>? streakRiskEnabled,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dailyChallengeEnabled != null)
        'daily_challenge_enabled': dailyChallengeEnabled,
      if (streakRiskEnabled != null) 'streak_risk_enabled': streakRiskEnabled,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationPreferenceRowsCompanion copyWith({
    Value<String>? id,
    Value<bool>? dailyChallengeEnabled,
    Value<bool>? streakRiskEnabled,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return NotificationPreferenceRowsCompanion(
      id: id ?? this.id,
      dailyChallengeEnabled:
          dailyChallengeEnabled ?? this.dailyChallengeEnabled,
      streakRiskEnabled: streakRiskEnabled ?? this.streakRiskEnabled,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dailyChallengeEnabled.present) {
      map['daily_challenge_enabled'] = Variable<bool>(
        dailyChallengeEnabled.value,
      );
    }
    if (streakRiskEnabled.present) {
      map['streak_risk_enabled'] = Variable<bool>(streakRiskEnabled.value);
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
    return (StringBuffer('NotificationPreferenceRowsCompanion(')
          ..write('id: $id, ')
          ..write('dailyChallengeEnabled: $dailyChallengeEnabled, ')
          ..write('streakRiskEnabled: $streakRiskEnabled, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeviceRegistrationRowsTable extends DeviceRegistrationRows
    with TableInfo<$DeviceRegistrationRowsTable, DeviceRegistrationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceRegistrationRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fcmTokenMeta = const VerificationMeta(
    'fcmToken',
  );
  @override
  late final GeneratedColumn<String> fcmToken = GeneratedColumn<String>(
    'fcm_token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timezoneIdMeta = const VerificationMeta(
    'timezoneId',
  );
  @override
  late final GeneratedColumn<String> timezoneId = GeneratedColumn<String>(
    'timezone_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UTC'),
  );
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
    'notifications_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifications_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _appVersionMeta = const VerificationMeta(
    'appVersion',
  );
  @override
  late final GeneratedColumn<String> appVersion = GeneratedColumn<String>(
    'app_version',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _registeredAtMeta = const VerificationMeta(
    'registeredAt',
  );
  @override
  late final GeneratedColumn<DateTime> registeredAt = GeneratedColumn<DateTime>(
    'registered_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _lastSeenAtMeta = const VerificationMeta(
    'lastSeenAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSeenAt = GeneratedColumn<DateTime>(
    'last_seen_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    deviceId,
    fcmToken,
    platform,
    timezoneId,
    notificationsEnabled,
    appVersion,
    registeredAt,
    lastSeenAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_registration_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeviceRegistrationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('fcm_token')) {
      context.handle(
        _fcmTokenMeta,
        fcmToken.isAcceptableOrUnknown(data['fcm_token']!, _fcmTokenMeta),
      );
    } else if (isInserting) {
      context.missing(_fcmTokenMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    if (data.containsKey('timezone_id')) {
      context.handle(
        _timezoneIdMeta,
        timezoneId.isAcceptableOrUnknown(data['timezone_id']!, _timezoneIdMeta),
      );
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
        _notificationsEnabledMeta,
        notificationsEnabled.isAcceptableOrUnknown(
          data['notifications_enabled']!,
          _notificationsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('app_version')) {
      context.handle(
        _appVersionMeta,
        appVersion.isAcceptableOrUnknown(data['app_version']!, _appVersionMeta),
      );
    }
    if (data.containsKey('registered_at')) {
      context.handle(
        _registeredAtMeta,
        registeredAt.isAcceptableOrUnknown(
          data['registered_at']!,
          _registeredAtMeta,
        ),
      );
    }
    if (data.containsKey('last_seen_at')) {
      context.handle(
        _lastSeenAtMeta,
        lastSeenAt.isAcceptableOrUnknown(
          data['last_seen_at']!,
          _lastSeenAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deviceId};
  @override
  DeviceRegistrationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceRegistrationRow(
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      fcmToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fcm_token'],
      )!,
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      )!,
      timezoneId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone_id'],
      )!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifications_enabled'],
      )!,
      appVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_version'],
      ),
      registeredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}registered_at'],
      )!,
      lastSeenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_seen_at'],
      )!,
    );
  }

  @override
  $DeviceRegistrationRowsTable createAlias(String alias) {
    return $DeviceRegistrationRowsTable(attachedDatabase, alias);
  }
}

class DeviceRegistrationRow extends DataClass
    implements Insertable<DeviceRegistrationRow> {
  final String deviceId;
  final String fcmToken;
  final String platform;
  final String timezoneId;
  final bool notificationsEnabled;
  final String? appVersion;
  final DateTime registeredAt;
  final DateTime lastSeenAt;
  const DeviceRegistrationRow({
    required this.deviceId,
    required this.fcmToken,
    required this.platform,
    required this.timezoneId,
    required this.notificationsEnabled,
    this.appVersion,
    required this.registeredAt,
    required this.lastSeenAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['device_id'] = Variable<String>(deviceId);
    map['fcm_token'] = Variable<String>(fcmToken);
    map['platform'] = Variable<String>(platform);
    map['timezone_id'] = Variable<String>(timezoneId);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    if (!nullToAbsent || appVersion != null) {
      map['app_version'] = Variable<String>(appVersion);
    }
    map['registered_at'] = Variable<DateTime>(registeredAt);
    map['last_seen_at'] = Variable<DateTime>(lastSeenAt);
    return map;
  }

  DeviceRegistrationRowsCompanion toCompanion(bool nullToAbsent) {
    return DeviceRegistrationRowsCompanion(
      deviceId: Value(deviceId),
      fcmToken: Value(fcmToken),
      platform: Value(platform),
      timezoneId: Value(timezoneId),
      notificationsEnabled: Value(notificationsEnabled),
      appVersion: appVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(appVersion),
      registeredAt: Value(registeredAt),
      lastSeenAt: Value(lastSeenAt),
    );
  }

  factory DeviceRegistrationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceRegistrationRow(
      deviceId: serializer.fromJson<String>(json['deviceId']),
      fcmToken: serializer.fromJson<String>(json['fcmToken']),
      platform: serializer.fromJson<String>(json['platform']),
      timezoneId: serializer.fromJson<String>(json['timezoneId']),
      notificationsEnabled: serializer.fromJson<bool>(
        json['notificationsEnabled'],
      ),
      appVersion: serializer.fromJson<String?>(json['appVersion']),
      registeredAt: serializer.fromJson<DateTime>(json['registeredAt']),
      lastSeenAt: serializer.fromJson<DateTime>(json['lastSeenAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'deviceId': serializer.toJson<String>(deviceId),
      'fcmToken': serializer.toJson<String>(fcmToken),
      'platform': serializer.toJson<String>(platform),
      'timezoneId': serializer.toJson<String>(timezoneId),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'appVersion': serializer.toJson<String?>(appVersion),
      'registeredAt': serializer.toJson<DateTime>(registeredAt),
      'lastSeenAt': serializer.toJson<DateTime>(lastSeenAt),
    };
  }

  DeviceRegistrationRow copyWith({
    String? deviceId,
    String? fcmToken,
    String? platform,
    String? timezoneId,
    bool? notificationsEnabled,
    Value<String?> appVersion = const Value.absent(),
    DateTime? registeredAt,
    DateTime? lastSeenAt,
  }) => DeviceRegistrationRow(
    deviceId: deviceId ?? this.deviceId,
    fcmToken: fcmToken ?? this.fcmToken,
    platform: platform ?? this.platform,
    timezoneId: timezoneId ?? this.timezoneId,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    appVersion: appVersion.present ? appVersion.value : this.appVersion,
    registeredAt: registeredAt ?? this.registeredAt,
    lastSeenAt: lastSeenAt ?? this.lastSeenAt,
  );
  DeviceRegistrationRow copyWithCompanion(
    DeviceRegistrationRowsCompanion data,
  ) {
    return DeviceRegistrationRow(
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      fcmToken: data.fcmToken.present ? data.fcmToken.value : this.fcmToken,
      platform: data.platform.present ? data.platform.value : this.platform,
      timezoneId: data.timezoneId.present
          ? data.timezoneId.value
          : this.timezoneId,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      appVersion: data.appVersion.present
          ? data.appVersion.value
          : this.appVersion,
      registeredAt: data.registeredAt.present
          ? data.registeredAt.value
          : this.registeredAt,
      lastSeenAt: data.lastSeenAt.present
          ? data.lastSeenAt.value
          : this.lastSeenAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceRegistrationRow(')
          ..write('deviceId: $deviceId, ')
          ..write('fcmToken: $fcmToken, ')
          ..write('platform: $platform, ')
          ..write('timezoneId: $timezoneId, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('appVersion: $appVersion, ')
          ..write('registeredAt: $registeredAt, ')
          ..write('lastSeenAt: $lastSeenAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    deviceId,
    fcmToken,
    platform,
    timezoneId,
    notificationsEnabled,
    appVersion,
    registeredAt,
    lastSeenAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceRegistrationRow &&
          other.deviceId == this.deviceId &&
          other.fcmToken == this.fcmToken &&
          other.platform == this.platform &&
          other.timezoneId == this.timezoneId &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.appVersion == this.appVersion &&
          other.registeredAt == this.registeredAt &&
          other.lastSeenAt == this.lastSeenAt);
}

class DeviceRegistrationRowsCompanion
    extends UpdateCompanion<DeviceRegistrationRow> {
  final Value<String> deviceId;
  final Value<String> fcmToken;
  final Value<String> platform;
  final Value<String> timezoneId;
  final Value<bool> notificationsEnabled;
  final Value<String?> appVersion;
  final Value<DateTime> registeredAt;
  final Value<DateTime> lastSeenAt;
  final Value<int> rowid;
  const DeviceRegistrationRowsCompanion({
    this.deviceId = const Value.absent(),
    this.fcmToken = const Value.absent(),
    this.platform = const Value.absent(),
    this.timezoneId = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.appVersion = const Value.absent(),
    this.registeredAt = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeviceRegistrationRowsCompanion.insert({
    required String deviceId,
    required String fcmToken,
    required String platform,
    this.timezoneId = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.appVersion = const Value.absent(),
    this.registeredAt = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : deviceId = Value(deviceId),
       fcmToken = Value(fcmToken),
       platform = Value(platform);
  static Insertable<DeviceRegistrationRow> custom({
    Expression<String>? deviceId,
    Expression<String>? fcmToken,
    Expression<String>? platform,
    Expression<String>? timezoneId,
    Expression<bool>? notificationsEnabled,
    Expression<String>? appVersion,
    Expression<DateTime>? registeredAt,
    Expression<DateTime>? lastSeenAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (deviceId != null) 'device_id': deviceId,
      if (fcmToken != null) 'fcm_token': fcmToken,
      if (platform != null) 'platform': platform,
      if (timezoneId != null) 'timezone_id': timezoneId,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (appVersion != null) 'app_version': appVersion,
      if (registeredAt != null) 'registered_at': registeredAt,
      if (lastSeenAt != null) 'last_seen_at': lastSeenAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeviceRegistrationRowsCompanion copyWith({
    Value<String>? deviceId,
    Value<String>? fcmToken,
    Value<String>? platform,
    Value<String>? timezoneId,
    Value<bool>? notificationsEnabled,
    Value<String?>? appVersion,
    Value<DateTime>? registeredAt,
    Value<DateTime>? lastSeenAt,
    Value<int>? rowid,
  }) {
    return DeviceRegistrationRowsCompanion(
      deviceId: deviceId ?? this.deviceId,
      fcmToken: fcmToken ?? this.fcmToken,
      platform: platform ?? this.platform,
      timezoneId: timezoneId ?? this.timezoneId,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      appVersion: appVersion ?? this.appVersion,
      registeredAt: registeredAt ?? this.registeredAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (fcmToken.present) {
      map['fcm_token'] = Variable<String>(fcmToken.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (timezoneId.present) {
      map['timezone_id'] = Variable<String>(timezoneId.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (appVersion.present) {
      map['app_version'] = Variable<String>(appVersion.value);
    }
    if (registeredAt.present) {
      map['registered_at'] = Variable<DateTime>(registeredAt.value);
    }
    if (lastSeenAt.present) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceRegistrationRowsCompanion(')
          ..write('deviceId: $deviceId, ')
          ..write('fcmToken: $fcmToken, ')
          ..write('platform: $platform, ')
          ..write('timezoneId: $timezoneId, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('appVersion: $appVersion, ')
          ..write('registeredAt: $registeredAt, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContentMetadataRowsTable extends ContentMetadataRows
    with TableInfo<$ContentMetadataRowsTable, ContentMetadataRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentMetadataRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeBundleVersionMeta =
      const VerificationMeta('activeBundleVersion');
  @override
  late final GeneratedColumn<String> activeBundleVersion =
      GeneratedColumn<String>(
        'active_bundle_version',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _previousBundleVersionMeta =
      const VerificationMeta('previousBundleVersion');
  @override
  late final GeneratedColumn<String> previousBundleVersion =
      GeneratedColumn<String>(
        'previous_bundle_version',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _activeContentHashMeta = const VerificationMeta(
    'activeContentHash',
  );
  @override
  late final GeneratedColumn<String> activeContentHash =
      GeneratedColumn<String>(
        'active_content_hash',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _quarantinedVersionsJsonMeta =
      const VerificationMeta('quarantinedVersionsJson');
  @override
  late final GeneratedColumn<String> quarantinedVersionsJson =
      GeneratedColumn<String>(
        'quarantined_versions_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _lastUpdateCheckAtMeta = const VerificationMeta(
    'lastUpdateCheckAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdateCheckAt =
      GeneratedColumn<DateTime>(
        'last_update_check_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastSuccessfulActivationAtMeta =
      const VerificationMeta('lastSuccessfulActivationAt');
  @override
  late final GeneratedColumn<DateTime> lastSuccessfulActivationAt =
      GeneratedColumn<DateTime>(
        'last_successful_activation_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    activeBundleVersion,
    previousBundleVersion,
    activeContentHash,
    quarantinedVersionsJson,
    lastUpdateCheckAt,
    lastSuccessfulActivationAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_metadata_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentMetadataRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('active_bundle_version')) {
      context.handle(
        _activeBundleVersionMeta,
        activeBundleVersion.isAcceptableOrUnknown(
          data['active_bundle_version']!,
          _activeBundleVersionMeta,
        ),
      );
    }
    if (data.containsKey('previous_bundle_version')) {
      context.handle(
        _previousBundleVersionMeta,
        previousBundleVersion.isAcceptableOrUnknown(
          data['previous_bundle_version']!,
          _previousBundleVersionMeta,
        ),
      );
    }
    if (data.containsKey('active_content_hash')) {
      context.handle(
        _activeContentHashMeta,
        activeContentHash.isAcceptableOrUnknown(
          data['active_content_hash']!,
          _activeContentHashMeta,
        ),
      );
    }
    if (data.containsKey('quarantined_versions_json')) {
      context.handle(
        _quarantinedVersionsJsonMeta,
        quarantinedVersionsJson.isAcceptableOrUnknown(
          data['quarantined_versions_json']!,
          _quarantinedVersionsJsonMeta,
        ),
      );
    }
    if (data.containsKey('last_update_check_at')) {
      context.handle(
        _lastUpdateCheckAtMeta,
        lastUpdateCheckAt.isAcceptableOrUnknown(
          data['last_update_check_at']!,
          _lastUpdateCheckAtMeta,
        ),
      );
    }
    if (data.containsKey('last_successful_activation_at')) {
      context.handle(
        _lastSuccessfulActivationAtMeta,
        lastSuccessfulActivationAt.isAcceptableOrUnknown(
          data['last_successful_activation_at']!,
          _lastSuccessfulActivationAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContentMetadataRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentMetadataRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      activeBundleVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_bundle_version'],
      ),
      previousBundleVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}previous_bundle_version'],
      ),
      activeContentHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_content_hash'],
      ),
      quarantinedVersionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quarantined_versions_json'],
      )!,
      lastUpdateCheckAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_update_check_at'],
      ),
      lastSuccessfulActivationAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_successful_activation_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ContentMetadataRowsTable createAlias(String alias) {
    return $ContentMetadataRowsTable(attachedDatabase, alias);
  }
}

class ContentMetadataRow extends DataClass
    implements Insertable<ContentMetadataRow> {
  /// Always a single row with id = 'main'.
  final String id;
  final String? activeBundleVersion;
  final String? previousBundleVersion;
  final String? activeContentHash;
  final String quarantinedVersionsJson;
  final DateTime? lastUpdateCheckAt;
  final DateTime? lastSuccessfulActivationAt;
  final DateTime updatedAt;
  const ContentMetadataRow({
    required this.id,
    this.activeBundleVersion,
    this.previousBundleVersion,
    this.activeContentHash,
    required this.quarantinedVersionsJson,
    this.lastUpdateCheckAt,
    this.lastSuccessfulActivationAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || activeBundleVersion != null) {
      map['active_bundle_version'] = Variable<String>(activeBundleVersion);
    }
    if (!nullToAbsent || previousBundleVersion != null) {
      map['previous_bundle_version'] = Variable<String>(previousBundleVersion);
    }
    if (!nullToAbsent || activeContentHash != null) {
      map['active_content_hash'] = Variable<String>(activeContentHash);
    }
    map['quarantined_versions_json'] = Variable<String>(
      quarantinedVersionsJson,
    );
    if (!nullToAbsent || lastUpdateCheckAt != null) {
      map['last_update_check_at'] = Variable<DateTime>(lastUpdateCheckAt);
    }
    if (!nullToAbsent || lastSuccessfulActivationAt != null) {
      map['last_successful_activation_at'] = Variable<DateTime>(
        lastSuccessfulActivationAt,
      );
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ContentMetadataRowsCompanion toCompanion(bool nullToAbsent) {
    return ContentMetadataRowsCompanion(
      id: Value(id),
      activeBundleVersion: activeBundleVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(activeBundleVersion),
      previousBundleVersion: previousBundleVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(previousBundleVersion),
      activeContentHash: activeContentHash == null && nullToAbsent
          ? const Value.absent()
          : Value(activeContentHash),
      quarantinedVersionsJson: Value(quarantinedVersionsJson),
      lastUpdateCheckAt: lastUpdateCheckAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdateCheckAt),
      lastSuccessfulActivationAt:
          lastSuccessfulActivationAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSuccessfulActivationAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ContentMetadataRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentMetadataRow(
      id: serializer.fromJson<String>(json['id']),
      activeBundleVersion: serializer.fromJson<String?>(
        json['activeBundleVersion'],
      ),
      previousBundleVersion: serializer.fromJson<String?>(
        json['previousBundleVersion'],
      ),
      activeContentHash: serializer.fromJson<String?>(
        json['activeContentHash'],
      ),
      quarantinedVersionsJson: serializer.fromJson<String>(
        json['quarantinedVersionsJson'],
      ),
      lastUpdateCheckAt: serializer.fromJson<DateTime?>(
        json['lastUpdateCheckAt'],
      ),
      lastSuccessfulActivationAt: serializer.fromJson<DateTime?>(
        json['lastSuccessfulActivationAt'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'activeBundleVersion': serializer.toJson<String?>(activeBundleVersion),
      'previousBundleVersion': serializer.toJson<String?>(
        previousBundleVersion,
      ),
      'activeContentHash': serializer.toJson<String?>(activeContentHash),
      'quarantinedVersionsJson': serializer.toJson<String>(
        quarantinedVersionsJson,
      ),
      'lastUpdateCheckAt': serializer.toJson<DateTime?>(lastUpdateCheckAt),
      'lastSuccessfulActivationAt': serializer.toJson<DateTime?>(
        lastSuccessfulActivationAt,
      ),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ContentMetadataRow copyWith({
    String? id,
    Value<String?> activeBundleVersion = const Value.absent(),
    Value<String?> previousBundleVersion = const Value.absent(),
    Value<String?> activeContentHash = const Value.absent(),
    String? quarantinedVersionsJson,
    Value<DateTime?> lastUpdateCheckAt = const Value.absent(),
    Value<DateTime?> lastSuccessfulActivationAt = const Value.absent(),
    DateTime? updatedAt,
  }) => ContentMetadataRow(
    id: id ?? this.id,
    activeBundleVersion: activeBundleVersion.present
        ? activeBundleVersion.value
        : this.activeBundleVersion,
    previousBundleVersion: previousBundleVersion.present
        ? previousBundleVersion.value
        : this.previousBundleVersion,
    activeContentHash: activeContentHash.present
        ? activeContentHash.value
        : this.activeContentHash,
    quarantinedVersionsJson:
        quarantinedVersionsJson ?? this.quarantinedVersionsJson,
    lastUpdateCheckAt: lastUpdateCheckAt.present
        ? lastUpdateCheckAt.value
        : this.lastUpdateCheckAt,
    lastSuccessfulActivationAt: lastSuccessfulActivationAt.present
        ? lastSuccessfulActivationAt.value
        : this.lastSuccessfulActivationAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ContentMetadataRow copyWithCompanion(ContentMetadataRowsCompanion data) {
    return ContentMetadataRow(
      id: data.id.present ? data.id.value : this.id,
      activeBundleVersion: data.activeBundleVersion.present
          ? data.activeBundleVersion.value
          : this.activeBundleVersion,
      previousBundleVersion: data.previousBundleVersion.present
          ? data.previousBundleVersion.value
          : this.previousBundleVersion,
      activeContentHash: data.activeContentHash.present
          ? data.activeContentHash.value
          : this.activeContentHash,
      quarantinedVersionsJson: data.quarantinedVersionsJson.present
          ? data.quarantinedVersionsJson.value
          : this.quarantinedVersionsJson,
      lastUpdateCheckAt: data.lastUpdateCheckAt.present
          ? data.lastUpdateCheckAt.value
          : this.lastUpdateCheckAt,
      lastSuccessfulActivationAt: data.lastSuccessfulActivationAt.present
          ? data.lastSuccessfulActivationAt.value
          : this.lastSuccessfulActivationAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentMetadataRow(')
          ..write('id: $id, ')
          ..write('activeBundleVersion: $activeBundleVersion, ')
          ..write('previousBundleVersion: $previousBundleVersion, ')
          ..write('activeContentHash: $activeContentHash, ')
          ..write('quarantinedVersionsJson: $quarantinedVersionsJson, ')
          ..write('lastUpdateCheckAt: $lastUpdateCheckAt, ')
          ..write('lastSuccessfulActivationAt: $lastSuccessfulActivationAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    activeBundleVersion,
    previousBundleVersion,
    activeContentHash,
    quarantinedVersionsJson,
    lastUpdateCheckAt,
    lastSuccessfulActivationAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentMetadataRow &&
          other.id == this.id &&
          other.activeBundleVersion == this.activeBundleVersion &&
          other.previousBundleVersion == this.previousBundleVersion &&
          other.activeContentHash == this.activeContentHash &&
          other.quarantinedVersionsJson == this.quarantinedVersionsJson &&
          other.lastUpdateCheckAt == this.lastUpdateCheckAt &&
          other.lastSuccessfulActivationAt == this.lastSuccessfulActivationAt &&
          other.updatedAt == this.updatedAt);
}

class ContentMetadataRowsCompanion extends UpdateCompanion<ContentMetadataRow> {
  final Value<String> id;
  final Value<String?> activeBundleVersion;
  final Value<String?> previousBundleVersion;
  final Value<String?> activeContentHash;
  final Value<String> quarantinedVersionsJson;
  final Value<DateTime?> lastUpdateCheckAt;
  final Value<DateTime?> lastSuccessfulActivationAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ContentMetadataRowsCompanion({
    this.id = const Value.absent(),
    this.activeBundleVersion = const Value.absent(),
    this.previousBundleVersion = const Value.absent(),
    this.activeContentHash = const Value.absent(),
    this.quarantinedVersionsJson = const Value.absent(),
    this.lastUpdateCheckAt = const Value.absent(),
    this.lastSuccessfulActivationAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentMetadataRowsCompanion.insert({
    required String id,
    this.activeBundleVersion = const Value.absent(),
    this.previousBundleVersion = const Value.absent(),
    this.activeContentHash = const Value.absent(),
    this.quarantinedVersionsJson = const Value.absent(),
    this.lastUpdateCheckAt = const Value.absent(),
    this.lastSuccessfulActivationAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<ContentMetadataRow> custom({
    Expression<String>? id,
    Expression<String>? activeBundleVersion,
    Expression<String>? previousBundleVersion,
    Expression<String>? activeContentHash,
    Expression<String>? quarantinedVersionsJson,
    Expression<DateTime>? lastUpdateCheckAt,
    Expression<DateTime>? lastSuccessfulActivationAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (activeBundleVersion != null)
        'active_bundle_version': activeBundleVersion,
      if (previousBundleVersion != null)
        'previous_bundle_version': previousBundleVersion,
      if (activeContentHash != null) 'active_content_hash': activeContentHash,
      if (quarantinedVersionsJson != null)
        'quarantined_versions_json': quarantinedVersionsJson,
      if (lastUpdateCheckAt != null) 'last_update_check_at': lastUpdateCheckAt,
      if (lastSuccessfulActivationAt != null)
        'last_successful_activation_at': lastSuccessfulActivationAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentMetadataRowsCompanion copyWith({
    Value<String>? id,
    Value<String?>? activeBundleVersion,
    Value<String?>? previousBundleVersion,
    Value<String?>? activeContentHash,
    Value<String>? quarantinedVersionsJson,
    Value<DateTime?>? lastUpdateCheckAt,
    Value<DateTime?>? lastSuccessfulActivationAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ContentMetadataRowsCompanion(
      id: id ?? this.id,
      activeBundleVersion: activeBundleVersion ?? this.activeBundleVersion,
      previousBundleVersion:
          previousBundleVersion ?? this.previousBundleVersion,
      activeContentHash: activeContentHash ?? this.activeContentHash,
      quarantinedVersionsJson:
          quarantinedVersionsJson ?? this.quarantinedVersionsJson,
      lastUpdateCheckAt: lastUpdateCheckAt ?? this.lastUpdateCheckAt,
      lastSuccessfulActivationAt:
          lastSuccessfulActivationAt ?? this.lastSuccessfulActivationAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (activeBundleVersion.present) {
      map['active_bundle_version'] = Variable<String>(
        activeBundleVersion.value,
      );
    }
    if (previousBundleVersion.present) {
      map['previous_bundle_version'] = Variable<String>(
        previousBundleVersion.value,
      );
    }
    if (activeContentHash.present) {
      map['active_content_hash'] = Variable<String>(activeContentHash.value);
    }
    if (quarantinedVersionsJson.present) {
      map['quarantined_versions_json'] = Variable<String>(
        quarantinedVersionsJson.value,
      );
    }
    if (lastUpdateCheckAt.present) {
      map['last_update_check_at'] = Variable<DateTime>(lastUpdateCheckAt.value);
    }
    if (lastSuccessfulActivationAt.present) {
      map['last_successful_activation_at'] = Variable<DateTime>(
        lastSuccessfulActivationAt.value,
      );
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
    return (StringBuffer('ContentMetadataRowsCompanion(')
          ..write('id: $id, ')
          ..write('activeBundleVersion: $activeBundleVersion, ')
          ..write('previousBundleVersion: $previousBundleVersion, ')
          ..write('activeContentHash: $activeContentHash, ')
          ..write('quarantinedVersionsJson: $quarantinedVersionsJson, ')
          ..write('lastUpdateCheckAt: $lastUpdateCheckAt, ')
          ..write('lastSuccessfulActivationAt: $lastSuccessfulActivationAt, ')
          ..write('updatedAt: $updatedAt, ')
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
  late final $JourneyProgressRowsTable journeyProgressRows =
      $JourneyProgressRowsTable(this);
  late final $PlayerFlagRowsTable playerFlagRows = $PlayerFlagRowsTable(this);
  late final $PlayerIdentityRowsTable playerIdentityRows =
      $PlayerIdentityRowsTable(this);
  late final $SyncMetadataRowsTable syncMetadataRows = $SyncMetadataRowsTable(
    this,
  );
  late final $SyncOperationRowsTable syncOperationRows =
      $SyncOperationRowsTable(this);
  late final $WalletCacheRowsTable walletCacheRows = $WalletCacheRowsTable(
    this,
  );
  late final $EconomyOperationRowsTable economyOperationRows =
      $EconomyOperationRowsTable(this);
  late final $EntitlementRowsTable entitlementRows = $EntitlementRowsTable(
    this,
  );
  late final $MonetizationStateRowsTable monetizationStateRows =
      $MonetizationStateRowsTable(this);
  late final $RewardedAdReceiptRowsTable rewardedAdReceiptRows =
      $RewardedAdReceiptRowsTable(this);
  late final $DailyStateCacheRowsTable dailyStateCacheRows =
      $DailyStateCacheRowsTable(this);
  late final $DailyChallengeCacheRowsTable dailyChallengeCacheRows =
      $DailyChallengeCacheRowsTable(this);
  late final $NotificationPreferenceRowsTable notificationPreferenceRows =
      $NotificationPreferenceRowsTable(this);
  late final $DeviceRegistrationRowsTable deviceRegistrationRows =
      $DeviceRegistrationRowsTable(this);
  late final $ContentMetadataRowsTable contentMetadataRows =
      $ContentMetadataRowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appMetadata,
    schemaMetadata,
    activeAttempts,
    journeyProgressRows,
    playerFlagRows,
    playerIdentityRows,
    syncMetadataRows,
    syncOperationRows,
    walletCacheRows,
    economyOperationRows,
    entitlementRows,
    monetizationStateRows,
    rewardedAdReceiptRows,
    dailyStateCacheRows,
    dailyChallengeCacheRows,
    notificationPreferenceRows,
    deviceRegistrationRows,
    contentMetadataRows,
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
typedef $$JourneyProgressRowsTableCreateCompanionBuilder =
    JourneyProgressRowsCompanion Function({
      required String id,
      Value<int> highestUnlockedLevel,
      Value<int> highestCompletedLevel,
      Value<String?> currentLevelId,
      Value<String> completedLevelIdsJson,
      Value<String> completedChapterIdsJson,
      Value<int> progressionSchemaVersion,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$JourneyProgressRowsTableUpdateCompanionBuilder =
    JourneyProgressRowsCompanion Function({
      Value<String> id,
      Value<int> highestUnlockedLevel,
      Value<int> highestCompletedLevel,
      Value<String?> currentLevelId,
      Value<String> completedLevelIdsJson,
      Value<String> completedChapterIdsJson,
      Value<int> progressionSchemaVersion,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$JourneyProgressRowsTableFilterComposer
    extends Composer<_$AppDatabase, $JourneyProgressRowsTable> {
  $$JourneyProgressRowsTableFilterComposer({
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

  ColumnFilters<int> get highestUnlockedLevel => $composableBuilder(
    column: $table.highestUnlockedLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get highestCompletedLevel => $composableBuilder(
    column: $table.highestCompletedLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentLevelId => $composableBuilder(
    column: $table.currentLevelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedLevelIdsJson => $composableBuilder(
    column: $table.completedLevelIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedChapterIdsJson => $composableBuilder(
    column: $table.completedChapterIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progressionSchemaVersion => $composableBuilder(
    column: $table.progressionSchemaVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JourneyProgressRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $JourneyProgressRowsTable> {
  $$JourneyProgressRowsTableOrderingComposer({
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

  ColumnOrderings<int> get highestUnlockedLevel => $composableBuilder(
    column: $table.highestUnlockedLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get highestCompletedLevel => $composableBuilder(
    column: $table.highestCompletedLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentLevelId => $composableBuilder(
    column: $table.currentLevelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedLevelIdsJson => $composableBuilder(
    column: $table.completedLevelIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedChapterIdsJson => $composableBuilder(
    column: $table.completedChapterIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progressionSchemaVersion => $composableBuilder(
    column: $table.progressionSchemaVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JourneyProgressRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $JourneyProgressRowsTable> {
  $$JourneyProgressRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get highestUnlockedLevel => $composableBuilder(
    column: $table.highestUnlockedLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get highestCompletedLevel => $composableBuilder(
    column: $table.highestCompletedLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currentLevelId => $composableBuilder(
    column: $table.currentLevelId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get completedLevelIdsJson => $composableBuilder(
    column: $table.completedLevelIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get completedChapterIdsJson => $composableBuilder(
    column: $table.completedChapterIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get progressionSchemaVersion => $composableBuilder(
    column: $table.progressionSchemaVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$JourneyProgressRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JourneyProgressRowsTable,
          JourneyProgressRow,
          $$JourneyProgressRowsTableFilterComposer,
          $$JourneyProgressRowsTableOrderingComposer,
          $$JourneyProgressRowsTableAnnotationComposer,
          $$JourneyProgressRowsTableCreateCompanionBuilder,
          $$JourneyProgressRowsTableUpdateCompanionBuilder,
          (
            JourneyProgressRow,
            BaseReferences<
              _$AppDatabase,
              $JourneyProgressRowsTable,
              JourneyProgressRow
            >,
          ),
          JourneyProgressRow,
          PrefetchHooks Function()
        > {
  $$JourneyProgressRowsTableTableManager(
    _$AppDatabase db,
    $JourneyProgressRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JourneyProgressRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JourneyProgressRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$JourneyProgressRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> highestUnlockedLevel = const Value.absent(),
                Value<int> highestCompletedLevel = const Value.absent(),
                Value<String?> currentLevelId = const Value.absent(),
                Value<String> completedLevelIdsJson = const Value.absent(),
                Value<String> completedChapterIdsJson = const Value.absent(),
                Value<int> progressionSchemaVersion = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JourneyProgressRowsCompanion(
                id: id,
                highestUnlockedLevel: highestUnlockedLevel,
                highestCompletedLevel: highestCompletedLevel,
                currentLevelId: currentLevelId,
                completedLevelIdsJson: completedLevelIdsJson,
                completedChapterIdsJson: completedChapterIdsJson,
                progressionSchemaVersion: progressionSchemaVersion,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int> highestUnlockedLevel = const Value.absent(),
                Value<int> highestCompletedLevel = const Value.absent(),
                Value<String?> currentLevelId = const Value.absent(),
                Value<String> completedLevelIdsJson = const Value.absent(),
                Value<String> completedChapterIdsJson = const Value.absent(),
                Value<int> progressionSchemaVersion = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JourneyProgressRowsCompanion.insert(
                id: id,
                highestUnlockedLevel: highestUnlockedLevel,
                highestCompletedLevel: highestCompletedLevel,
                currentLevelId: currentLevelId,
                completedLevelIdsJson: completedLevelIdsJson,
                completedChapterIdsJson: completedChapterIdsJson,
                progressionSchemaVersion: progressionSchemaVersion,
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

typedef $$JourneyProgressRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JourneyProgressRowsTable,
      JourneyProgressRow,
      $$JourneyProgressRowsTableFilterComposer,
      $$JourneyProgressRowsTableOrderingComposer,
      $$JourneyProgressRowsTableAnnotationComposer,
      $$JourneyProgressRowsTableCreateCompanionBuilder,
      $$JourneyProgressRowsTableUpdateCompanionBuilder,
      (
        JourneyProgressRow,
        BaseReferences<
          _$AppDatabase,
          $JourneyProgressRowsTable,
          JourneyProgressRow
        >,
      ),
      JourneyProgressRow,
      PrefetchHooks Function()
    >;
typedef $$PlayerFlagRowsTableCreateCompanionBuilder =
    PlayerFlagRowsCompanion Function({
      required String id,
      Value<bool> isFirstLaunch,
      Value<bool> onboardingCompleted,
      Value<bool> tutorialCompleted,
      Value<String> unlockedStoryBeatIdsJson,
      Value<String> viewedStoryBeatIdsJson,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$PlayerFlagRowsTableUpdateCompanionBuilder =
    PlayerFlagRowsCompanion Function({
      Value<String> id,
      Value<bool> isFirstLaunch,
      Value<bool> onboardingCompleted,
      Value<bool> tutorialCompleted,
      Value<String> unlockedStoryBeatIdsJson,
      Value<String> viewedStoryBeatIdsJson,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$PlayerFlagRowsTableFilterComposer
    extends Composer<_$AppDatabase, $PlayerFlagRowsTable> {
  $$PlayerFlagRowsTableFilterComposer({
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

  ColumnFilters<bool> get isFirstLaunch => $composableBuilder(
    column: $table.isFirstLaunch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get tutorialCompleted => $composableBuilder(
    column: $table.tutorialCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unlockedStoryBeatIdsJson => $composableBuilder(
    column: $table.unlockedStoryBeatIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get viewedStoryBeatIdsJson => $composableBuilder(
    column: $table.viewedStoryBeatIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlayerFlagRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayerFlagRowsTable> {
  $$PlayerFlagRowsTableOrderingComposer({
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

  ColumnOrderings<bool> get isFirstLaunch => $composableBuilder(
    column: $table.isFirstLaunch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get tutorialCompleted => $composableBuilder(
    column: $table.tutorialCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unlockedStoryBeatIdsJson => $composableBuilder(
    column: $table.unlockedStoryBeatIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get viewedStoryBeatIdsJson => $composableBuilder(
    column: $table.viewedStoryBeatIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlayerFlagRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayerFlagRowsTable> {
  $$PlayerFlagRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get isFirstLaunch => $composableBuilder(
    column: $table.isFirstLaunch,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get tutorialCompleted => $composableBuilder(
    column: $table.tutorialCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unlockedStoryBeatIdsJson => $composableBuilder(
    column: $table.unlockedStoryBeatIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get viewedStoryBeatIdsJson => $composableBuilder(
    column: $table.viewedStoryBeatIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PlayerFlagRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayerFlagRowsTable,
          PlayerFlagRow,
          $$PlayerFlagRowsTableFilterComposer,
          $$PlayerFlagRowsTableOrderingComposer,
          $$PlayerFlagRowsTableAnnotationComposer,
          $$PlayerFlagRowsTableCreateCompanionBuilder,
          $$PlayerFlagRowsTableUpdateCompanionBuilder,
          (
            PlayerFlagRow,
            BaseReferences<_$AppDatabase, $PlayerFlagRowsTable, PlayerFlagRow>,
          ),
          PlayerFlagRow,
          PrefetchHooks Function()
        > {
  $$PlayerFlagRowsTableTableManager(
    _$AppDatabase db,
    $PlayerFlagRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayerFlagRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayerFlagRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayerFlagRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<bool> isFirstLaunch = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<bool> tutorialCompleted = const Value.absent(),
                Value<String> unlockedStoryBeatIdsJson = const Value.absent(),
                Value<String> viewedStoryBeatIdsJson = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlayerFlagRowsCompanion(
                id: id,
                isFirstLaunch: isFirstLaunch,
                onboardingCompleted: onboardingCompleted,
                tutorialCompleted: tutorialCompleted,
                unlockedStoryBeatIdsJson: unlockedStoryBeatIdsJson,
                viewedStoryBeatIdsJson: viewedStoryBeatIdsJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<bool> isFirstLaunch = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<bool> tutorialCompleted = const Value.absent(),
                Value<String> unlockedStoryBeatIdsJson = const Value.absent(),
                Value<String> viewedStoryBeatIdsJson = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlayerFlagRowsCompanion.insert(
                id: id,
                isFirstLaunch: isFirstLaunch,
                onboardingCompleted: onboardingCompleted,
                tutorialCompleted: tutorialCompleted,
                unlockedStoryBeatIdsJson: unlockedStoryBeatIdsJson,
                viewedStoryBeatIdsJson: viewedStoryBeatIdsJson,
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

typedef $$PlayerFlagRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayerFlagRowsTable,
      PlayerFlagRow,
      $$PlayerFlagRowsTableFilterComposer,
      $$PlayerFlagRowsTableOrderingComposer,
      $$PlayerFlagRowsTableAnnotationComposer,
      $$PlayerFlagRowsTableCreateCompanionBuilder,
      $$PlayerFlagRowsTableUpdateCompanionBuilder,
      (
        PlayerFlagRow,
        BaseReferences<_$AppDatabase, $PlayerFlagRowsTable, PlayerFlagRow>,
      ),
      PlayerFlagRow,
      PrefetchHooks Function()
    >;
typedef $$PlayerIdentityRowsTableCreateCompanionBuilder =
    PlayerIdentityRowsCompanion Function({
      required String id,
      required String localPlayerId,
      Value<String?> firebaseUid,
      Value<String> identityState,
      Value<DateTime> createdAt,
      Value<int> cloudMigrationVersion,
      Value<DateTime?> cloudMigrationCompletedAt,
      Value<int> rowid,
    });
typedef $$PlayerIdentityRowsTableUpdateCompanionBuilder =
    PlayerIdentityRowsCompanion Function({
      Value<String> id,
      Value<String> localPlayerId,
      Value<String?> firebaseUid,
      Value<String> identityState,
      Value<DateTime> createdAt,
      Value<int> cloudMigrationVersion,
      Value<DateTime?> cloudMigrationCompletedAt,
      Value<int> rowid,
    });

class $$PlayerIdentityRowsTableFilterComposer
    extends Composer<_$AppDatabase, $PlayerIdentityRowsTable> {
  $$PlayerIdentityRowsTableFilterComposer({
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

  ColumnFilters<String> get localPlayerId => $composableBuilder(
    column: $table.localPlayerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firebaseUid => $composableBuilder(
    column: $table.firebaseUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identityState => $composableBuilder(
    column: $table.identityState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cloudMigrationVersion => $composableBuilder(
    column: $table.cloudMigrationVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cloudMigrationCompletedAt => $composableBuilder(
    column: $table.cloudMigrationCompletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlayerIdentityRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayerIdentityRowsTable> {
  $$PlayerIdentityRowsTableOrderingComposer({
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

  ColumnOrderings<String> get localPlayerId => $composableBuilder(
    column: $table.localPlayerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firebaseUid => $composableBuilder(
    column: $table.firebaseUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identityState => $composableBuilder(
    column: $table.identityState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cloudMigrationVersion => $composableBuilder(
    column: $table.cloudMigrationVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cloudMigrationCompletedAt => $composableBuilder(
    column: $table.cloudMigrationCompletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlayerIdentityRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayerIdentityRowsTable> {
  $$PlayerIdentityRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localPlayerId => $composableBuilder(
    column: $table.localPlayerId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get firebaseUid => $composableBuilder(
    column: $table.firebaseUid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get identityState => $composableBuilder(
    column: $table.identityState,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get cloudMigrationVersion => $composableBuilder(
    column: $table.cloudMigrationVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cloudMigrationCompletedAt => $composableBuilder(
    column: $table.cloudMigrationCompletedAt,
    builder: (column) => column,
  );
}

class $$PlayerIdentityRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayerIdentityRowsTable,
          PlayerIdentityRow,
          $$PlayerIdentityRowsTableFilterComposer,
          $$PlayerIdentityRowsTableOrderingComposer,
          $$PlayerIdentityRowsTableAnnotationComposer,
          $$PlayerIdentityRowsTableCreateCompanionBuilder,
          $$PlayerIdentityRowsTableUpdateCompanionBuilder,
          (
            PlayerIdentityRow,
            BaseReferences<
              _$AppDatabase,
              $PlayerIdentityRowsTable,
              PlayerIdentityRow
            >,
          ),
          PlayerIdentityRow,
          PrefetchHooks Function()
        > {
  $$PlayerIdentityRowsTableTableManager(
    _$AppDatabase db,
    $PlayerIdentityRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayerIdentityRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayerIdentityRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayerIdentityRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> localPlayerId = const Value.absent(),
                Value<String?> firebaseUid = const Value.absent(),
                Value<String> identityState = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> cloudMigrationVersion = const Value.absent(),
                Value<DateTime?> cloudMigrationCompletedAt =
                    const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlayerIdentityRowsCompanion(
                id: id,
                localPlayerId: localPlayerId,
                firebaseUid: firebaseUid,
                identityState: identityState,
                createdAt: createdAt,
                cloudMigrationVersion: cloudMigrationVersion,
                cloudMigrationCompletedAt: cloudMigrationCompletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String localPlayerId,
                Value<String?> firebaseUid = const Value.absent(),
                Value<String> identityState = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> cloudMigrationVersion = const Value.absent(),
                Value<DateTime?> cloudMigrationCompletedAt =
                    const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlayerIdentityRowsCompanion.insert(
                id: id,
                localPlayerId: localPlayerId,
                firebaseUid: firebaseUid,
                identityState: identityState,
                createdAt: createdAt,
                cloudMigrationVersion: cloudMigrationVersion,
                cloudMigrationCompletedAt: cloudMigrationCompletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlayerIdentityRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayerIdentityRowsTable,
      PlayerIdentityRow,
      $$PlayerIdentityRowsTableFilterComposer,
      $$PlayerIdentityRowsTableOrderingComposer,
      $$PlayerIdentityRowsTableAnnotationComposer,
      $$PlayerIdentityRowsTableCreateCompanionBuilder,
      $$PlayerIdentityRowsTableUpdateCompanionBuilder,
      (
        PlayerIdentityRow,
        BaseReferences<
          _$AppDatabase,
          $PlayerIdentityRowsTable,
          PlayerIdentityRow
        >,
      ),
      PlayerIdentityRow,
      PrefetchHooks Function()
    >;
typedef $$SyncMetadataRowsTableCreateCompanionBuilder =
    SyncMetadataRowsCompanion Function({
      required String id,
      Value<DateTime?> lastSuccessfulSyncAt,
      Value<int> lastCloudRevision,
      Value<int> pendingOperationsCount,
      Value<String?> lastSyncErrorCode,
      Value<String?> identityUid,
      Value<int> syncSchemaVersion,
      Value<int> rowid,
    });
typedef $$SyncMetadataRowsTableUpdateCompanionBuilder =
    SyncMetadataRowsCompanion Function({
      Value<String> id,
      Value<DateTime?> lastSuccessfulSyncAt,
      Value<int> lastCloudRevision,
      Value<int> pendingOperationsCount,
      Value<String?> lastSyncErrorCode,
      Value<String?> identityUid,
      Value<int> syncSchemaVersion,
      Value<int> rowid,
    });

class $$SyncMetadataRowsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetadataRowsTable> {
  $$SyncMetadataRowsTableFilterComposer({
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

  ColumnFilters<DateTime> get lastSuccessfulSyncAt => $composableBuilder(
    column: $table.lastSuccessfulSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastCloudRevision => $composableBuilder(
    column: $table.lastCloudRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pendingOperationsCount => $composableBuilder(
    column: $table.pendingOperationsCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastSyncErrorCode => $composableBuilder(
    column: $table.lastSyncErrorCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identityUid => $composableBuilder(
    column: $table.identityUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncSchemaVersion => $composableBuilder(
    column: $table.syncSchemaVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetadataRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetadataRowsTable> {
  $$SyncMetadataRowsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get lastSuccessfulSyncAt => $composableBuilder(
    column: $table.lastSuccessfulSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastCloudRevision => $composableBuilder(
    column: $table.lastCloudRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pendingOperationsCount => $composableBuilder(
    column: $table.pendingOperationsCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastSyncErrorCode => $composableBuilder(
    column: $table.lastSyncErrorCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identityUid => $composableBuilder(
    column: $table.identityUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncSchemaVersion => $composableBuilder(
    column: $table.syncSchemaVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetadataRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetadataRowsTable> {
  $$SyncMetadataRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSuccessfulSyncAt => $composableBuilder(
    column: $table.lastSuccessfulSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastCloudRevision => $composableBuilder(
    column: $table.lastCloudRevision,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pendingOperationsCount => $composableBuilder(
    column: $table.pendingOperationsCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastSyncErrorCode => $composableBuilder(
    column: $table.lastSyncErrorCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get identityUid => $composableBuilder(
    column: $table.identityUid,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncSchemaVersion => $composableBuilder(
    column: $table.syncSchemaVersion,
    builder: (column) => column,
  );
}

class $$SyncMetadataRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncMetadataRowsTable,
          SyncMetadataRow,
          $$SyncMetadataRowsTableFilterComposer,
          $$SyncMetadataRowsTableOrderingComposer,
          $$SyncMetadataRowsTableAnnotationComposer,
          $$SyncMetadataRowsTableCreateCompanionBuilder,
          $$SyncMetadataRowsTableUpdateCompanionBuilder,
          (
            SyncMetadataRow,
            BaseReferences<
              _$AppDatabase,
              $SyncMetadataRowsTable,
              SyncMetadataRow
            >,
          ),
          SyncMetadataRow,
          PrefetchHooks Function()
        > {
  $$SyncMetadataRowsTableTableManager(
    _$AppDatabase db,
    $SyncMetadataRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetadataRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetadataRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetadataRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime?> lastSuccessfulSyncAt = const Value.absent(),
                Value<int> lastCloudRevision = const Value.absent(),
                Value<int> pendingOperationsCount = const Value.absent(),
                Value<String?> lastSyncErrorCode = const Value.absent(),
                Value<String?> identityUid = const Value.absent(),
                Value<int> syncSchemaVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataRowsCompanion(
                id: id,
                lastSuccessfulSyncAt: lastSuccessfulSyncAt,
                lastCloudRevision: lastCloudRevision,
                pendingOperationsCount: pendingOperationsCount,
                lastSyncErrorCode: lastSyncErrorCode,
                identityUid: identityUid,
                syncSchemaVersion: syncSchemaVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime?> lastSuccessfulSyncAt = const Value.absent(),
                Value<int> lastCloudRevision = const Value.absent(),
                Value<int> pendingOperationsCount = const Value.absent(),
                Value<String?> lastSyncErrorCode = const Value.absent(),
                Value<String?> identityUid = const Value.absent(),
                Value<int> syncSchemaVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataRowsCompanion.insert(
                id: id,
                lastSuccessfulSyncAt: lastSuccessfulSyncAt,
                lastCloudRevision: lastCloudRevision,
                pendingOperationsCount: pendingOperationsCount,
                lastSyncErrorCode: lastSyncErrorCode,
                identityUid: identityUid,
                syncSchemaVersion: syncSchemaVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetadataRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncMetadataRowsTable,
      SyncMetadataRow,
      $$SyncMetadataRowsTableFilterComposer,
      $$SyncMetadataRowsTableOrderingComposer,
      $$SyncMetadataRowsTableAnnotationComposer,
      $$SyncMetadataRowsTableCreateCompanionBuilder,
      $$SyncMetadataRowsTableUpdateCompanionBuilder,
      (
        SyncMetadataRow,
        BaseReferences<_$AppDatabase, $SyncMetadataRowsTable, SyncMetadataRow>,
      ),
      SyncMetadataRow,
      PrefetchHooks Function()
    >;
typedef $$SyncOperationRowsTableCreateCompanionBuilder =
    SyncOperationRowsCompanion Function({
      required String operationId,
      required String operationType,
      required String payloadJson,
      Value<DateTime> createdAt,
      required String idempotencyKey,
      Value<int> attemptCount,
      Value<String> status,
      Value<DateTime?> nextRetryAt,
      Value<int> rowid,
    });
typedef $$SyncOperationRowsTableUpdateCompanionBuilder =
    SyncOperationRowsCompanion Function({
      Value<String> operationId,
      Value<String> operationType,
      Value<String> payloadJson,
      Value<DateTime> createdAt,
      Value<String> idempotencyKey,
      Value<int> attemptCount,
      Value<String> status,
      Value<DateTime?> nextRetryAt,
      Value<int> rowid,
    });

class $$SyncOperationRowsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOperationRowsTable> {
  $$SyncOperationRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOperationRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOperationRowsTable> {
  $$SyncOperationRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOperationRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOperationRowsTable> {
  $$SyncOperationRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => column,
  );
}

class $$SyncOperationRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncOperationRowsTable,
          SyncOperationRow,
          $$SyncOperationRowsTableFilterComposer,
          $$SyncOperationRowsTableOrderingComposer,
          $$SyncOperationRowsTableAnnotationComposer,
          $$SyncOperationRowsTableCreateCompanionBuilder,
          $$SyncOperationRowsTableUpdateCompanionBuilder,
          (
            SyncOperationRow,
            BaseReferences<
              _$AppDatabase,
              $SyncOperationRowsTable,
              SyncOperationRow
            >,
          ),
          SyncOperationRow,
          PrefetchHooks Function()
        > {
  $$SyncOperationRowsTableTableManager(
    _$AppDatabase db,
    $SyncOperationRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOperationRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOperationRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOperationRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> operationId = const Value.absent(),
                Value<String> operationType = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> nextRetryAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOperationRowsCompanion(
                operationId: operationId,
                operationType: operationType,
                payloadJson: payloadJson,
                createdAt: createdAt,
                idempotencyKey: idempotencyKey,
                attemptCount: attemptCount,
                status: status,
                nextRetryAt: nextRetryAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String operationId,
                required String operationType,
                required String payloadJson,
                Value<DateTime> createdAt = const Value.absent(),
                required String idempotencyKey,
                Value<int> attemptCount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> nextRetryAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOperationRowsCompanion.insert(
                operationId: operationId,
                operationType: operationType,
                payloadJson: payloadJson,
                createdAt: createdAt,
                idempotencyKey: idempotencyKey,
                attemptCount: attemptCount,
                status: status,
                nextRetryAt: nextRetryAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOperationRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncOperationRowsTable,
      SyncOperationRow,
      $$SyncOperationRowsTableFilterComposer,
      $$SyncOperationRowsTableOrderingComposer,
      $$SyncOperationRowsTableAnnotationComposer,
      $$SyncOperationRowsTableCreateCompanionBuilder,
      $$SyncOperationRowsTableUpdateCompanionBuilder,
      (
        SyncOperationRow,
        BaseReferences<
          _$AppDatabase,
          $SyncOperationRowsTable,
          SyncOperationRow
        >,
      ),
      SyncOperationRow,
      PrefetchHooks Function()
    >;
typedef $$WalletCacheRowsTableCreateCompanionBuilder =
    WalletCacheRowsCompanion Function({
      required String id,
      Value<String?> firebaseUid,
      Value<int> coinBalance,
      Value<int> hintBalance,
      Value<int> pendingCoinDelta,
      Value<int> pendingHintDelta,
      Value<int> walletRevision,
      Value<DateTime?> lastReconciledAt,
      Value<bool> isStale,
      Value<int> walletSchemaVersion,
      Value<int> rowid,
    });
typedef $$WalletCacheRowsTableUpdateCompanionBuilder =
    WalletCacheRowsCompanion Function({
      Value<String> id,
      Value<String?> firebaseUid,
      Value<int> coinBalance,
      Value<int> hintBalance,
      Value<int> pendingCoinDelta,
      Value<int> pendingHintDelta,
      Value<int> walletRevision,
      Value<DateTime?> lastReconciledAt,
      Value<bool> isStale,
      Value<int> walletSchemaVersion,
      Value<int> rowid,
    });

class $$WalletCacheRowsTableFilterComposer
    extends Composer<_$AppDatabase, $WalletCacheRowsTable> {
  $$WalletCacheRowsTableFilterComposer({
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

  ColumnFilters<String> get firebaseUid => $composableBuilder(
    column: $table.firebaseUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coinBalance => $composableBuilder(
    column: $table.coinBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hintBalance => $composableBuilder(
    column: $table.hintBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pendingCoinDelta => $composableBuilder(
    column: $table.pendingCoinDelta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pendingHintDelta => $composableBuilder(
    column: $table.pendingHintDelta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletRevision => $composableBuilder(
    column: $table.walletRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReconciledAt => $composableBuilder(
    column: $table.lastReconciledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStale => $composableBuilder(
    column: $table.isStale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get walletSchemaVersion => $composableBuilder(
    column: $table.walletSchemaVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletCacheRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletCacheRowsTable> {
  $$WalletCacheRowsTableOrderingComposer({
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

  ColumnOrderings<String> get firebaseUid => $composableBuilder(
    column: $table.firebaseUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coinBalance => $composableBuilder(
    column: $table.coinBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hintBalance => $composableBuilder(
    column: $table.hintBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pendingCoinDelta => $composableBuilder(
    column: $table.pendingCoinDelta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pendingHintDelta => $composableBuilder(
    column: $table.pendingHintDelta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletRevision => $composableBuilder(
    column: $table.walletRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReconciledAt => $composableBuilder(
    column: $table.lastReconciledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStale => $composableBuilder(
    column: $table.isStale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get walletSchemaVersion => $composableBuilder(
    column: $table.walletSchemaVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletCacheRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletCacheRowsTable> {
  $$WalletCacheRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firebaseUid => $composableBuilder(
    column: $table.firebaseUid,
    builder: (column) => column,
  );

  GeneratedColumn<int> get coinBalance => $composableBuilder(
    column: $table.coinBalance,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hintBalance => $composableBuilder(
    column: $table.hintBalance,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pendingCoinDelta => $composableBuilder(
    column: $table.pendingCoinDelta,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pendingHintDelta => $composableBuilder(
    column: $table.pendingHintDelta,
    builder: (column) => column,
  );

  GeneratedColumn<int> get walletRevision => $composableBuilder(
    column: $table.walletRevision,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastReconciledAt => $composableBuilder(
    column: $table.lastReconciledAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isStale =>
      $composableBuilder(column: $table.isStale, builder: (column) => column);

  GeneratedColumn<int> get walletSchemaVersion => $composableBuilder(
    column: $table.walletSchemaVersion,
    builder: (column) => column,
  );
}

class $$WalletCacheRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletCacheRowsTable,
          WalletCacheRow,
          $$WalletCacheRowsTableFilterComposer,
          $$WalletCacheRowsTableOrderingComposer,
          $$WalletCacheRowsTableAnnotationComposer,
          $$WalletCacheRowsTableCreateCompanionBuilder,
          $$WalletCacheRowsTableUpdateCompanionBuilder,
          (
            WalletCacheRow,
            BaseReferences<
              _$AppDatabase,
              $WalletCacheRowsTable,
              WalletCacheRow
            >,
          ),
          WalletCacheRow,
          PrefetchHooks Function()
        > {
  $$WalletCacheRowsTableTableManager(
    _$AppDatabase db,
    $WalletCacheRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletCacheRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletCacheRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletCacheRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> firebaseUid = const Value.absent(),
                Value<int> coinBalance = const Value.absent(),
                Value<int> hintBalance = const Value.absent(),
                Value<int> pendingCoinDelta = const Value.absent(),
                Value<int> pendingHintDelta = const Value.absent(),
                Value<int> walletRevision = const Value.absent(),
                Value<DateTime?> lastReconciledAt = const Value.absent(),
                Value<bool> isStale = const Value.absent(),
                Value<int> walletSchemaVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WalletCacheRowsCompanion(
                id: id,
                firebaseUid: firebaseUid,
                coinBalance: coinBalance,
                hintBalance: hintBalance,
                pendingCoinDelta: pendingCoinDelta,
                pendingHintDelta: pendingHintDelta,
                walletRevision: walletRevision,
                lastReconciledAt: lastReconciledAt,
                isStale: isStale,
                walletSchemaVersion: walletSchemaVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> firebaseUid = const Value.absent(),
                Value<int> coinBalance = const Value.absent(),
                Value<int> hintBalance = const Value.absent(),
                Value<int> pendingCoinDelta = const Value.absent(),
                Value<int> pendingHintDelta = const Value.absent(),
                Value<int> walletRevision = const Value.absent(),
                Value<DateTime?> lastReconciledAt = const Value.absent(),
                Value<bool> isStale = const Value.absent(),
                Value<int> walletSchemaVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WalletCacheRowsCompanion.insert(
                id: id,
                firebaseUid: firebaseUid,
                coinBalance: coinBalance,
                hintBalance: hintBalance,
                pendingCoinDelta: pendingCoinDelta,
                pendingHintDelta: pendingHintDelta,
                walletRevision: walletRevision,
                lastReconciledAt: lastReconciledAt,
                isStale: isStale,
                walletSchemaVersion: walletSchemaVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletCacheRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletCacheRowsTable,
      WalletCacheRow,
      $$WalletCacheRowsTableFilterComposer,
      $$WalletCacheRowsTableOrderingComposer,
      $$WalletCacheRowsTableAnnotationComposer,
      $$WalletCacheRowsTableCreateCompanionBuilder,
      $$WalletCacheRowsTableUpdateCompanionBuilder,
      (
        WalletCacheRow,
        BaseReferences<_$AppDatabase, $WalletCacheRowsTable, WalletCacheRow>,
      ),
      WalletCacheRow,
      PrefetchHooks Function()
    >;
typedef $$EconomyOperationRowsTableCreateCompanionBuilder =
    EconomyOperationRowsCompanion Function({
      required String operationId,
      required String operationType,
      required String idempotencyKey,
      required String payloadJson,
      Value<DateTime> createdAt,
      Value<int> coinDelta,
      Value<int> hintDelta,
      Value<String> status,
      Value<int> attemptCount,
      Value<DateTime?> nextRetryAt,
      Value<String?> serverTransactionId,
      Value<int> rowid,
    });
typedef $$EconomyOperationRowsTableUpdateCompanionBuilder =
    EconomyOperationRowsCompanion Function({
      Value<String> operationId,
      Value<String> operationType,
      Value<String> idempotencyKey,
      Value<String> payloadJson,
      Value<DateTime> createdAt,
      Value<int> coinDelta,
      Value<int> hintDelta,
      Value<String> status,
      Value<int> attemptCount,
      Value<DateTime?> nextRetryAt,
      Value<String?> serverTransactionId,
      Value<int> rowid,
    });

class $$EconomyOperationRowsTableFilterComposer
    extends Composer<_$AppDatabase, $EconomyOperationRowsTable> {
  $$EconomyOperationRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coinDelta => $composableBuilder(
    column: $table.coinDelta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hintDelta => $composableBuilder(
    column: $table.hintDelta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverTransactionId => $composableBuilder(
    column: $table.serverTransactionId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EconomyOperationRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $EconomyOperationRowsTable> {
  $$EconomyOperationRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coinDelta => $composableBuilder(
    column: $table.coinDelta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hintDelta => $composableBuilder(
    column: $table.hintDelta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverTransactionId => $composableBuilder(
    column: $table.serverTransactionId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EconomyOperationRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EconomyOperationRowsTable> {
  $$EconomyOperationRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get coinDelta =>
      $composableBuilder(column: $table.coinDelta, builder: (column) => column);

  GeneratedColumn<int> get hintDelta =>
      $composableBuilder(column: $table.hintDelta, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverTransactionId => $composableBuilder(
    column: $table.serverTransactionId,
    builder: (column) => column,
  );
}

class $$EconomyOperationRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EconomyOperationRowsTable,
          EconomyOperationRow,
          $$EconomyOperationRowsTableFilterComposer,
          $$EconomyOperationRowsTableOrderingComposer,
          $$EconomyOperationRowsTableAnnotationComposer,
          $$EconomyOperationRowsTableCreateCompanionBuilder,
          $$EconomyOperationRowsTableUpdateCompanionBuilder,
          (
            EconomyOperationRow,
            BaseReferences<
              _$AppDatabase,
              $EconomyOperationRowsTable,
              EconomyOperationRow
            >,
          ),
          EconomyOperationRow,
          PrefetchHooks Function()
        > {
  $$EconomyOperationRowsTableTableManager(
    _$AppDatabase db,
    $EconomyOperationRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EconomyOperationRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EconomyOperationRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EconomyOperationRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> operationId = const Value.absent(),
                Value<String> operationType = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> coinDelta = const Value.absent(),
                Value<int> hintDelta = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<DateTime?> nextRetryAt = const Value.absent(),
                Value<String?> serverTransactionId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EconomyOperationRowsCompanion(
                operationId: operationId,
                operationType: operationType,
                idempotencyKey: idempotencyKey,
                payloadJson: payloadJson,
                createdAt: createdAt,
                coinDelta: coinDelta,
                hintDelta: hintDelta,
                status: status,
                attemptCount: attemptCount,
                nextRetryAt: nextRetryAt,
                serverTransactionId: serverTransactionId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String operationId,
                required String operationType,
                required String idempotencyKey,
                required String payloadJson,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> coinDelta = const Value.absent(),
                Value<int> hintDelta = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<DateTime?> nextRetryAt = const Value.absent(),
                Value<String?> serverTransactionId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EconomyOperationRowsCompanion.insert(
                operationId: operationId,
                operationType: operationType,
                idempotencyKey: idempotencyKey,
                payloadJson: payloadJson,
                createdAt: createdAt,
                coinDelta: coinDelta,
                hintDelta: hintDelta,
                status: status,
                attemptCount: attemptCount,
                nextRetryAt: nextRetryAt,
                serverTransactionId: serverTransactionId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EconomyOperationRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EconomyOperationRowsTable,
      EconomyOperationRow,
      $$EconomyOperationRowsTableFilterComposer,
      $$EconomyOperationRowsTableOrderingComposer,
      $$EconomyOperationRowsTableAnnotationComposer,
      $$EconomyOperationRowsTableCreateCompanionBuilder,
      $$EconomyOperationRowsTableUpdateCompanionBuilder,
      (
        EconomyOperationRow,
        BaseReferences<
          _$AppDatabase,
          $EconomyOperationRowsTable,
          EconomyOperationRow
        >,
      ),
      EconomyOperationRow,
      PrefetchHooks Function()
    >;
typedef $$EntitlementRowsTableCreateCompanionBuilder =
    EntitlementRowsCompanion Function({
      required String entitlementType,
      Value<bool> active,
      Value<String> source,
      Value<String?> storeProductId,
      Value<String?> purchaseId,
      Value<DateTime?> validatedAt,
      Value<int> revision,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$EntitlementRowsTableUpdateCompanionBuilder =
    EntitlementRowsCompanion Function({
      Value<String> entitlementType,
      Value<bool> active,
      Value<String> source,
      Value<String?> storeProductId,
      Value<String?> purchaseId,
      Value<DateTime?> validatedAt,
      Value<int> revision,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$EntitlementRowsTableFilterComposer
    extends Composer<_$AppDatabase, $EntitlementRowsTable> {
  $$EntitlementRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entitlementType => $composableBuilder(
    column: $table.entitlementType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeProductId => $composableBuilder(
    column: $table.storeProductId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validatedAt => $composableBuilder(
    column: $table.validatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EntitlementRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $EntitlementRowsTable> {
  $$EntitlementRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entitlementType => $composableBuilder(
    column: $table.entitlementType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeProductId => $composableBuilder(
    column: $table.storeProductId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validatedAt => $composableBuilder(
    column: $table.validatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revision => $composableBuilder(
    column: $table.revision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EntitlementRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntitlementRowsTable> {
  $$EntitlementRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entitlementType => $composableBuilder(
    column: $table.entitlementType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get storeProductId => $composableBuilder(
    column: $table.storeProductId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get validatedAt => $composableBuilder(
    column: $table.validatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$EntitlementRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EntitlementRowsTable,
          EntitlementRow,
          $$EntitlementRowsTableFilterComposer,
          $$EntitlementRowsTableOrderingComposer,
          $$EntitlementRowsTableAnnotationComposer,
          $$EntitlementRowsTableCreateCompanionBuilder,
          $$EntitlementRowsTableUpdateCompanionBuilder,
          (
            EntitlementRow,
            BaseReferences<
              _$AppDatabase,
              $EntitlementRowsTable,
              EntitlementRow
            >,
          ),
          EntitlementRow,
          PrefetchHooks Function()
        > {
  $$EntitlementRowsTableTableManager(
    _$AppDatabase db,
    $EntitlementRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntitlementRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntitlementRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntitlementRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> entitlementType = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> storeProductId = const Value.absent(),
                Value<String?> purchaseId = const Value.absent(),
                Value<DateTime?> validatedAt = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntitlementRowsCompanion(
                entitlementType: entitlementType,
                active: active,
                source: source,
                storeProductId: storeProductId,
                purchaseId: purchaseId,
                validatedAt: validatedAt,
                revision: revision,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entitlementType,
                Value<bool> active = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> storeProductId = const Value.absent(),
                Value<String?> purchaseId = const Value.absent(),
                Value<DateTime?> validatedAt = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntitlementRowsCompanion.insert(
                entitlementType: entitlementType,
                active: active,
                source: source,
                storeProductId: storeProductId,
                purchaseId: purchaseId,
                validatedAt: validatedAt,
                revision: revision,
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

typedef $$EntitlementRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EntitlementRowsTable,
      EntitlementRow,
      $$EntitlementRowsTableFilterComposer,
      $$EntitlementRowsTableOrderingComposer,
      $$EntitlementRowsTableAnnotationComposer,
      $$EntitlementRowsTableCreateCompanionBuilder,
      $$EntitlementRowsTableUpdateCompanionBuilder,
      (
        EntitlementRow,
        BaseReferences<_$AppDatabase, $EntitlementRowsTable, EntitlementRow>,
      ),
      EntitlementRow,
      PrefetchHooks Function()
    >;
typedef $$MonetizationStateRowsTableCreateCompanionBuilder =
    MonetizationStateRowsCompanion Function({
      required String id,
      Value<int> levelsSinceLastInterstitial,
      Value<DateTime?> lastRewardedAdAt,
      Value<DateTime?> lastPurchaseAt,
      Value<DateTime?> lastTutorialCompletedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$MonetizationStateRowsTableUpdateCompanionBuilder =
    MonetizationStateRowsCompanion Function({
      Value<String> id,
      Value<int> levelsSinceLastInterstitial,
      Value<DateTime?> lastRewardedAdAt,
      Value<DateTime?> lastPurchaseAt,
      Value<DateTime?> lastTutorialCompletedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$MonetizationStateRowsTableFilterComposer
    extends Composer<_$AppDatabase, $MonetizationStateRowsTable> {
  $$MonetizationStateRowsTableFilterComposer({
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

  ColumnFilters<int> get levelsSinceLastInterstitial => $composableBuilder(
    column: $table.levelsSinceLastInterstitial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastRewardedAdAt => $composableBuilder(
    column: $table.lastRewardedAdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPurchaseAt => $composableBuilder(
    column: $table.lastPurchaseAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastTutorialCompletedAt => $composableBuilder(
    column: $table.lastTutorialCompletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MonetizationStateRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $MonetizationStateRowsTable> {
  $$MonetizationStateRowsTableOrderingComposer({
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

  ColumnOrderings<int> get levelsSinceLastInterstitial => $composableBuilder(
    column: $table.levelsSinceLastInterstitial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastRewardedAdAt => $composableBuilder(
    column: $table.lastRewardedAdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPurchaseAt => $composableBuilder(
    column: $table.lastPurchaseAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastTutorialCompletedAt => $composableBuilder(
    column: $table.lastTutorialCompletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MonetizationStateRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonetizationStateRowsTable> {
  $$MonetizationStateRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get levelsSinceLastInterstitial => $composableBuilder(
    column: $table.levelsSinceLastInterstitial,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastRewardedAdAt => $composableBuilder(
    column: $table.lastRewardedAdAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastPurchaseAt => $composableBuilder(
    column: $table.lastPurchaseAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastTutorialCompletedAt => $composableBuilder(
    column: $table.lastTutorialCompletedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MonetizationStateRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MonetizationStateRowsTable,
          MonetizationStateRow,
          $$MonetizationStateRowsTableFilterComposer,
          $$MonetizationStateRowsTableOrderingComposer,
          $$MonetizationStateRowsTableAnnotationComposer,
          $$MonetizationStateRowsTableCreateCompanionBuilder,
          $$MonetizationStateRowsTableUpdateCompanionBuilder,
          (
            MonetizationStateRow,
            BaseReferences<
              _$AppDatabase,
              $MonetizationStateRowsTable,
              MonetizationStateRow
            >,
          ),
          MonetizationStateRow,
          PrefetchHooks Function()
        > {
  $$MonetizationStateRowsTableTableManager(
    _$AppDatabase db,
    $MonetizationStateRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonetizationStateRowsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$MonetizationStateRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MonetizationStateRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> levelsSinceLastInterstitial = const Value.absent(),
                Value<DateTime?> lastRewardedAdAt = const Value.absent(),
                Value<DateTime?> lastPurchaseAt = const Value.absent(),
                Value<DateTime?> lastTutorialCompletedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MonetizationStateRowsCompanion(
                id: id,
                levelsSinceLastInterstitial: levelsSinceLastInterstitial,
                lastRewardedAdAt: lastRewardedAdAt,
                lastPurchaseAt: lastPurchaseAt,
                lastTutorialCompletedAt: lastTutorialCompletedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int> levelsSinceLastInterstitial = const Value.absent(),
                Value<DateTime?> lastRewardedAdAt = const Value.absent(),
                Value<DateTime?> lastPurchaseAt = const Value.absent(),
                Value<DateTime?> lastTutorialCompletedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MonetizationStateRowsCompanion.insert(
                id: id,
                levelsSinceLastInterstitial: levelsSinceLastInterstitial,
                lastRewardedAdAt: lastRewardedAdAt,
                lastPurchaseAt: lastPurchaseAt,
                lastTutorialCompletedAt: lastTutorialCompletedAt,
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

typedef $$MonetizationStateRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MonetizationStateRowsTable,
      MonetizationStateRow,
      $$MonetizationStateRowsTableFilterComposer,
      $$MonetizationStateRowsTableOrderingComposer,
      $$MonetizationStateRowsTableAnnotationComposer,
      $$MonetizationStateRowsTableCreateCompanionBuilder,
      $$MonetizationStateRowsTableUpdateCompanionBuilder,
      (
        MonetizationStateRow,
        BaseReferences<
          _$AppDatabase,
          $MonetizationStateRowsTable,
          MonetizationStateRow
        >,
      ),
      MonetizationStateRow,
      PrefetchHooks Function()
    >;
typedef $$RewardedAdReceiptRowsTableCreateCompanionBuilder =
    RewardedAdReceiptRowsCompanion Function({
      required String operationId,
      required String rewardType,
      Value<bool> adCompleted,
      Value<String?> attemptId,
      Value<bool> backendGranted,
      Value<bool> localEffectApplied,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$RewardedAdReceiptRowsTableUpdateCompanionBuilder =
    RewardedAdReceiptRowsCompanion Function({
      Value<String> operationId,
      Value<String> rewardType,
      Value<bool> adCompleted,
      Value<String?> attemptId,
      Value<bool> backendGranted,
      Value<bool> localEffectApplied,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$RewardedAdReceiptRowsTableFilterComposer
    extends Composer<_$AppDatabase, $RewardedAdReceiptRowsTable> {
  $$RewardedAdReceiptRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rewardType => $composableBuilder(
    column: $table.rewardType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get adCompleted => $composableBuilder(
    column: $table.adCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attemptId => $composableBuilder(
    column: $table.attemptId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get backendGranted => $composableBuilder(
    column: $table.backendGranted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get localEffectApplied => $composableBuilder(
    column: $table.localEffectApplied,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RewardedAdReceiptRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $RewardedAdReceiptRowsTable> {
  $$RewardedAdReceiptRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rewardType => $composableBuilder(
    column: $table.rewardType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get adCompleted => $composableBuilder(
    column: $table.adCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attemptId => $composableBuilder(
    column: $table.attemptId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get backendGranted => $composableBuilder(
    column: $table.backendGranted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get localEffectApplied => $composableBuilder(
    column: $table.localEffectApplied,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RewardedAdReceiptRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RewardedAdReceiptRowsTable> {
  $$RewardedAdReceiptRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get operationId => $composableBuilder(
    column: $table.operationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rewardType => $composableBuilder(
    column: $table.rewardType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get adCompleted => $composableBuilder(
    column: $table.adCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get attemptId =>
      $composableBuilder(column: $table.attemptId, builder: (column) => column);

  GeneratedColumn<bool> get backendGranted => $composableBuilder(
    column: $table.backendGranted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get localEffectApplied => $composableBuilder(
    column: $table.localEffectApplied,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RewardedAdReceiptRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RewardedAdReceiptRowsTable,
          RewardedAdReceiptRow,
          $$RewardedAdReceiptRowsTableFilterComposer,
          $$RewardedAdReceiptRowsTableOrderingComposer,
          $$RewardedAdReceiptRowsTableAnnotationComposer,
          $$RewardedAdReceiptRowsTableCreateCompanionBuilder,
          $$RewardedAdReceiptRowsTableUpdateCompanionBuilder,
          (
            RewardedAdReceiptRow,
            BaseReferences<
              _$AppDatabase,
              $RewardedAdReceiptRowsTable,
              RewardedAdReceiptRow
            >,
          ),
          RewardedAdReceiptRow,
          PrefetchHooks Function()
        > {
  $$RewardedAdReceiptRowsTableTableManager(
    _$AppDatabase db,
    $RewardedAdReceiptRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RewardedAdReceiptRowsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RewardedAdReceiptRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RewardedAdReceiptRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> operationId = const Value.absent(),
                Value<String> rewardType = const Value.absent(),
                Value<bool> adCompleted = const Value.absent(),
                Value<String?> attemptId = const Value.absent(),
                Value<bool> backendGranted = const Value.absent(),
                Value<bool> localEffectApplied = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RewardedAdReceiptRowsCompanion(
                operationId: operationId,
                rewardType: rewardType,
                adCompleted: adCompleted,
                attemptId: attemptId,
                backendGranted: backendGranted,
                localEffectApplied: localEffectApplied,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String operationId,
                required String rewardType,
                Value<bool> adCompleted = const Value.absent(),
                Value<String?> attemptId = const Value.absent(),
                Value<bool> backendGranted = const Value.absent(),
                Value<bool> localEffectApplied = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RewardedAdReceiptRowsCompanion.insert(
                operationId: operationId,
                rewardType: rewardType,
                adCompleted: adCompleted,
                attemptId: attemptId,
                backendGranted: backendGranted,
                localEffectApplied: localEffectApplied,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RewardedAdReceiptRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RewardedAdReceiptRowsTable,
      RewardedAdReceiptRow,
      $$RewardedAdReceiptRowsTableFilterComposer,
      $$RewardedAdReceiptRowsTableOrderingComposer,
      $$RewardedAdReceiptRowsTableAnnotationComposer,
      $$RewardedAdReceiptRowsTableCreateCompanionBuilder,
      $$RewardedAdReceiptRowsTableUpdateCompanionBuilder,
      (
        RewardedAdReceiptRow,
        BaseReferences<
          _$AppDatabase,
          $RewardedAdReceiptRowsTable,
          RewardedAdReceiptRow
        >,
      ),
      RewardedAdReceiptRow,
      PrefetchHooks Function()
    >;
typedef $$DailyStateCacheRowsTableCreateCompanionBuilder =
    DailyStateCacheRowsCompanion Function({
      required String id,
      required String dayKey,
      Value<String> timezoneId,
      Value<int> timezoneOffsetMinutes,
      Value<int> rewardCalendarDayIndex,
      Value<String?> rewardLastClaimedDayKey,
      Value<DateTime?> rewardLastClaimedAt,
      Value<int> rewardRevision,
      Value<int> streakCurrentDays,
      Value<String?> streakLastQualifiedDayKey,
      Value<int> streakLongestDays,
      Value<String> streakClaimedMilestonesJson,
      Value<String> streakCycleId,
      Value<int> streakRevision,
      Value<String?> challengeCurrentDayKey,
      Value<String?> challengeId,
      Value<bool> challengeCompleted,
      Value<bool> challengeRewardGranted,
      Value<DateTime?> challengeCompletedAt,
      Value<int> challengeAttemptCount,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });
typedef $$DailyStateCacheRowsTableUpdateCompanionBuilder =
    DailyStateCacheRowsCompanion Function({
      Value<String> id,
      Value<String> dayKey,
      Value<String> timezoneId,
      Value<int> timezoneOffsetMinutes,
      Value<int> rewardCalendarDayIndex,
      Value<String?> rewardLastClaimedDayKey,
      Value<DateTime?> rewardLastClaimedAt,
      Value<int> rewardRevision,
      Value<int> streakCurrentDays,
      Value<String?> streakLastQualifiedDayKey,
      Value<int> streakLongestDays,
      Value<String> streakClaimedMilestonesJson,
      Value<String> streakCycleId,
      Value<int> streakRevision,
      Value<String?> challengeCurrentDayKey,
      Value<String?> challengeId,
      Value<bool> challengeCompleted,
      Value<bool> challengeRewardGranted,
      Value<DateTime?> challengeCompletedAt,
      Value<int> challengeAttemptCount,
      Value<DateTime> fetchedAt,
      Value<int> rowid,
    });

class $$DailyStateCacheRowsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyStateCacheRowsTable> {
  $$DailyStateCacheRowsTableFilterComposer({
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

  ColumnFilters<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezoneId => $composableBuilder(
    column: $table.timezoneId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timezoneOffsetMinutes => $composableBuilder(
    column: $table.timezoneOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rewardCalendarDayIndex => $composableBuilder(
    column: $table.rewardCalendarDayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rewardLastClaimedDayKey => $composableBuilder(
    column: $table.rewardLastClaimedDayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get rewardLastClaimedAt => $composableBuilder(
    column: $table.rewardLastClaimedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rewardRevision => $composableBuilder(
    column: $table.rewardRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get streakCurrentDays => $composableBuilder(
    column: $table.streakCurrentDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get streakLastQualifiedDayKey => $composableBuilder(
    column: $table.streakLastQualifiedDayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get streakLongestDays => $composableBuilder(
    column: $table.streakLongestDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get streakClaimedMilestonesJson => $composableBuilder(
    column: $table.streakClaimedMilestonesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get streakCycleId => $composableBuilder(
    column: $table.streakCycleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get streakRevision => $composableBuilder(
    column: $table.streakRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get challengeCurrentDayKey => $composableBuilder(
    column: $table.challengeCurrentDayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get challengeId => $composableBuilder(
    column: $table.challengeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get challengeCompleted => $composableBuilder(
    column: $table.challengeCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get challengeRewardGranted => $composableBuilder(
    column: $table.challengeRewardGranted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get challengeCompletedAt => $composableBuilder(
    column: $table.challengeCompletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get challengeAttemptCount => $composableBuilder(
    column: $table.challengeAttemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyStateCacheRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyStateCacheRowsTable> {
  $$DailyStateCacheRowsTableOrderingComposer({
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

  ColumnOrderings<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezoneId => $composableBuilder(
    column: $table.timezoneId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timezoneOffsetMinutes => $composableBuilder(
    column: $table.timezoneOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rewardCalendarDayIndex => $composableBuilder(
    column: $table.rewardCalendarDayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rewardLastClaimedDayKey => $composableBuilder(
    column: $table.rewardLastClaimedDayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get rewardLastClaimedAt => $composableBuilder(
    column: $table.rewardLastClaimedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rewardRevision => $composableBuilder(
    column: $table.rewardRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streakCurrentDays => $composableBuilder(
    column: $table.streakCurrentDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get streakLastQualifiedDayKey => $composableBuilder(
    column: $table.streakLastQualifiedDayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streakLongestDays => $composableBuilder(
    column: $table.streakLongestDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get streakClaimedMilestonesJson => $composableBuilder(
    column: $table.streakClaimedMilestonesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get streakCycleId => $composableBuilder(
    column: $table.streakCycleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streakRevision => $composableBuilder(
    column: $table.streakRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get challengeCurrentDayKey => $composableBuilder(
    column: $table.challengeCurrentDayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get challengeId => $composableBuilder(
    column: $table.challengeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get challengeCompleted => $composableBuilder(
    column: $table.challengeCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get challengeRewardGranted => $composableBuilder(
    column: $table.challengeRewardGranted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get challengeCompletedAt => $composableBuilder(
    column: $table.challengeCompletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get challengeAttemptCount => $composableBuilder(
    column: $table.challengeAttemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyStateCacheRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyStateCacheRowsTable> {
  $$DailyStateCacheRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => column);

  GeneratedColumn<String> get timezoneId => $composableBuilder(
    column: $table.timezoneId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timezoneOffsetMinutes => $composableBuilder(
    column: $table.timezoneOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rewardCalendarDayIndex => $composableBuilder(
    column: $table.rewardCalendarDayIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rewardLastClaimedDayKey => $composableBuilder(
    column: $table.rewardLastClaimedDayKey,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get rewardLastClaimedAt => $composableBuilder(
    column: $table.rewardLastClaimedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rewardRevision => $composableBuilder(
    column: $table.rewardRevision,
    builder: (column) => column,
  );

  GeneratedColumn<int> get streakCurrentDays => $composableBuilder(
    column: $table.streakCurrentDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get streakLastQualifiedDayKey => $composableBuilder(
    column: $table.streakLastQualifiedDayKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get streakLongestDays => $composableBuilder(
    column: $table.streakLongestDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get streakClaimedMilestonesJson => $composableBuilder(
    column: $table.streakClaimedMilestonesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get streakCycleId => $composableBuilder(
    column: $table.streakCycleId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get streakRevision => $composableBuilder(
    column: $table.streakRevision,
    builder: (column) => column,
  );

  GeneratedColumn<String> get challengeCurrentDayKey => $composableBuilder(
    column: $table.challengeCurrentDayKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get challengeId => $composableBuilder(
    column: $table.challengeId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get challengeCompleted => $composableBuilder(
    column: $table.challengeCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get challengeRewardGranted => $composableBuilder(
    column: $table.challengeRewardGranted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get challengeCompletedAt => $composableBuilder(
    column: $table.challengeCompletedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get challengeAttemptCount => $composableBuilder(
    column: $table.challengeAttemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$DailyStateCacheRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyStateCacheRowsTable,
          DailyStateCacheRow,
          $$DailyStateCacheRowsTableFilterComposer,
          $$DailyStateCacheRowsTableOrderingComposer,
          $$DailyStateCacheRowsTableAnnotationComposer,
          $$DailyStateCacheRowsTableCreateCompanionBuilder,
          $$DailyStateCacheRowsTableUpdateCompanionBuilder,
          (
            DailyStateCacheRow,
            BaseReferences<
              _$AppDatabase,
              $DailyStateCacheRowsTable,
              DailyStateCacheRow
            >,
          ),
          DailyStateCacheRow,
          PrefetchHooks Function()
        > {
  $$DailyStateCacheRowsTableTableManager(
    _$AppDatabase db,
    $DailyStateCacheRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyStateCacheRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyStateCacheRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DailyStateCacheRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> dayKey = const Value.absent(),
                Value<String> timezoneId = const Value.absent(),
                Value<int> timezoneOffsetMinutes = const Value.absent(),
                Value<int> rewardCalendarDayIndex = const Value.absent(),
                Value<String?> rewardLastClaimedDayKey = const Value.absent(),
                Value<DateTime?> rewardLastClaimedAt = const Value.absent(),
                Value<int> rewardRevision = const Value.absent(),
                Value<int> streakCurrentDays = const Value.absent(),
                Value<String?> streakLastQualifiedDayKey = const Value.absent(),
                Value<int> streakLongestDays = const Value.absent(),
                Value<String> streakClaimedMilestonesJson =
                    const Value.absent(),
                Value<String> streakCycleId = const Value.absent(),
                Value<int> streakRevision = const Value.absent(),
                Value<String?> challengeCurrentDayKey = const Value.absent(),
                Value<String?> challengeId = const Value.absent(),
                Value<bool> challengeCompleted = const Value.absent(),
                Value<bool> challengeRewardGranted = const Value.absent(),
                Value<DateTime?> challengeCompletedAt = const Value.absent(),
                Value<int> challengeAttemptCount = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyStateCacheRowsCompanion(
                id: id,
                dayKey: dayKey,
                timezoneId: timezoneId,
                timezoneOffsetMinutes: timezoneOffsetMinutes,
                rewardCalendarDayIndex: rewardCalendarDayIndex,
                rewardLastClaimedDayKey: rewardLastClaimedDayKey,
                rewardLastClaimedAt: rewardLastClaimedAt,
                rewardRevision: rewardRevision,
                streakCurrentDays: streakCurrentDays,
                streakLastQualifiedDayKey: streakLastQualifiedDayKey,
                streakLongestDays: streakLongestDays,
                streakClaimedMilestonesJson: streakClaimedMilestonesJson,
                streakCycleId: streakCycleId,
                streakRevision: streakRevision,
                challengeCurrentDayKey: challengeCurrentDayKey,
                challengeId: challengeId,
                challengeCompleted: challengeCompleted,
                challengeRewardGranted: challengeRewardGranted,
                challengeCompletedAt: challengeCompletedAt,
                challengeAttemptCount: challengeAttemptCount,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String dayKey,
                Value<String> timezoneId = const Value.absent(),
                Value<int> timezoneOffsetMinutes = const Value.absent(),
                Value<int> rewardCalendarDayIndex = const Value.absent(),
                Value<String?> rewardLastClaimedDayKey = const Value.absent(),
                Value<DateTime?> rewardLastClaimedAt = const Value.absent(),
                Value<int> rewardRevision = const Value.absent(),
                Value<int> streakCurrentDays = const Value.absent(),
                Value<String?> streakLastQualifiedDayKey = const Value.absent(),
                Value<int> streakLongestDays = const Value.absent(),
                Value<String> streakClaimedMilestonesJson =
                    const Value.absent(),
                Value<String> streakCycleId = const Value.absent(),
                Value<int> streakRevision = const Value.absent(),
                Value<String?> challengeCurrentDayKey = const Value.absent(),
                Value<String?> challengeId = const Value.absent(),
                Value<bool> challengeCompleted = const Value.absent(),
                Value<bool> challengeRewardGranted = const Value.absent(),
                Value<DateTime?> challengeCompletedAt = const Value.absent(),
                Value<int> challengeAttemptCount = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyStateCacheRowsCompanion.insert(
                id: id,
                dayKey: dayKey,
                timezoneId: timezoneId,
                timezoneOffsetMinutes: timezoneOffsetMinutes,
                rewardCalendarDayIndex: rewardCalendarDayIndex,
                rewardLastClaimedDayKey: rewardLastClaimedDayKey,
                rewardLastClaimedAt: rewardLastClaimedAt,
                rewardRevision: rewardRevision,
                streakCurrentDays: streakCurrentDays,
                streakLastQualifiedDayKey: streakLastQualifiedDayKey,
                streakLongestDays: streakLongestDays,
                streakClaimedMilestonesJson: streakClaimedMilestonesJson,
                streakCycleId: streakCycleId,
                streakRevision: streakRevision,
                challengeCurrentDayKey: challengeCurrentDayKey,
                challengeId: challengeId,
                challengeCompleted: challengeCompleted,
                challengeRewardGranted: challengeRewardGranted,
                challengeCompletedAt: challengeCompletedAt,
                challengeAttemptCount: challengeAttemptCount,
                fetchedAt: fetchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyStateCacheRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyStateCacheRowsTable,
      DailyStateCacheRow,
      $$DailyStateCacheRowsTableFilterComposer,
      $$DailyStateCacheRowsTableOrderingComposer,
      $$DailyStateCacheRowsTableAnnotationComposer,
      $$DailyStateCacheRowsTableCreateCompanionBuilder,
      $$DailyStateCacheRowsTableUpdateCompanionBuilder,
      (
        DailyStateCacheRow,
        BaseReferences<
          _$AppDatabase,
          $DailyStateCacheRowsTable,
          DailyStateCacheRow
        >,
      ),
      DailyStateCacheRow,
      PrefetchHooks Function()
    >;
typedef $$DailyChallengeCacheRowsTableCreateCompanionBuilder =
    DailyChallengeCacheRowsCompanion Function({
      required String challengeId,
      required String dayKey,
      required String cohortKey,
      required int seed,
      required int rewardAmount,
      required DateTime activeFrom,
      required DateTime activeUntil,
      required int rulesVersion,
      required int generatorVersion,
      required int solverVersion,
      Value<String?> contentBundleVersion,
      Value<String?> boardFingerprint,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });
typedef $$DailyChallengeCacheRowsTableUpdateCompanionBuilder =
    DailyChallengeCacheRowsCompanion Function({
      Value<String> challengeId,
      Value<String> dayKey,
      Value<String> cohortKey,
      Value<int> seed,
      Value<int> rewardAmount,
      Value<DateTime> activeFrom,
      Value<DateTime> activeUntil,
      Value<int> rulesVersion,
      Value<int> generatorVersion,
      Value<int> solverVersion,
      Value<String?> contentBundleVersion,
      Value<String?> boardFingerprint,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$DailyChallengeCacheRowsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyChallengeCacheRowsTable> {
  $$DailyChallengeCacheRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get challengeId => $composableBuilder(
    column: $table.challengeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cohortKey => $composableBuilder(
    column: $table.cohortKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seed => $composableBuilder(
    column: $table.seed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rewardAmount => $composableBuilder(
    column: $table.rewardAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get activeFrom => $composableBuilder(
    column: $table.activeFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get activeUntil => $composableBuilder(
    column: $table.activeUntil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rulesVersion => $composableBuilder(
    column: $table.rulesVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get generatorVersion => $composableBuilder(
    column: $table.generatorVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get solverVersion => $composableBuilder(
    column: $table.solverVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentBundleVersion => $composableBuilder(
    column: $table.contentBundleVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get boardFingerprint => $composableBuilder(
    column: $table.boardFingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyChallengeCacheRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyChallengeCacheRowsTable> {
  $$DailyChallengeCacheRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get challengeId => $composableBuilder(
    column: $table.challengeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cohortKey => $composableBuilder(
    column: $table.cohortKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seed => $composableBuilder(
    column: $table.seed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rewardAmount => $composableBuilder(
    column: $table.rewardAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get activeFrom => $composableBuilder(
    column: $table.activeFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get activeUntil => $composableBuilder(
    column: $table.activeUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rulesVersion => $composableBuilder(
    column: $table.rulesVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get generatorVersion => $composableBuilder(
    column: $table.generatorVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get solverVersion => $composableBuilder(
    column: $table.solverVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentBundleVersion => $composableBuilder(
    column: $table.contentBundleVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get boardFingerprint => $composableBuilder(
    column: $table.boardFingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyChallengeCacheRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyChallengeCacheRowsTable> {
  $$DailyChallengeCacheRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get challengeId => $composableBuilder(
    column: $table.challengeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => column);

  GeneratedColumn<String> get cohortKey =>
      $composableBuilder(column: $table.cohortKey, builder: (column) => column);

  GeneratedColumn<int> get seed =>
      $composableBuilder(column: $table.seed, builder: (column) => column);

  GeneratedColumn<int> get rewardAmount => $composableBuilder(
    column: $table.rewardAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get activeFrom => $composableBuilder(
    column: $table.activeFrom,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get activeUntil => $composableBuilder(
    column: $table.activeUntil,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rulesVersion => $composableBuilder(
    column: $table.rulesVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get generatorVersion => $composableBuilder(
    column: $table.generatorVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get solverVersion => $composableBuilder(
    column: $table.solverVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentBundleVersion => $composableBuilder(
    column: $table.contentBundleVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get boardFingerprint => $composableBuilder(
    column: $table.boardFingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$DailyChallengeCacheRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyChallengeCacheRowsTable,
          DailyChallengeCacheRow,
          $$DailyChallengeCacheRowsTableFilterComposer,
          $$DailyChallengeCacheRowsTableOrderingComposer,
          $$DailyChallengeCacheRowsTableAnnotationComposer,
          $$DailyChallengeCacheRowsTableCreateCompanionBuilder,
          $$DailyChallengeCacheRowsTableUpdateCompanionBuilder,
          (
            DailyChallengeCacheRow,
            BaseReferences<
              _$AppDatabase,
              $DailyChallengeCacheRowsTable,
              DailyChallengeCacheRow
            >,
          ),
          DailyChallengeCacheRow,
          PrefetchHooks Function()
        > {
  $$DailyChallengeCacheRowsTableTableManager(
    _$AppDatabase db,
    $DailyChallengeCacheRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyChallengeCacheRowsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DailyChallengeCacheRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DailyChallengeCacheRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> challengeId = const Value.absent(),
                Value<String> dayKey = const Value.absent(),
                Value<String> cohortKey = const Value.absent(),
                Value<int> seed = const Value.absent(),
                Value<int> rewardAmount = const Value.absent(),
                Value<DateTime> activeFrom = const Value.absent(),
                Value<DateTime> activeUntil = const Value.absent(),
                Value<int> rulesVersion = const Value.absent(),
                Value<int> generatorVersion = const Value.absent(),
                Value<int> solverVersion = const Value.absent(),
                Value<String?> contentBundleVersion = const Value.absent(),
                Value<String?> boardFingerprint = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyChallengeCacheRowsCompanion(
                challengeId: challengeId,
                dayKey: dayKey,
                cohortKey: cohortKey,
                seed: seed,
                rewardAmount: rewardAmount,
                activeFrom: activeFrom,
                activeUntil: activeUntil,
                rulesVersion: rulesVersion,
                generatorVersion: generatorVersion,
                solverVersion: solverVersion,
                contentBundleVersion: contentBundleVersion,
                boardFingerprint: boardFingerprint,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String challengeId,
                required String dayKey,
                required String cohortKey,
                required int seed,
                required int rewardAmount,
                required DateTime activeFrom,
                required DateTime activeUntil,
                required int rulesVersion,
                required int generatorVersion,
                required int solverVersion,
                Value<String?> contentBundleVersion = const Value.absent(),
                Value<String?> boardFingerprint = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyChallengeCacheRowsCompanion.insert(
                challengeId: challengeId,
                dayKey: dayKey,
                cohortKey: cohortKey,
                seed: seed,
                rewardAmount: rewardAmount,
                activeFrom: activeFrom,
                activeUntil: activeUntil,
                rulesVersion: rulesVersion,
                generatorVersion: generatorVersion,
                solverVersion: solverVersion,
                contentBundleVersion: contentBundleVersion,
                boardFingerprint: boardFingerprint,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyChallengeCacheRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyChallengeCacheRowsTable,
      DailyChallengeCacheRow,
      $$DailyChallengeCacheRowsTableFilterComposer,
      $$DailyChallengeCacheRowsTableOrderingComposer,
      $$DailyChallengeCacheRowsTableAnnotationComposer,
      $$DailyChallengeCacheRowsTableCreateCompanionBuilder,
      $$DailyChallengeCacheRowsTableUpdateCompanionBuilder,
      (
        DailyChallengeCacheRow,
        BaseReferences<
          _$AppDatabase,
          $DailyChallengeCacheRowsTable,
          DailyChallengeCacheRow
        >,
      ),
      DailyChallengeCacheRow,
      PrefetchHooks Function()
    >;
typedef $$NotificationPreferenceRowsTableCreateCompanionBuilder =
    NotificationPreferenceRowsCompanion Function({
      required String id,
      Value<bool> dailyChallengeEnabled,
      Value<bool> streakRiskEnabled,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$NotificationPreferenceRowsTableUpdateCompanionBuilder =
    NotificationPreferenceRowsCompanion Function({
      Value<String> id,
      Value<bool> dailyChallengeEnabled,
      Value<bool> streakRiskEnabled,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$NotificationPreferenceRowsTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationPreferenceRowsTable> {
  $$NotificationPreferenceRowsTableFilterComposer({
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

  ColumnFilters<bool> get dailyChallengeEnabled => $composableBuilder(
    column: $table.dailyChallengeEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get streakRiskEnabled => $composableBuilder(
    column: $table.streakRiskEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationPreferenceRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationPreferenceRowsTable> {
  $$NotificationPreferenceRowsTableOrderingComposer({
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

  ColumnOrderings<bool> get dailyChallengeEnabled => $composableBuilder(
    column: $table.dailyChallengeEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get streakRiskEnabled => $composableBuilder(
    column: $table.streakRiskEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationPreferenceRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationPreferenceRowsTable> {
  $$NotificationPreferenceRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get dailyChallengeEnabled => $composableBuilder(
    column: $table.dailyChallengeEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get streakRiskEnabled => $composableBuilder(
    column: $table.streakRiskEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NotificationPreferenceRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationPreferenceRowsTable,
          NotificationPreferenceRow,
          $$NotificationPreferenceRowsTableFilterComposer,
          $$NotificationPreferenceRowsTableOrderingComposer,
          $$NotificationPreferenceRowsTableAnnotationComposer,
          $$NotificationPreferenceRowsTableCreateCompanionBuilder,
          $$NotificationPreferenceRowsTableUpdateCompanionBuilder,
          (
            NotificationPreferenceRow,
            BaseReferences<
              _$AppDatabase,
              $NotificationPreferenceRowsTable,
              NotificationPreferenceRow
            >,
          ),
          NotificationPreferenceRow,
          PrefetchHooks Function()
        > {
  $$NotificationPreferenceRowsTableTableManager(
    _$AppDatabase db,
    $NotificationPreferenceRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationPreferenceRowsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$NotificationPreferenceRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$NotificationPreferenceRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<bool> dailyChallengeEnabled = const Value.absent(),
                Value<bool> streakRiskEnabled = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationPreferenceRowsCompanion(
                id: id,
                dailyChallengeEnabled: dailyChallengeEnabled,
                streakRiskEnabled: streakRiskEnabled,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<bool> dailyChallengeEnabled = const Value.absent(),
                Value<bool> streakRiskEnabled = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationPreferenceRowsCompanion.insert(
                id: id,
                dailyChallengeEnabled: dailyChallengeEnabled,
                streakRiskEnabled: streakRiskEnabled,
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

typedef $$NotificationPreferenceRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationPreferenceRowsTable,
      NotificationPreferenceRow,
      $$NotificationPreferenceRowsTableFilterComposer,
      $$NotificationPreferenceRowsTableOrderingComposer,
      $$NotificationPreferenceRowsTableAnnotationComposer,
      $$NotificationPreferenceRowsTableCreateCompanionBuilder,
      $$NotificationPreferenceRowsTableUpdateCompanionBuilder,
      (
        NotificationPreferenceRow,
        BaseReferences<
          _$AppDatabase,
          $NotificationPreferenceRowsTable,
          NotificationPreferenceRow
        >,
      ),
      NotificationPreferenceRow,
      PrefetchHooks Function()
    >;
typedef $$DeviceRegistrationRowsTableCreateCompanionBuilder =
    DeviceRegistrationRowsCompanion Function({
      required String deviceId,
      required String fcmToken,
      required String platform,
      Value<String> timezoneId,
      Value<bool> notificationsEnabled,
      Value<String?> appVersion,
      Value<DateTime> registeredAt,
      Value<DateTime> lastSeenAt,
      Value<int> rowid,
    });
typedef $$DeviceRegistrationRowsTableUpdateCompanionBuilder =
    DeviceRegistrationRowsCompanion Function({
      Value<String> deviceId,
      Value<String> fcmToken,
      Value<String> platform,
      Value<String> timezoneId,
      Value<bool> notificationsEnabled,
      Value<String?> appVersion,
      Value<DateTime> registeredAt,
      Value<DateTime> lastSeenAt,
      Value<int> rowid,
    });

class $$DeviceRegistrationRowsTableFilterComposer
    extends Composer<_$AppDatabase, $DeviceRegistrationRowsTable> {
  $$DeviceRegistrationRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fcmToken => $composableBuilder(
    column: $table.fcmToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezoneId => $composableBuilder(
    column: $table.timezoneId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get registeredAt => $composableBuilder(
    column: $table.registeredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeviceRegistrationRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $DeviceRegistrationRowsTable> {
  $$DeviceRegistrationRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fcmToken => $composableBuilder(
    column: $table.fcmToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezoneId => $composableBuilder(
    column: $table.timezoneId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get registeredAt => $composableBuilder(
    column: $table.registeredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeviceRegistrationRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeviceRegistrationRowsTable> {
  $$DeviceRegistrationRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get fcmToken =>
      $composableBuilder(column: $table.fcmToken, builder: (column) => column);

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<String> get timezoneId => $composableBuilder(
    column: $table.timezoneId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get registeredAt => $composableBuilder(
    column: $table.registeredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => column,
  );
}

class $$DeviceRegistrationRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeviceRegistrationRowsTable,
          DeviceRegistrationRow,
          $$DeviceRegistrationRowsTableFilterComposer,
          $$DeviceRegistrationRowsTableOrderingComposer,
          $$DeviceRegistrationRowsTableAnnotationComposer,
          $$DeviceRegistrationRowsTableCreateCompanionBuilder,
          $$DeviceRegistrationRowsTableUpdateCompanionBuilder,
          (
            DeviceRegistrationRow,
            BaseReferences<
              _$AppDatabase,
              $DeviceRegistrationRowsTable,
              DeviceRegistrationRow
            >,
          ),
          DeviceRegistrationRow,
          PrefetchHooks Function()
        > {
  $$DeviceRegistrationRowsTableTableManager(
    _$AppDatabase db,
    $DeviceRegistrationRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeviceRegistrationRowsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DeviceRegistrationRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DeviceRegistrationRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> deviceId = const Value.absent(),
                Value<String> fcmToken = const Value.absent(),
                Value<String> platform = const Value.absent(),
                Value<String> timezoneId = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<String?> appVersion = const Value.absent(),
                Value<DateTime> registeredAt = const Value.absent(),
                Value<DateTime> lastSeenAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeviceRegistrationRowsCompanion(
                deviceId: deviceId,
                fcmToken: fcmToken,
                platform: platform,
                timezoneId: timezoneId,
                notificationsEnabled: notificationsEnabled,
                appVersion: appVersion,
                registeredAt: registeredAt,
                lastSeenAt: lastSeenAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String deviceId,
                required String fcmToken,
                required String platform,
                Value<String> timezoneId = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<String?> appVersion = const Value.absent(),
                Value<DateTime> registeredAt = const Value.absent(),
                Value<DateTime> lastSeenAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeviceRegistrationRowsCompanion.insert(
                deviceId: deviceId,
                fcmToken: fcmToken,
                platform: platform,
                timezoneId: timezoneId,
                notificationsEnabled: notificationsEnabled,
                appVersion: appVersion,
                registeredAt: registeredAt,
                lastSeenAt: lastSeenAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeviceRegistrationRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeviceRegistrationRowsTable,
      DeviceRegistrationRow,
      $$DeviceRegistrationRowsTableFilterComposer,
      $$DeviceRegistrationRowsTableOrderingComposer,
      $$DeviceRegistrationRowsTableAnnotationComposer,
      $$DeviceRegistrationRowsTableCreateCompanionBuilder,
      $$DeviceRegistrationRowsTableUpdateCompanionBuilder,
      (
        DeviceRegistrationRow,
        BaseReferences<
          _$AppDatabase,
          $DeviceRegistrationRowsTable,
          DeviceRegistrationRow
        >,
      ),
      DeviceRegistrationRow,
      PrefetchHooks Function()
    >;
typedef $$ContentMetadataRowsTableCreateCompanionBuilder =
    ContentMetadataRowsCompanion Function({
      required String id,
      Value<String?> activeBundleVersion,
      Value<String?> previousBundleVersion,
      Value<String?> activeContentHash,
      Value<String> quarantinedVersionsJson,
      Value<DateTime?> lastUpdateCheckAt,
      Value<DateTime?> lastSuccessfulActivationAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$ContentMetadataRowsTableUpdateCompanionBuilder =
    ContentMetadataRowsCompanion Function({
      Value<String> id,
      Value<String?> activeBundleVersion,
      Value<String?> previousBundleVersion,
      Value<String?> activeContentHash,
      Value<String> quarantinedVersionsJson,
      Value<DateTime?> lastUpdateCheckAt,
      Value<DateTime?> lastSuccessfulActivationAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ContentMetadataRowsTableFilterComposer
    extends Composer<_$AppDatabase, $ContentMetadataRowsTable> {
  $$ContentMetadataRowsTableFilterComposer({
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

  ColumnFilters<String> get activeBundleVersion => $composableBuilder(
    column: $table.activeBundleVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get previousBundleVersion => $composableBuilder(
    column: $table.previousBundleVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeContentHash => $composableBuilder(
    column: $table.activeContentHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quarantinedVersionsJson => $composableBuilder(
    column: $table.quarantinedVersionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdateCheckAt => $composableBuilder(
    column: $table.lastUpdateCheckAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSuccessfulActivationAt => $composableBuilder(
    column: $table.lastSuccessfulActivationAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContentMetadataRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentMetadataRowsTable> {
  $$ContentMetadataRowsTableOrderingComposer({
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

  ColumnOrderings<String> get activeBundleVersion => $composableBuilder(
    column: $table.activeBundleVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get previousBundleVersion => $composableBuilder(
    column: $table.previousBundleVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeContentHash => $composableBuilder(
    column: $table.activeContentHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quarantinedVersionsJson => $composableBuilder(
    column: $table.quarantinedVersionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdateCheckAt => $composableBuilder(
    column: $table.lastUpdateCheckAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSuccessfulActivationAt =>
      $composableBuilder(
        column: $table.lastSuccessfulActivationAt,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentMetadataRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentMetadataRowsTable> {
  $$ContentMetadataRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get activeBundleVersion => $composableBuilder(
    column: $table.activeBundleVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get previousBundleVersion => $composableBuilder(
    column: $table.previousBundleVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activeContentHash => $composableBuilder(
    column: $table.activeContentHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get quarantinedVersionsJson => $composableBuilder(
    column: $table.quarantinedVersionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUpdateCheckAt => $composableBuilder(
    column: $table.lastUpdateCheckAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSuccessfulActivationAt =>
      $composableBuilder(
        column: $table.lastSuccessfulActivationAt,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ContentMetadataRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContentMetadataRowsTable,
          ContentMetadataRow,
          $$ContentMetadataRowsTableFilterComposer,
          $$ContentMetadataRowsTableOrderingComposer,
          $$ContentMetadataRowsTableAnnotationComposer,
          $$ContentMetadataRowsTableCreateCompanionBuilder,
          $$ContentMetadataRowsTableUpdateCompanionBuilder,
          (
            ContentMetadataRow,
            BaseReferences<
              _$AppDatabase,
              $ContentMetadataRowsTable,
              ContentMetadataRow
            >,
          ),
          ContentMetadataRow,
          PrefetchHooks Function()
        > {
  $$ContentMetadataRowsTableTableManager(
    _$AppDatabase db,
    $ContentMetadataRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentMetadataRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentMetadataRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ContentMetadataRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> activeBundleVersion = const Value.absent(),
                Value<String?> previousBundleVersion = const Value.absent(),
                Value<String?> activeContentHash = const Value.absent(),
                Value<String> quarantinedVersionsJson = const Value.absent(),
                Value<DateTime?> lastUpdateCheckAt = const Value.absent(),
                Value<DateTime?> lastSuccessfulActivationAt =
                    const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentMetadataRowsCompanion(
                id: id,
                activeBundleVersion: activeBundleVersion,
                previousBundleVersion: previousBundleVersion,
                activeContentHash: activeContentHash,
                quarantinedVersionsJson: quarantinedVersionsJson,
                lastUpdateCheckAt: lastUpdateCheckAt,
                lastSuccessfulActivationAt: lastSuccessfulActivationAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> activeBundleVersion = const Value.absent(),
                Value<String?> previousBundleVersion = const Value.absent(),
                Value<String?> activeContentHash = const Value.absent(),
                Value<String> quarantinedVersionsJson = const Value.absent(),
                Value<DateTime?> lastUpdateCheckAt = const Value.absent(),
                Value<DateTime?> lastSuccessfulActivationAt =
                    const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentMetadataRowsCompanion.insert(
                id: id,
                activeBundleVersion: activeBundleVersion,
                previousBundleVersion: previousBundleVersion,
                activeContentHash: activeContentHash,
                quarantinedVersionsJson: quarantinedVersionsJson,
                lastUpdateCheckAt: lastUpdateCheckAt,
                lastSuccessfulActivationAt: lastSuccessfulActivationAt,
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

typedef $$ContentMetadataRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContentMetadataRowsTable,
      ContentMetadataRow,
      $$ContentMetadataRowsTableFilterComposer,
      $$ContentMetadataRowsTableOrderingComposer,
      $$ContentMetadataRowsTableAnnotationComposer,
      $$ContentMetadataRowsTableCreateCompanionBuilder,
      $$ContentMetadataRowsTableUpdateCompanionBuilder,
      (
        ContentMetadataRow,
        BaseReferences<
          _$AppDatabase,
          $ContentMetadataRowsTable,
          ContentMetadataRow
        >,
      ),
      ContentMetadataRow,
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
  $$JourneyProgressRowsTableTableManager get journeyProgressRows =>
      $$JourneyProgressRowsTableTableManager(_db, _db.journeyProgressRows);
  $$PlayerFlagRowsTableTableManager get playerFlagRows =>
      $$PlayerFlagRowsTableTableManager(_db, _db.playerFlagRows);
  $$PlayerIdentityRowsTableTableManager get playerIdentityRows =>
      $$PlayerIdentityRowsTableTableManager(_db, _db.playerIdentityRows);
  $$SyncMetadataRowsTableTableManager get syncMetadataRows =>
      $$SyncMetadataRowsTableTableManager(_db, _db.syncMetadataRows);
  $$SyncOperationRowsTableTableManager get syncOperationRows =>
      $$SyncOperationRowsTableTableManager(_db, _db.syncOperationRows);
  $$WalletCacheRowsTableTableManager get walletCacheRows =>
      $$WalletCacheRowsTableTableManager(_db, _db.walletCacheRows);
  $$EconomyOperationRowsTableTableManager get economyOperationRows =>
      $$EconomyOperationRowsTableTableManager(_db, _db.economyOperationRows);
  $$EntitlementRowsTableTableManager get entitlementRows =>
      $$EntitlementRowsTableTableManager(_db, _db.entitlementRows);
  $$MonetizationStateRowsTableTableManager get monetizationStateRows =>
      $$MonetizationStateRowsTableTableManager(_db, _db.monetizationStateRows);
  $$RewardedAdReceiptRowsTableTableManager get rewardedAdReceiptRows =>
      $$RewardedAdReceiptRowsTableTableManager(_db, _db.rewardedAdReceiptRows);
  $$DailyStateCacheRowsTableTableManager get dailyStateCacheRows =>
      $$DailyStateCacheRowsTableTableManager(_db, _db.dailyStateCacheRows);
  $$DailyChallengeCacheRowsTableTableManager get dailyChallengeCacheRows =>
      $$DailyChallengeCacheRowsTableTableManager(
        _db,
        _db.dailyChallengeCacheRows,
      );
  $$NotificationPreferenceRowsTableTableManager
  get notificationPreferenceRows =>
      $$NotificationPreferenceRowsTableTableManager(
        _db,
        _db.notificationPreferenceRows,
      );
  $$DeviceRegistrationRowsTableTableManager get deviceRegistrationRows =>
      $$DeviceRegistrationRowsTableTableManager(
        _db,
        _db.deviceRegistrationRows,
      );
  $$ContentMetadataRowsTableTableManager get contentMetadataRows =>
      $$ContentMetadataRowsTableTableManager(_db, _db.contentMetadataRows);
}
