// Sprint 10 — ContentManager orchestrates the full content pipeline.
//
// Startup flow:
//   1. Load bundled fallback content.
//   2. Load last-known-valid remote bundle (if stored locally).
//   3. Expose current snapshot.
//   4. Background: check remote pointer, download, validate, stage.
//   5. Activate at safe boundary (not during active gameplay).
//
// Safety invariants:
//   - Never activate unvalidated content.
//   - Never overwrite active immutable bundle files in place.
//   - Retain bundled fallback + last-known-valid at all times.
//   - Rollback to previous on verified content-loading failure.

import 'dart:async';
import '../data/bundled_content_repository.dart';
import '../data/content_validator.dart';
import '../data/local_bundle_store.dart';
import '../data/remote_content_repository.dart';
import '../domain/content_bundle.dart';

enum ContentManagerState {
  usingBundled,
  usingLocalRemoteBundle,
  checkingForUpdate,
  downloading,
  validating,
  activating,
  updateFailed,
  rollbackPerformed,
}

class ContentManager {
  ContentManager({
    required BundledContentRepository bundledRepo,
    required RemoteContentRepository remoteRepo,
    required LocalBundleStore store,
    ContentValidator? validator,
    // ignore: prefer_initializing_formals
  }) : _validator = validator ?? const ContentValidator(),
       _bundledRepo = bundledRepo, // ignore: prefer_initializing_formals
       _remoteRepo = remoteRepo, // ignore: prefer_initializing_formals
       _store = store; // ignore: prefer_initializing_formals

  final BundledContentRepository _bundledRepo;
  final RemoteContentRepository _remoteRepo;
  final LocalBundleStore _store;
  final ContentValidator _validator;

  ContentSnapshot? _current;
  DisableMetadata _disableMetadata = DisableMetadata.empty;
  ContentManagerState _state = ContentManagerState.usingBundled;
  // Whether it is safe to activate a staged bundle (not mid-gameplay).
  bool _activationSafe = true;
  bool _hasStagedCandidate = false;

  ContentSnapshot get current {
    final c = _current;
    if (c == null) throw StateError('ContentManager not initialised');
    return c;
  }

  DisableMetadata get disableMetadata => _disableMetadata;
  ContentManagerState get state => _state;

  // ── Initialisation ────────────────────────────────────────────────────────

  Future<void> loadInitialContent() async {
    // 1. Always load bundled content first — never fail.
    final bundled = await _bundledRepo.load();
    _current = bundled;
    _state = ContentManagerState.usingBundled;

    // 2. Try to load last-known-valid remote bundle from local store.
    await _tryLoadLocalRemoteBundle();

    // 3. Load cached disable metadata (non-blocking).
    await _refreshDisableMetadata(remote: false);
  }

  Future<void> _tryLoadLocalRemoteBundle() async {
    try {
      final manifest = await _store.loadActiveManifest();
      if (manifest == null) return;

      final filePaths = manifest.files.map((f) => f.path).toList();
      final fileBytes = await _store.loadActiveFiles(filePaths);
      if (fileBytes.length != manifest.files.length) return;

      // Validate schema/rules before using stored bundle
      final schemaIssue = _validator.checkSchemaVersion(manifest);
      if (schemaIssue != null && schemaIssue.isBlocking) return;
      final rulesIssue = _validator.checkRulesVersion(manifest);
      if (rulesIssue != null && rulesIssue.isBlocking) return;

      final meta = await _store.loadMetadata();
      if (meta.quarantinedVersions.contains(manifest.bundleVersion)) {
        return; // quarantined — do not use
      }

      final snapshot = ContentValidator.parseBundle(
        manifest: manifest,
        fileBytes: fileBytes,
      );
      _current = snapshot;
      _state = ContentManagerState.usingLocalRemoteBundle;
    } catch (_) {
      // Bundled fallback remains active
    }
  }

  // ── Remote update check ───────────────────────────────────────────────────

  Future<ContentUpdateResult> checkForUpdate() async {
    _state = ContentManagerState.checkingForUpdate;
    await _store.recordUpdateCheck();

    try {
      final pointer = await _remoteRepo.fetchActivePointer();
      if (pointer == null) {
        _state = ContentManagerState.updateFailed;
        return ContentUpdateFailed(
          ContentUpdateFailureReason.manifestUnavailable,
        );
      }

      // Check if bundle is disabled
      if (pointer.disabledBundleVersions.contains(
        pointer.activeBundleVersion,
      )) {
        _state = ContentManagerState.updateFailed;
        return ContentUpdateFailed(ContentUpdateFailureReason.bundleDisabled);
      }

      // Already running latest?
      if (_current?.bundleVersion == pointer.activeBundleVersion) {
        _state = current.source == ContentSource.bundled
            ? ContentManagerState.usingBundled
            : ContentManagerState.usingLocalRemoteBundle;
        return ContentUpToDate();
      }

      // Check quarantine
      final meta = await _store.loadMetadata();
      if (meta.quarantinedVersions.contains(pointer.activeBundleVersion)) {
        _state = ContentManagerState.updateFailed;
        return ContentUpdateFailed(ContentUpdateFailureReason.bundleDisabled);
      }

      return await _downloadAndStage(pointer.activeBundleVersion);
    } catch (e) {
      _state = ContentManagerState.updateFailed;
      return ContentUpdateFailed(
        ContentUpdateFailureReason.downloadFailed,
        error: e,
      );
    }
  }

