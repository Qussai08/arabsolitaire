import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_engine/game_engine.dart';
import 'package:mobile/design_system/design_system.dart';
import 'package:mobile/features/economy/application/wallet_controller.dart';
import 'package:mobile/features/economy/domain/economy_models.dart';
import 'package:mobile/features/gameplay/application/gameplay_state.dart';
import 'package:mobile/features/gameplay/presentation/widgets/gameplay_overlay.dart';
import 'package:mobile/features/gameplay/presentation/widgets/tableau_view.dart';
import 'package:mobile/features/journey/application/journey_providers.dart';
import 'package:mobile/features/journey/data/journey_content.dart';
import 'package:mobile/features/journey/domain/journey_models.dart';
import 'package:mobile/features/journey/presentation/screens/home_screen.dart';
import 'package:mobile/features/journey/presentation/screens/journey_screen.dart';
import 'package:mobile/features/journey/presentation/screens/settings_screen.dart';

class _StaticJourney extends JourneyController {
  _StaticJourney(this.value);

  final JourneyViewState value;

  @override
  JourneyViewState build() => value;
}

class _StaticWallet extends WalletController {
  _StaticWallet(this.value);

  final WalletViewState value;

  @override
  WalletViewState build() => value;
}

void main() {
  final ready = JourneyReady(
    chapters: JourneyContent.chapters,
    levels: JourneyContent.buildLevels(),
    progress: const JourneyProgress(
      highestUnlockedLevel: 37,
      highestCompletedLevel: 36,
    ),
    flags: const PlayerLocalFlags(
      isFirstLaunch: false,
      onboardingCompleted: true,
      tutorialCompleted: true,
    ),
  );

  Future<void> pump(WidgetTester tester, Widget home) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          journeyControllerProvider.overrideWith(() => _StaticJourney(ready)),
          walletControllerProvider.overrideWith(
            () => _StaticWallet(
              const WalletReady(
                snapshot: WalletSnapshot(coinBalance: 300, hintBalance: 3),
              ),
            ),
          ),
        ],
        child: MaterialApp(
          theme: MosaicThemeData.light(),
          builder: (context, child) => Directionality(
            textDirection: TextDirection.rtl,
            child: child ?? const SizedBox.shrink(),
          ),
          home: home,
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('home uses mosaic copy and arabic digits', (tester) async {
    await pump(tester, const HomeScreen());
    expect(find.text('سوليتير العرب'), findsOneWidget);
    expect(find.text('أسطورة المعاني'), findsOneWidget);
    expect(find.textContaining('متابعة'), findsOneWidget);
    expect(find.text('الرحلة'), findsOneWidget);
    expect(find.text('الحكاية'), findsOneWidget);
    expect(find.text('٣٠٠'), findsOneWidget);
    expect(find.text('٣'), findsWidgets);
    final texts = tester.widgetList<Text>(find.byType(Text));
    for (final text in texts) {
      final value = text.data ?? '';
      expect(
        ArabicDigits.hasMiddleDotBesideDigits(value),
        isFalse,
        reason: value,
      );
    }
    expect(find.byType(MosaicButton), findsWidgets);
  });

  testWidgets('journey map names chapters and locks later ones', (
    tester,
  ) async {
    await pump(tester, const JourneyScreen());
    expect(find.text('الرحلة'), findsOneWidget);
    expect(find.text('القاهرة: أول خيط'), findsOneWidget);
    expect(find.text('دبي: ما بعد الذاكرة'), findsOneWidget);
    expect(find.text('مقفلة'), findsWidgets);
    expect(find.textContaining('العب المستوى'), findsOneWidget);
  });

  testWidgets('settings rows use the mosaic toggle', (tester) async {
    await pump(tester, const SettingsScreen());
    expect(find.text('الإعدادات'), findsWidgets);
    expect(find.text('الموسيقى'), findsOneWidget);
    expect(find.byType(MosaicRow), findsWidgets);
    await tester.tap(find.text('الموسيقى'));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('out of moves sheet keeps restart without a live purchase', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: MosaicThemeData.light(),
        builder: (context, child) => Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        ),
        home: GameplayOverlay(
          state: GameplayOutOfMoves(gameState: _minimalState()),
          onRestart: () {},
          onExit: () {},
        ),
      ),
    );
    expect(find.text('نفدت الحركات!'), findsOneWidget);
    expect(find.text('إعادة المستوى'), findsOneWidget);
    expect(find.text('الرئيسية'), findsOneWidget);
    expect(find.textContaining('لا يُضاف إلى اللوحة'), findsOneWidget);
  });

  testWidgets('tableau card shows the arabic face, not a hidden card', (
    tester,
  ) async {
    const hidden = MemberCard(
      id: 'secret-id',
      associationId: 'assoc',
      contentRefId: 'مخفي',
    );
    const shown = MemberCard(
      id: 'shown-id',
      associationId: 'assoc',
      contentRefId: 'نور',
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: MosaicThemeData.light(),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: TableauView(
              tableau: const [
                TableauColumn(
                  hiddenCards: [hidden],
                  exposedUnit: SingleMember(shown),
                ),
              ],
              revision: 1,
              onDrop: (_, _) {},
            ),
          ),
        ),
      ),
    );
    expect(find.text('نور'), findsOneWidget);
    expect(find.text('مخفي'), findsNothing);
    expect(find.byType(MosaicCard), findsWidgets);
  });
}

GameState _minimalState() {
  return GameState(
    attemptId: 'attempt-1',
    levelDefinitionId: 'cairo-1',
    associations: const {},
    tableau: const [],
    stock: const StockState(),
    slots: const [],
    moveLimit: 30,
    movesRemaining: 0,
  );
}
