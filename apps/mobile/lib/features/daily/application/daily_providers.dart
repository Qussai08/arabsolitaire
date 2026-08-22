import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/storage/database_provider.dart';
import 'package:mobile/features/daily/data/daily_local_repository.dart';
import 'package:mobile/features/daily/data/daily_remote_repository.dart';
import 'package:mobile/features/notifications/data/fcm_service.dart';

final dailyLocalRepositoryProvider = Provider<DailyLocalRepository?>((ref) {
  final db = ref.watch(appDatabaseProvider).valueOrNull;
  if (db == null) return null;
  return DriftDailyLocalRepository(db);
});

final dailyRemoteRepositoryProvider = Provider<DailyRemoteRepository>((ref) {
  try {
    return FirebaseDailyRemoteRepository(FirebaseFunctions.instance);
  } catch (_) {
    return const OfflineDailyRemoteRepository();
  }
});

final fcmServiceProvider = Provider<FcmService>((ref) {
  return const NoOpFcmService();
});
