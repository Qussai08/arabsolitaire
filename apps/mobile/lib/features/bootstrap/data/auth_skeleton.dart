import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/app/bootstrap/bootstrap.dart';

/// Auth boundary for Sprint 0 — Anonymous-first direction, no account UX yet.
final class AuthSkeleton {
  AuthSkeleton(this._ref);

  final Ref _ref;

  FirebaseAuth? get _authOrNull {
    try {
      return FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }

  /// Returns current UID when Auth is available; null offline/unconfigured.
  String? get currentUserId {
    return _authOrNull?.currentUser?.uid;
  }

  Future<String?> ensureAnonymousSession() async {
    final logger = _ref.read(appLoggerProvider);
    final auth = _authOrNull;
    if (auth == null) {
      logger.info('Auth unavailable — skipping anonymous session');
      return null;
    }

    try {
      final existing = auth.currentUser;
      if (existing != null) {
        return existing.uid;
      }
      final credential = await auth.signInAnonymously();
      return credential.user?.uid;
    } catch (error, stackTrace) {
      logger.warning(
        'Anonymous auth failed',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}

final authSkeletonProvider = Provider<AuthSkeleton>(AuthSkeleton.new);
