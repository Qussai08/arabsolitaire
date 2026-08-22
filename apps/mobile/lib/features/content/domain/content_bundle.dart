// Sprint 10 — Content bundle domain models.
// Versioned bundle schema + manifest, content snapshot, and disable metadata.

// ── Supported versions ────────────────────────────────────────────────────────

/// Current schema version this client understands.
const int kSupportedSchemaVersion = 1;

/// Current Game Engine rules version this client understands.
const int kSupportedRulesVersion = 1;

// ── Manifest ──────────────────────────────────────────────────────────────────

class BundleFileEntry {
  const BundleFileEntry({
    required this.path,
    required this.sha256,
    required this.size,
  });

  final String path;
  final String sha256;
  final int size;

  bool get isTrusted => sha256 == 'trusted';

  factory BundleFileEntry.fromJson(Map<String, dynamic> j) => BundleFileEntry(
        path: j['path'] as String,
        sha256: j['sha256'] as String,
        size: (j['size'] as num).toInt(),
      );

  Map<String, dynamic> toJson() => {
        'path': path,
        'sha256': sha256,
        'size': size,
      };
}

class BundleManifest {
  const BundleManifest({
    required this.bundleId,
    required this.bundleVersion,
    required this.schemaVersion,
    required this.rulesVersion,
    required this.createdAt,
    required this.publishedAt,
    required this.contentHash,
    required this.files,
    required this.contentTypes,
    required this.status,
    this.bundleBuilderVersion,
    this.contentValidatorVersion,
    this.minimumAppVersion,
    this.maximumAppVersion,
    this.source,
  });

  final String bundleId;
  final String bundleVersion;
  final int schemaVersion;
  final int rulesVersion;
  final String createdAt;
  final String publishedAt;
  final String contentHash;
  final List<BundleFileEntry> files;
  final List<String> contentTypes;
  final String status;
  final String? bundleBuilderVersion;
  final String? contentValidatorVersion;
  final String? minimumAppVersion;
  final String? maximumAppVersion;
  final String? source;

  bool get isBundledFallback => source == 'bundled';

