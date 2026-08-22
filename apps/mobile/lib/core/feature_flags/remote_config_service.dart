import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/app/bootstrap/bootstrap.dart';
import 'package:mobile/core/feature_flags/feature_flag_defaults.dart';

/// Safe Remote Config wrapper — defaults always win on failure.
final class RemoteConfigService {
  RemoteConfigService(this._ref);

  final Ref _ref;
  final Map<String, Object> _values = Map<String, Object>.from(
    FeatureFlagDefaults.values,
  );

  T getValue<T extends Object>(String key) {
    final value = _values[key];
    if (value is T) {
      return value;
    }
    final fallback = FeatureFlagDefaults.values[key];
    if (fallback is T) {
      return fallback;
    }
    throw StateError('Missing Remote Config default for $key');
  }

  Future<void> initializeSafely() async {
    final logger = _ref.read(appLoggerProvider);
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      await remoteConfig.setDefaults(FeatureFlagDefaults.values);
      await remoteConfig.fetchAndActivate();
      for (final entry in FeatureFlagDefaults.values.entries) {
        final key = entry.key;
        final defaultValue = entry.value;
        if (defaultValue is bool) {
          _values[key] = remoteConfig.getBool(key);
        } else if (defaultValue is int) {
          _values[key] = remoteConfig.getInt(key);
        } else if (defaultValue is double) {
          _values[key] = remoteConfig.getDouble(key);
        } else if (defaultValue is String) {
          _values[key] = remoteConfig.getString(key);
        }
      }
      logger.info('Remote Config activated');
    } catch (error, stackTrace) {
      logger.warning(
        'Remote Config unavailable — using local defaults',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

final remoteConfigServiceProvider = Provider<RemoteConfigService>(
  RemoteConfigService.new,
);
