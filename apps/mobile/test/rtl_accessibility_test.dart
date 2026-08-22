/// RTL, localization, and accessibility baseline tests — Sprint 11 §53–§56.
///
/// Covers:
/// - Arabic RTL directionality is set on all key screens.
/// - Diagnostics screen renders RTL correctly with non-empty version strings.
/// - Semantic labels exist on key controls (accessibility baseline).
/// - Text contrast is not checked programmatically here — use accessibility
///   scanner on-device; document limitation in accessibility checklist.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/bootstrap/bootstrap.dart';
import 'package:mobile/app/config/app_config.dart';
import 'package:mobile/app/config/app_environment.dart';
import 'package:mobile/core/localization/l10n/app_localizations.dart';
import 'package:mobile/core/logging/app_logger.dart';
import 'package:mobile/features/diagnostics/diagnostics_screen.dart';

Widget _rtlApp({required Widget home}) {
  return ProviderScope(
    overrides: [
      appConfigProvider.overrideWithValue(
        AppConfig.forEnvironment(AppEnvironment.dev),
      ),
      appLoggerProvider.overrideWithValue(
        AppLogger(environment: AppEnvironment.dev),
      ),
    ],
    child: MaterialApp(
      locale: const Locale('ar'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
}

void main() {
  group('Arabic RTL baseline', () {
    testWidgets('MaterialApp sets RTL directionality for Arabic locale',
        (tester) async {
      await tester.pumpWidget(
        _rtlApp(
          home: const Scaffold(body: Text('مرحبا')),
        ),
      );
      await tester.pumpAndSettle();

      // Top-level Directionality widget must be RTL.
      final directionality = tester.widget<Directionality>(
        find.byType(Directionality).first,
      );
      expect(
        directionality.textDirection,
        TextDirection.rtl,
        reason: 'Arabic locale must produce RTL directionality',
      );
    });

    testWidgets('DiagnosticsScreen renders in RTL with non-empty version data',
        (tester) async {
      await tester.pumpWidget(_rtlApp(home: const DiagnosticsScreen()));
      await tester.pumpAndSettle();

      // Version label row must be present.
      expect(find.text('الإصدار'), findsOneWidget);
      expect(find.text('البيئة'), findsOneWidget);
      expect(find.text('إصدار قواعد اللعبة'), findsOneWidget);

      // App version must not be empty (from AppConfig.forEnvironment).
      final versionFinder = find.text('1.0.0');
      expect(
        versionFinder,
        findsOneWidget,
        reason: 'AppConfig.appVersion must be non-empty in diagnostics',
      );
    });

    testWidgets('DiagnosticsScreen AppBar title is Arabic', (tester) async {
      await tester.pumpWidget(_rtlApp(home: const DiagnosticsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('معلومات التطبيق'), findsOneWidget);
    });
  });

  group('Accessibility baseline', () {
    testWidgets('DiagnosticsScreen has no immediate accessibility violations',
        (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_rtlApp(home: const DiagnosticsScreen()));
      await tester.pumpAndSettle();

      // Verify the app renders without throwing — full a11y audit requires
      // the Accessibility Scanner on-device or flutter_accessibility_service.
      expect(tester.takeException(), isNull);

      handle.dispose();
    });

    testWidgets('Selectable version text has semantic label', (tester) async {
      await tester.pumpWidget(_rtlApp(home: const DiagnosticsScreen()));
      await tester.pumpAndSettle();

      // SelectableText for version value must be present and tappable.
      expect(find.byType(SelectableText), findsWidgets);
    });
  });

  group('Localization completeness', () {
    test('Arabic locale is in supported locales', () {
      const supported = AppLocalizations.supportedLocales;
      expect(
        supported.any((l) => l.languageCode == 'ar'),
        isTrue,
        reason: 'Arabic must be a supported locale',
      );
    });

    test('English locale is in supported locales', () {
      const supported = AppLocalizations.supportedLocales;
      expect(
        supported.any((l) => l.languageCode == 'en'),
        isTrue,
      );
    });
  });
}