  factory BundleManifest.fromJson(Map<String, dynamic> j) => BundleManifest(
        bundleId: j['bundleId'] as String,
        bundleVersion: j['bundleVersion'] as String,
        schemaVersion: (j['schemaVersion'] as num).toInt(),
        rulesVersion: (j['rulesVersion'] as num).toInt(),
        createdAt: j['createdAt'] as String,
        publishedAt: j['publishedAt'] as String,
        contentHash: j['contentHash'] as String,
        files: (j['files'] as List<dynamic>)
            .map((e) => BundleFileEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
        contentTypes: (j['contentTypes'] as List<dynamic>).cast<String>(),
        status: j['status'] as String,
        bundleBuilderVersion: j['bundleBuilderVersion'] as String?,
        contentValidatorVersion: j['contentValidatorVersion'] as String?,
        minimumAppVersion: j['minimumAppVersion'] as String?,
        maximumAppVersion: j['maximumAppVersion'] as String?,
        source: j['source'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'bundleId': bundleId,
        'bundleVersion': bundleVersion,
        'schemaVersion': schemaVersion,
        'rulesVersion': rulesVersion,
        'createdAt': createdAt,
        'publishedAt': publishedAt,
        'contentHash': contentHash,
        'files': files.map((f) => f.toJson()).toList(),
        'contentTypes': contentTypes,
        'status': status,
        if (bundleBuilderVersion != null) 'bundleBuilderVersion': bundleBuilderVersion,
        if (contentValidatorVersion != null) 'contentValidatorVersion': contentValidatorVersion,
        if (minimumAppVersion != null) 'minimumAppVersion': minimumAppVersion,
        if (maximumAppVersion != null) 'maximumAppVersion': maximumAppVersion,
        if (source != null) 'source': source,
      };
}

// ── Remote control pointer ─────────────────────────────────────────────────────

class RemoteContentPointer {
  const RemoteContentPointer({
    required this.activeBundleVersion,
    required this.bundlePath,
    required this.updatedAt,
    this.minimumRequiredBundle,
    this.disabledBundleVersions = const [],
  });

  final String activeBundleVersion;
  final String bundlePath;
  final String updatedAt;
  final String? minimumRequiredBundle;
  final List<String> disabledBundleVersions;

  factory RemoteContentPointer.fromJson(Map<String, dynamic> j) =>
      RemoteContentPointer(
        activeBundleVersion: j['activeBundleVersion'] as String,
        bundlePath: j['bundlePath'] as String,
        updatedAt: j['updatedAt'] as String,
        minimumRequiredBundle: j['minimumRequiredBundle'] as String?,
        disabledBundleVersions:
            ((j['disabledBundleVersions'] as List<dynamic>?) ?? <dynamic>[])
                .cast<String>(),
      );
}

// ── Typed content DTOs ────────────────────────────────────────────────────────

class ChapterDto {
  const ChapterDto({
    required this.chapterId,
    required this.order,
    required this.nameAr,
    required this.nameEn,
    required this.cityAr,
    required this.cityEn,
    required this.levelCount,
    required this.unlockLevel,
    this.enabled = true,
  });

  final String chapterId;
  final int order;
  final String nameAr;
  final String nameEn;
  final String cityAr;
  final String cityEn;
  final int levelCount;
  final int unlockLevel;
  final bool enabled;

  factory ChapterDto.fromJson(Map<String, dynamic> j) => ChapterDto(
        chapterId: j['chapterId'] as String,
        order: (j['order'] as num).toInt(),
        nameAr: j['nameAr'] as String,
        nameEn: j['nameEn'] as String,
        cityAr: j['cityAr'] as String,
        cityEn: j['cityEn'] as String,
        levelCount: (j['levelCount'] as num).toInt(),
        unlockLevel: (j['unlockLevel'] as num).toInt(),
        enabled: (j['enabled'] as bool?) ?? true,
      );
}

class LevelDto {
  const LevelDto({
    required this.levelDefinitionId,
    required this.chapterId,
    required this.globalLevelNumber,
    required this.chapterLevelNumber,
    required this.waveIndex,
    required this.wavePosition,
    required this.levelConfigurationRef,
    required this.boardDifficultyTarget,
    required this.semanticDifficultyTier,
    required this.contentSelectionMode,
    this.storyMilestoneRef,
    this.enabled = true,
  });

  final String levelDefinitionId;
  final String chapterId;
  final int globalLevelNumber;
  final int chapterLevelNumber;
  final int waveIndex;
  final int wavePosition;
  final String levelConfigurationRef;
  final double boardDifficultyTarget;
  final int semanticDifficultyTier;
  final String contentSelectionMode;
  final String? storyMilestoneRef;
  final bool enabled;

  factory LevelDto.fromJson(Map<String, dynamic> j) => LevelDto(
        levelDefinitionId: j['levelDefinitionId'] as String,
        chapterId: j['chapterId'] as String,
        globalLevelNumber: (j['globalLevelNumber'] as num).toInt(),
        chapterLevelNumber: (j['chapterLevelNumber'] as num).toInt(),
        waveIndex: (j['waveIndex'] as num).toInt(),
        wavePosition: (j['wavePosition'] as num).toInt(),
        levelConfigurationRef: j['levelConfigurationRef'] as String,
        boardDifficultyTarget:
            (j['boardDifficultyTarget'] as num).toDouble(),
        semanticDifficultyTier:
            (j['semanticDifficultyTier'] as num).toInt(),
        contentSelectionMode: j['contentSelectionMode'] as String,
        storyMilestoneRef: j['storyMilestoneRef'] as String?,
        enabled: (j['enabled'] as bool?) ?? true,
      );
}

class AssociationVariantDto {
  const AssociationVariantDto({
    required this.associationVariantId,
    required this.associationId,
    required this.associationClue,
    required this.memberCards,
    required this.contentType,
    required this.semanticDifficulty,
    required this.visualFlag,
    required this.chapterEligibility,
    required this.status,
    required this.arabicReviewState,
    required this.semanticReviewState,
    this.approvedBy,
    this.version = 1,
  });

  final String associationVariantId;
  final String associationId;
  final String associationClue;
  final List<String> memberCards;
  final String contentType;
  final int semanticDifficulty;
  final bool visualFlag;
  final List<String> chapterEligibility;
  final String status;
  final String arabicReviewState;
  final String semanticReviewState;
  final String? approvedBy;
  final int version;

  bool get isPublished => status == 'published';
  bool get isApproved =>
      arabicReviewState == 'approved' && semanticReviewState == 'approved';

  factory AssociationVariantDto.fromJson(Map<String, dynamic> j) =>
      AssociationVariantDto(
        associationVariantId: j['associationVariantId'] as String,
        associationId: j['associationId'] as String,
        associationClue: j['associationClue'] as String,
        memberCards:
            (j['memberCards'] as List<dynamic>).cast<String>(),
        contentType: j['contentType'] as String,
        semanticDifficulty: (j['semanticDifficulty'] as num).toInt(),
        visualFlag: (j['visualFlag'] as bool?) ?? false,
        chapterEligibility:
            (j['chapterEligibility'] as List<dynamic>).cast<String>(),
        status: j['status'] as String,
        arabicReviewState: j['arabicReviewState'] as String,
        semanticReviewState: j['semanticReviewState'] as String,
        approvedBy: j['approvedBy'] as String?,
        version: (j['version'] as num?)?.toInt() ?? 1,
      );
}

class DialogueLineDto {
  const DialogueLineDto({
    required this.speaker,
    required this.textAr,
    this.emotion,
  });

  final String speaker;
  final String textAr;
  final String? emotion;

  factory DialogueLineDto.fromJson(Map<String, dynamic> j) => DialogueLineDto(
        speaker: j['speaker'] as String,
        textAr: j['textAr'] as String,
        emotion: j['emotion'] as String?,
      );
}

class StoryBeatDto {
  const StoryBeatDto({
    required this.storyBeatId,
    required this.chapterId,
    required this.beatType,
    required this.triggerLevel,
    required this.dialogueLines,
    required this.skippable,
    required this.status,
    required this.canonVersion,
  });

  final String storyBeatId;
  final String chapterId;
  final String beatType;
  final int triggerLevel;
  final List<DialogueLineDto> dialogueLines;
  final bool skippable;
  final String status;
  final int canonVersion;

  factory StoryBeatDto.fromJson(Map<String, dynamic> j) => StoryBeatDto(
        storyBeatId: j['storyBeatId'] as String,
        chapterId: j['chapterId'] as String,
        beatType: j['beatType'] as String,
        triggerLevel: (j['triggerLevel'] as num).toInt(),
        dialogueLines: (j['dialogueLines'] as List<dynamic>)
            .map((e) => DialogueLineDto.fromJson(e as Map<String, dynamic>))
            .toList(),
        skippable: (j['skippable'] as bool?) ?? true,
        status: j['status'] as String,
        canonVersion: (j['canonVersion'] as num).toInt(),
      );
}

// ── Content snapshot ──────────────────────────────────────────────────────────

enum ContentSource { bundled, localRemote }

class ContentSnapshot {
  const ContentSnapshot({
    required this.manifest,
    required this.chapters,
    required this.levels,
    required this.associations,
    required this.storyBeats,
    required this.localization,
    required this.source,
  });

  final BundleManifest manifest;
  final List<ChapterDto> chapters;
  final List<LevelDto> levels;
  final List<AssociationVariantDto> associations;
  final List<StoryBeatDto> storyBeats;
  final Map<String, String> localization;
  final ContentSource source;

  String get bundleVersion => manifest.bundleVersion;
  int get schemaVersion => manifest.schemaVersion;
  int get rulesVersion => manifest.rulesVersion;
  String get contentHash => manifest.contentHash;
}

// ── Disable metadata ──────────────────────────────────────────────────────────

class DisableMetadata {
  const DisableMetadata({
    this.disabledBundleVersions = const [],
    this.disabledLevelIds = const [],
    this.disabledAssociationVariantIds = const [],
    this.disabledStoryBeatIds = const [],
    this.fetchedAt,
  });

  final List<String> disabledBundleVersions;
  final List<String> disabledLevelIds;
  final List<String> disabledAssociationVariantIds;
  final List<String> disabledStoryBeatIds;
  final DateTime? fetchedAt;

  bool isLevelDisabled(String levelId) =>
      disabledLevelIds.contains(levelId);

  bool isVariantDisabled(String variantId) =>
      disabledAssociationVariantIds.contains(variantId);

  bool isStoryBeatDisabled(String beatId) =>
      disabledStoryBeatIds.contains(beatId);

  bool isBundleDisabled(String version) =>
      disabledBundleVersions.contains(version);

  static const empty = DisableMetadata();

  factory DisableMetadata.fromJson(Map<String, dynamic> j) => DisableMetadata(
        disabledBundleVersions:
            ((j['disabledBundleVersions'] as List<dynamic>?) ?? [])
                .cast<String>(),
        disabledLevelIds:
            ((j['disabledLevelIds'] as List<dynamic>?) ?? []).cast<String>(),
        disabledAssociationVariantIds:
            ((j['disabledAssociationVariantIds'] as List<dynamic>?) ?? [])
                .cast<String>(),
        disabledStoryBeatIds:
            ((j['disabledStoryBeatIds'] as List<dynamic>?) ?? [])
                .cast<String>(),
        fetchedAt: j['fetchedAt'] != null
            ? DateTime.tryParse(j['fetchedAt'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'disabledBundleVersions': disabledBundleVersions,
        'disabledLevelIds': disabledLevelIds,
        'disabledAssociationVariantIds': disabledAssociationVariantIds,
        'disabledStoryBeatIds': disabledStoryBeatIds,
        if (fetchedAt != null) 'fetchedAt': fetchedAt!.toIso8601String(),
      };
}

// ── Validation ────────────────────────────────────────────────────────────────

enum ValidationSeverity { error, warning, info }

class ValidationIssue {
  const ValidationIssue({
    required this.severity,
    required this.code,
    required this.message,
    this.affectedId,
  });

  final ValidationSeverity severity;
  final String code;
  final String message;
  final String? affectedId;

  bool get isBlocking => severity == ValidationSeverity.error;
}

class ValidationReport {
  const ValidationReport({
    required this.isValid,
    required this.issues,
    required this.bundleVersion,
    this.durationMs,
    this.validatedCounts,
  });

  final bool isValid;
  final List<ValidationIssue> issues;
  final String bundleVersion;
  final int? durationMs;
  final Map<String, int>? validatedCounts;

  List<ValidationIssue> get errors =>
      issues.where((i) => i.severity == ValidationSeverity.error).toList();

  List<ValidationIssue> get warnings =>
      issues.where((i) => i.severity == ValidationSeverity.warning).toList();
}

// ── Content update result ─────────────────────────────────────────────────────

sealed class ContentUpdateResult {}

class ContentUpToDate extends ContentUpdateResult {}

class ContentUpdated extends ContentUpdateResult {
  ContentUpdated(this.newVersion);
  final String newVersion;
}

class ContentUpdateFailed extends ContentUpdateResult {
  ContentUpdateFailed(this.reason, {this.error});
  final ContentUpdateFailureReason reason;
  final Object? error;
}

class ContentRolledBack extends ContentUpdateResult {
  ContentRolledBack(this.toVersion);
  final String toVersion;
}

enum ContentUpdateFailureReason {
  manifestUnavailable,
  downloadFailed,
  hashMismatch,
  schemaInvalid,
  rulesIncompatible,
  appVersionIncompatible,
  referenceInvalid,
  activationFailed,
  bundleDisabled,
}

// ── Local metadata ────────────────────────────────────────────────────────────

class LocalContentMetadata {
  const LocalContentMetadata({
    this.activeBundleVersion,
    this.previousBundleVersion,
    this.lastUpdateCheckAt,
    this.lastSuccessfulActivationAt,
    this.activeContentHash,
    this.quarantinedVersions = const [],
  });

  final String? activeBundleVersion;
  final String? previousBundleVersion;
  final DateTime? lastUpdateCheckAt;
  final DateTime? lastSuccessfulActivationAt;
  final String? activeContentHash;
  final List<String> quarantinedVersions;

  factory LocalContentMetadata.fromJson(Map<String, dynamic> j) =>
      LocalContentMetadata(
        activeBundleVersion: j['activeBundleVersion'] as String?,
        previousBundleVersion: j['previousBundleVersion'] as String?,
        lastUpdateCheckAt: j['lastUpdateCheckAt'] != null
            ? DateTime.tryParse(j['lastUpdateCheckAt'] as String)
            : null,
        lastSuccessfulActivationAt:
            j['lastSuccessfulActivationAt'] != null
                ? DateTime.tryParse(
                    j['lastSuccessfulActivationAt'] as String)
                : null,
        activeContentHash: j['activeContentHash'] as String?,
        quarantinedVersions:
            ((j['quarantinedVersions'] as List<dynamic>?) ?? [])
                .cast<String>(),
      );

  Map<String, dynamic> toJson() => {
        if (activeBundleVersion != null)
          'activeBundleVersion': activeBundleVersion,
        if (previousBundleVersion != null)
          'previousBundleVersion': previousBundleVersion,
        if (lastUpdateCheckAt != null)
          'lastUpdateCheckAt': lastUpdateCheckAt!.toIso8601String(),
        if (lastSuccessfulActivationAt != null)
          'lastSuccessfulActivationAt':
              lastSuccessfulActivationAt!.toIso8601String(),
        if (activeContentHash != null)
          'activeContentHash': activeContentHash,
        'quarantinedVersions': quarantinedVersions,
      };

  LocalContentMetadata copyWith({
    String? activeBundleVersion,
    String? previousBundleVersion,
    DateTime? lastUpdateCheckAt,
    DateTime? lastSuccessfulActivationAt,
    String? activeContentHash,
    List<String>? quarantinedVersions,
  }) =>
      LocalContentMetadata(
        activeBundleVersion:
            activeBundleVersion ?? this.activeBundleVersion,
        previousBundleVersion:
            previousBundleVersion ?? this.previousBundleVersion,
        lastUpdateCheckAt:
            lastUpdateCheckAt ?? this.lastUpdateCheckAt,
        lastSuccessfulActivationAt:
            lastSuccessfulActivationAt ?? this.lastSuccessfulActivationAt,
        activeContentHash:
            activeContentHash ?? this.activeContentHash,
        quarantinedVersions:
            quarantinedVersions ?? this.quarantinedVersions,
      );
}
