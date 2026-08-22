import 'package:flutter/material.dart';
import 'package:mobile/core/localization/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/bootstrap/bootstrap.dart';
import 'package:mobile/app/config/app_config.dart';
import 'package:mobile/app/config/app_environment.dart';
import 'package:mobile/core/logging/app_logger.dart';
import 'package:mobile/features/bootstrap/presentation/home_placeholder_screen.dart';

void main() {
  testWidgets('Arabic RTL shell renders title and subtitle', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(
            AppConfig.forEnvironment(AppEnvironment.dev),
          ),
          appLoggerProvider.overrideWithValue(
            AppLogger(environment: AppEnvironment.dev),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('ar'),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: HomePlaceholderScreen(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('سوليتير العرب'), findsWidgets);
    expect(find.text('أسطورة المعاني'), findsOneWidget);

    final directionality = tester.widget<Directionality>(
      find.byType(Directionality).first,
    );
    expect(directionality.textDirection, TextDirection.rtl);
  });
}
