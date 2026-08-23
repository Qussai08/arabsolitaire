// Sprint 10 — Riverpod providers for the content pipeline.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/content_manager.dart';
import '../data/bundled_content_repository.dart';
import '../data/content_validator.dart';
import '../data/local_bundle_store.dart';
import '../data/remote_content_repository.dart';
import '../domain/content_bundle.dart';

// ── Infrastructure providers ──────────────────────────────────────────────────

final bundledContentRepositoryProvider = Provider<BundledContentRepository>(
  (_) => BundledContentRepository(),
);

final localBundleStoreProvider = Provider<LocalBundleStore>(
  (_) => LocalBundleStore(),
);

final remoteContentRepositoryProvider = Provider<RemoteContentRepository>(
  (_) => RemoteContentRepository(),
);

final contentValidatorProvider = Provider<ContentValidator>(
  (_) => const ContentValidator(),
);

// ── ContentManager ────────────────────────────────────────────────────────────

final contentManagerProvider = Provider<ContentManager>(
  (ref) => ContentManager(
    bundledRepo: ref.watch(bundledContentRepositoryProvider),
    remoteRepo: ref.watch(remoteContentRepositoryProvider),
    store: ref.watch(localBundleStoreProvider),
    validator: ref.watch(contentValidatorProvider),
  ),
);

// ── Initialised content snapshot ─────────────────────────────────────────────

/// Loads and exposes the initial content snapshot. Completes before the
/// home screen is shown so Journey/Story use typed content immediately.
final contentSnapshotProvider = FutureProvider<ContentSnapshot>((ref) async {
  final manager = ref.watch(contentManagerProvider);
  await manager.loadInitialContent();
  return manager.current;
});

// ── Disable metadata ──────────────────────────────────────────────────────────

final disableMetadataProvider = Provider<DisableMetadata>((ref) {
  // Will return empty until contentSnapshotProvider completes
  final manager = ref.watch(contentManagerProvider);
  return manager.disableMetadata;
});

// ── Content manager state ─────────────────────────────────────────────────────

final contentManagerStateProvider = Provider<ContentManagerState>((ref) {
  final manager = ref.watch(contentManagerProvider);
  return manager.state;
});
