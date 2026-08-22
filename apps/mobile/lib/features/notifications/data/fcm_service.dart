import 'package:mobile/features/notifications/domain/notification_models.dart';

/// Abstract FCM integration — decouples firebase_messaging from app logic.
abstract interface class FcmService {
  /// Request notification permission from the OS.
  Future<bool> requestPermission();

  /// Get current FCM token. Returns null if unavailable.
  Future<String?> getToken();

  /// Stream of token refreshes.
  Stream<String?> get onTokenRefresh;

  /// Subscribe to foreground messages for deep-link handling.
  Stream<FcmMessage> get onMessage;

  /// Initial message (app opened via notification while terminated).
  Future<FcmMessage?> getInitialMessage();
}

final class FcmMessage {
  const FcmMessage({
    required this.notificationType,
    this.dayKey,
    this.payload,
  });

  final NotificationType notificationType;
  final String? dayKey;
  final Map<String, String>? payload;
}

/// No-op stub — used until firebase_messaging is wired to platform.
final class NoOpFcmService implements FcmService {
  const NoOpFcmService();

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<String?> getToken() async => null;

  @override
  Stream<String?> get onTokenRefresh => const Stream.empty();

  @override
  Stream<FcmMessage> get onMessage => const Stream.empty();

  @override
  Future<FcmMessage?> getInitialMessage() async => null;
}
