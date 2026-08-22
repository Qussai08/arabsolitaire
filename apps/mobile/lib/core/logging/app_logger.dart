import 'package:flutter/foundation.dart';
import 'package:mobile/app/config/app_environment.dart';

/// Application logging abstraction — no uncontrolled print in production paths.
final class AppLogger {
  AppLogger({required this.environment});

  final AppEnvironment environment;

  void debug(String message) => _log('DEBUG', message);

  void info(String message) => _log('INFO', message);

  void warning(String message, {Object? error, StackTrace? stackTrace}) {
    _log('WARN', message, error: error, stackTrace: stackTrace);
  }

  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _log('ERROR', message, error: error, stackTrace: stackTrace);
  }

  void _log(
    String level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    final buffer = StringBuffer('[${environment.label}][$level] $message');
    if (error != null) {
      buffer.write(' | $error');
    }
    if (kDebugMode) {
      debugPrint(buffer.toString());
      if (stackTrace != null) {
        debugPrint(stackTrace.toString());
      }
    }
  }
}
