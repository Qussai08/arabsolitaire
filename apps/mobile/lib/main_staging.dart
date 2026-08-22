import 'package:mobile/app/bootstrap/bootstrap.dart';
import 'package:mobile/app/config/app_environment.dart';

Future<void> main() async {
  await bootstrapAndRun(AppEnvironment.staging);
}
