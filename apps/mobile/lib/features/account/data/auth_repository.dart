import 'package:mobile/features/account/domain/auth_models.dart';

abstract interface class AuthRepository {
  /// Returns current auth state.
  Future<AuthState> currentState();

  /// Ensures an anonymous identity (or reuses existing).
  Future<AuthState> ensureAnonymousIdentity();

  /// Links the current anonymous user to a Google provider.
  Future<LinkResult> linkGoogle();

  /// Links the current anonymous user to an Apple provider.
  Future<LinkResult> linkApple();

  /// Watches real-time auth state changes.
  Stream<AuthState> watchAuthState();

  /// Returns currently stored Firebase UID if available.
  String? get currentUid;
}
