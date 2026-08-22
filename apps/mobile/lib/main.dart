import 'package:mobile/app/bootstrap/bootstrap.dart';
import 'package:mobile/app/config/app_environment.dart';

/// Default local entry point (DEV).
/// Prefer explicit `main_*.dart` targets when selecting environments.
Future<void> main() async {
  await bootstrapAndRun(AppEnvironment.dev);
}
