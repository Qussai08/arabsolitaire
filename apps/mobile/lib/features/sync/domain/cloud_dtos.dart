/// Cloud DTOs for Firestore documents.
///
/// These are serialization-only types. Domain merge logic lives in
/// SyncMergePolicy. Do not use these in UI or game engine.
library;

// ── Progression ───────────────────────────────────────────────────────────────

final class CloudProgressionDto {
  const CloudProgressionDto({
    required this.schemaVersion,
    required this.contentVersion,
    required this.highestCompletedLevel,
    required this.revision,
    this.currentLevelId,
    this.updatedAt,
  });

  static const int currentSchema = 1;

  final int schemaVersion;
  final int contentVersion;
  final int highestCompletedLevel;
  final int revision;
  final String? currentLevelId;
  final DateTime? updatedAt;

  factory CloudProgressionDto.fromMap(Map<String, dynamic> map) {
    return CloudProgressionDto(
      schemaVersion: (map['schemaVersion'] as num?)?.toInt() ?? 0,
      contentVersion: (map['contentVersion'] as num?)?.toInt() ?? 0,
      highestCompletedLevel:
          (map['highestCompletedLevel'] as num?)?.toInt() ?? 0,
      revision: (map['revision'] as num?)?.toInt() ?? 0,
      currentLevelId: map['currentLevelId'] as String?,
      updatedAt: (map['updatedAt'] as DateTime?),
    );
  }

  Map<String, dynamic> toMap() => {
    'schemaVersion': schemaVersion,
    'contentVersion': contentVersion,
    'highestCompletedLevel': highestCompletedLevel,
    'revision': revision,
    if (currentLevelId != null) 'currentLevelId': currentLevelId,
  };

  bool get isSupported => schemaVersion <= currentSchema;
}

// ── Story Progress ─────────────────────────────────────────────────────────────

final class CloudStoryDto {
  const CloudStoryDto({
    required this.schemaVersion,
    required this.unlockedStoryBeatIds,
    required this.viewedStoryBeatIds,
    required this.revision,
    this.updatedAt,
  });

  static const int currentSchema = 1;

  final int schemaVersion;
  final List<String> unlockedStoryBeatIds;
  final List<String> viewedStoryBeatIds;
  final int revision;
  final DateTime? updatedAt;

  factory CloudStoryDto.fromMap(Map<String, dynamic> map) {
    List<String> parseList(dynamic v) =>
        (v as List<dynamic>?)?.cast<String>() ?? [];
    return CloudStoryDto(
      schemaVersion: (map['schemaVersion'] as num?)?.toInt() ?? 0,
      unlockedStoryBeatIds: parseList(map['unlockedStoryBeatIds']),
      viewedStoryBeatIds: parseList(map['viewedStoryBeatIds']),
      revision: (map['revision'] as num?)?.toInt() ?? 0,
      updatedAt: map['updatedAt'] as DateTime?,
    );
  }

  Map<String, dynamic> toMap() => {
    'schemaVersion': schemaVersion,
    'unlockedStoryBeatIds': unlockedStoryBeatIds,
    'viewedStoryBeatIds': viewedStoryBeatIds,
    'revision': revision,
  };

  bool get isSupported => schemaVersion <= currentSchema;
}

// ── Settings ──────────────────────────────────────────────────────────────────

final class CloudSettingsDto {
  const CloudSettingsDto({
    required this.schemaVersion,
    required this.soundEnabled,
    required this.musicEnabled,
    required this.hapticsEnabled,
    required this.language,
    required this.revision,
    this.updatedAt,
  });

  static const int currentSchema = 1;

  final int schemaVersion;
  final bool soundEnabled;
  final bool musicEnabled;
  final bool hapticsEnabled;
  final String language;
  final int revision;
  final DateTime? updatedAt;

  factory CloudSettingsDto.fromMap(Map<String, dynamic> map) {
    return CloudSettingsDto(
      schemaVersion: (map['schemaVersion'] as num?)?.toInt() ?? 0,
      soundEnabled: (map['soundEnabled'] as bool?) ?? true,
      musicEnabled: (map['musicEnabled'] as bool?) ?? true,
      hapticsEnabled: (map['hapticsEnabled'] as bool?) ?? true,
      language: (map['language'] as String?) ?? 'ar',
      revision: (map['revision'] as num?)?.toInt() ?? 0,
      updatedAt: map['updatedAt'] as DateTime?,
    );
  }

  Map<String, dynamic> toMap() => {
    'schemaVersion': schemaVersion,
    'soundEnabled': soundEnabled,
    'musicEnabled': musicEnabled,
    'hapticsEnabled': hapticsEnabled,
    'language': language,
    'revision': revision,
  };

  bool get isSupported => schemaVersion <= currentSchema;
}
