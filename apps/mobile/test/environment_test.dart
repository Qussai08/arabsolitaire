import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/config/app_environment.dart';

void main() {
  test('environments expose distinct placeholder application ids', () {
    final ids = AppEnvironment.values
        .map((e) => e.applicationIdPlaceholder)
        .toSet();
    expect(ids.length, AppEnvironment.values.length);
    expect(
      AppEnvironment.prod.applicationIdPlaceholder,
      'com.arabsolitaire.app',
    );
  });
}
