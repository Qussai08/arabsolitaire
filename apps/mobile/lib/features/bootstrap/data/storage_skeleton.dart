import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/app/bootstrap/bootstrap.dart';

/// Firebase Storage configuration boundary (Sprint 0).
///
/// Used later for content bundles and approved remote assets.
final class StorageSkeleton {
  StorageSkeleton(this._ref);

  final Ref _ref;

  FirebaseStorage? get _storageOrNull {
    try {
      return FirebaseStorage.instance;
    } catch (_) {
      return null;
    }
  }

  bool get isAvailable => _storageOrNull != null;

  void bind() {
    final logger = _ref.read(appLoggerProvider);
    if (_storageOrNull == null) {
      logger.info('Storage unavailable — local-only mode');
      return;
    }
    logger.info('Storage client bound');
  }
}

final storageSkeletonProvider = Provider<StorageSkeleton>(StorageSkeleton.new);
