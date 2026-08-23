import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/features/account/data/auth_repository.dart';
import 'package:mobile/features/account/domain/auth_models.dart';

final class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._auth);
  final FirebaseAuth _auth;

  @override
  String? get currentUid => _auth.currentUser?.uid;

  @override
  Future<AuthState> currentState() async {
    final user = _auth.currentUser;
    if (user == null) return AuthState.offline;
    return _stateFromUser(user);
  }

  @override
  Future<AuthState> ensureAnonymousIdentity() async {
    try {
      final existing = _auth.currentUser;
      if (existing != null) return _stateFromUser(existing);
      final cred = await _auth.signInAnonymously();
      final user = cred.user;
      if (user == null) return AuthState.offline;
      return _stateFromUser(user);
    } catch (_) {
      return AuthState.offline;
    }
  }

  @override
  Future<LinkResult> linkGoogle() async {
    try {
      // Google Sign-In integration requires google_sign_in package on each
      // platform. The architecture is established here; platform integration
      // is completed when the package is wired in.
      //
      // Pattern:
      //   final googleSignIn = GoogleSignIn();
      //   final account = await googleSignIn.signIn();
      //   final googleAuth = await account?.authentication;
      //   final credential = GoogleAuthProvider.credential(
      //     accessToken: googleAuth?.accessToken,
      //     idToken: googleAuth?.idToken,
      //   );
      //   await _auth.currentUser?.linkWithCredential(credential);
      //
      // Return success on completion.
      throw UnimplementedError(
        'Google linking requires google_sign_in wiring; architecture ready',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        return LinkResult(type: LinkResultType.conflict, error: e.code);
      }
      if (e.code == 'provider-already-linked') {
        return LinkResult.alreadyLinked;
      }
      return LinkResult(type: LinkResultType.failed, error: e.code);
    } catch (e) {
      return LinkResult(type: LinkResultType.failed, error: e.toString());
    }
  }

  @override
  Future<LinkResult> linkApple() async {
    try {
      // Apple Sign-In uses apple_sign_in or sign_in_with_apple package.
      // Architecture stub — full wiring in platform integration step.
      throw UnimplementedError(
        'Apple linking requires sign_in_with_apple wiring; architecture ready',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        return LinkResult(type: LinkResultType.conflict, error: e.code);
      }
      if (e.code == 'provider-already-linked') {
        return LinkResult.alreadyLinked;
      }
      return LinkResult(type: LinkResultType.failed, error: e.code);
    } catch (e) {
      return LinkResult(type: LinkResultType.failed, error: e.toString());
    }
  }

  @override
  Stream<AuthState> watchAuthState() => _auth.authStateChanges().map((user) {
    if (user == null) return AuthState.offline;
    return _stateFromUser(user);
  });

  static AuthState _stateFromUser(User user) {
    final providers = user.providerData.map((p) => p.providerId).toList();
    final isAnonymous = user.isAnonymous;
    return AuthState(
      type: isAnonymous
          ? AuthStateType.anonymousAuthenticated
          : AuthStateType.linkedAuthenticated,
      firebaseUid: user.uid,
      linkedProviders: providers,
    );
  }
}

/// Offline-only stub used when Firebase is unavailable.
final class OfflineAuthRepository implements AuthRepository {
  const OfflineAuthRepository();

  @override
  String? get currentUid => null;

  @override
  Future<AuthState> currentState() async => AuthState.offline;

  @override
  Future<AuthState> ensureAnonymousIdentity() async => AuthState.offline;

  @override
  Future<LinkResult> linkApple() async =>
      const LinkResult(type: LinkResultType.failed, error: 'offline');

  @override
  Future<LinkResult> linkGoogle() async =>
      const LinkResult(type: LinkResultType.failed, error: 'offline');

  @override
  Stream<AuthState> watchAuthState() => const Stream.empty();
}