  Future<ContentUpdateResult> _downloadAndStage(String bundleVersion) async {
    _state = ContentManagerState.downloading;

    // Fetch manifest
    final manifest = await _remoteRepo.fetchManifest(bundleVersion);
    if (manifest == null) {
      _state = ContentManagerState.updateFailed;
      return ContentUpdateFailed(
        ContentUpdateFailureReason.manifestUnavailable,
      );
    }

    // Download files
    final fileBytes = await _remoteRepo.downloadBundleFiles(
      bundleVersion,
      manifest.files,
    );

    _state = ContentManagerState.validating;

    // Parse snapshot before validation (needed by validateRemoteBundle)
    late ContentSnapshot candidate;
    try {
      candidate = ContentValidator.parseBundle(
        manifest: manifest,
        fileBytes: fileBytes,
      );
    } catch (e) {
      _state = ContentManagerState.updateFailed;
      await _store.addQuarantinedVersion(bundleVersion);
      return ContentUpdateFailed(
        ContentUpdateFailureReason.schemaInvalid,
        error: e,
      );
    }

    // Full validation
    final report = await _validator.validateRemoteBundle(
      manifest: manifest,
      fileBytes: fileBytes,
      parsedSnapshot: candidate,
    );

    if (!report.isValid) {
      _state = ContentManagerState.updateFailed;
      await _store.addQuarantinedVersion(bundleVersion);

      // Determine the most specific failure reason
      final firstError = report.errors.firstOrNull;
      final reason = _mapErrorCode(firstError?.code);
      return ContentUpdateFailed(reason);
    }

    // Write to staged (not yet active)
    await _store.writeStaged(manifest: manifest, fileBytes: fileBytes);
    _hasStagedCandidate = true;

    // Activate immediately if safe
    if (_activationSafe) {
      return await activateStaged();
    }

    // Otherwise, caller activates at safe boundary
    _state = ContentManagerState.usingLocalRemoteBundle;
    return ContentUpdated(bundleVersion);
  }

  // ── Atomic activation ─────────────────────────────────────────────────────

  Future<ContentUpdateResult> activateStaged() async {
    if (!_hasStagedCandidate) return ContentUpToDate();
    _state = ContentManagerState.activating;

    try {
      // Activate staged files; manifest read is done after reload
      final success = await _store.atomicActivate(
        _current?.bundleVersion ?? 'unknown',
        _current?.contentHash ?? '',
      );

      if (!success) {
        _state = ContentManagerState.updateFailed;
        return ContentUpdateFailed(ContentUpdateFailureReason.activationFailed);
      }

      // Reload from new active
      await _tryLoadLocalRemoteBundle();
      _hasStagedCandidate = false;

      final newVersion = _current?.bundleVersion ?? 'unknown';
      _state = ContentManagerState.usingLocalRemoteBundle;
      return ContentUpdated(newVersion);
    } catch (e) {
      _state = ContentManagerState.updateFailed;
      return ContentUpdateFailed(
        ContentUpdateFailureReason.activationFailed,
        error: e,
      );
    }
  }

  // ── Rollback ──────────────────────────────────────────────────────────────

  Future<ContentUpdateResult> rollback() async {
    final success = await _store.rollbackToPrevious();
    if (!success) {
      return ContentUpdateFailed(ContentUpdateFailureReason.activationFailed);
    }
    await _tryLoadLocalRemoteBundle();
    final version = _current?.bundleVersion ?? 'unknown';
    _state = ContentManagerState.rollbackPerformed;
    return ContentRolledBack(version);
  }

  // ── Safe activation boundary ──────────────────────────────────────────────

  void markActivationSafe() {
    _activationSafe = true;
    // If a staged candidate is waiting, activate now
    if (_hasStagedCandidate) {
      unawaited(activateStaged());
    }
  }

  void markActivationUnsafe() {
    _activationSafe = false;
  }

  // ── Disable metadata ──────────────────────────────────────────────────────

  Future<void> _refreshDisableMetadata({bool remote = true}) async {
    if (remote) {
      try {
        final fresh = await _remoteRepo.fetchDisableMetadata();
        if (fresh != null) {
          _disableMetadata = fresh;
          await _store.saveDisableMetadata(fresh);
          return;
        }
      } catch (_) {}
    }

    // Fall back to cached
    final cached = await _store.loadCachedDisableMetadata();
    if (cached != null) {
      _disableMetadata = cached;
    }
  }

  Future<void> refreshDisableMetadata() =>
      _refreshDisableMetadata(remote: true);

  // ── Helpers ───────────────────────────────────────────────────────────────

  ContentUpdateFailureReason _mapErrorCode(String? code) {
    switch (code) {
      case 'HASH_MISMATCH':
        return ContentUpdateFailureReason.hashMismatch;
      case 'UNSUPPORTED_SCHEMA_VERSION':
        return ContentUpdateFailureReason.schemaInvalid;
      case 'UNSUPPORTED_RULES_VERSION':
        return ContentUpdateFailureReason.rulesIncompatible;
      case 'MISSING_FILE':
        return ContentUpdateFailureReason.referenceInvalid;
      default:
        return ContentUpdateFailureReason.schemaInvalid;
    }
  }
}

void unawaited(Future<dynamic> future) {
  future.ignore();
}
