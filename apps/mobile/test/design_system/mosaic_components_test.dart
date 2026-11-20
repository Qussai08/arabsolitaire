import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/design_system/design_system.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final readex = FontLoader(MosaicFonts.readexPro);
    for (final asset in const [
      'assets/fonts/ReadexPro-Regular.ttf',
      'assets/fonts/ReadexPro-Medium.ttf',
      'assets/fonts/ReadexPro-SemiBold.ttf',
      'assets/fonts/ReadexPro-Bold.ttf',
    ]) {
      readex.addFont(rootBundle.load(asset));
    }
    await readex.load();
    final reem = FontLoader(MosaicFonts.reemKufi)
      ..addFont(rootBundle.load('assets/fonts/ReemKufi-Bold.ttf'));
    await reem.load();
  });

  testWidgets('bundled fonts shape Arabic narrower than a fallback', (
    tester,
  ) async {
    final styled = TextPainter(
      text: TextSpan(text: 'مجموعة', style: MosaicTextStyles.standard.labelS),
      textDirection: TextDirection.rtl,
    )..layout();
    final fallback = TextPainter(
      text: const TextSpan(
        text: 'مجموعة',
        style: TextStyle(fontSize: 11, fontFamily: 'NotARealFontFamily'),
      ),
      textDirection: TextDirection.rtl,
    )..layout();
    expect(styled.width, lessThan(50));
    expect(styled.width, lessThan(fallback.width));
  });

  testWidgets('card states keep a non-color cue', (tester) async {
    await tester.pumpWidget(
      _harness(const MosaicCard(state: MosaicCardState.faceDown, word: 'بحر')),
    );
    expect(find.bySemanticsLabel('بطاقة مقلوبة'), findsOneWidget);
    expect(find.text('بحر'), findsNothing);
    expect(find.byType(MosaicStar), findsOneWidget);

    await tester.pumpWidget(
      _harness(const MosaicCard(state: MosaicCardState.word, word: 'بحر')),
    );
    expect(find.text('بحر'), findsOneWidget);

    await tester.pumpWidget(
      _harness(
        const MosaicCard(
          state: MosaicCardState.clue,
          clue: 'كلمات الماء',
          countLabel: '٤ كلمات',
        ),
      ),
    );
    expect(find.text('مجموعة'), findsOneWidget);
    expect(find.text('كلمات الماء'), findsOneWidget);
    expect(find.text('٤ كلمات'), findsOneWidget);

    await tester.pumpWidget(
      _harness(const MosaicCard(state: MosaicCardState.selected, word: 'بحر')),
    );
    expect(find.text('بحر'), findsOneWidget);
    expect(find.bySemanticsLabel('محددة'), findsOneWidget);
    final card = tester.getRect(find.byType(MosaicCard));
    final badge = tester.getRect(find.bySemanticsLabel('محددة'));
    expect(badge.center.dx, greaterThan(card.center.dx));
    expect(badge.top, lessThan(card.top));

    await tester.pumpWidget(
      _harness(
        const MosaicCard(state: MosaicCardState.validTarget, word: 'بحر'),
      ),
    );
    expect(find.byType(MosaicDashedBorder), findsOneWidget);
    expect(find.bySemanticsLabel('هدف صالح'), findsOneWidget);

    await tester.pumpWidget(
      _harness(const MosaicCard(state: MosaicCardState.invalid, word: 'بحر')),
    );
    expect(find.bySemanticsLabel('مرفوضة'), findsOneWidget);
    expect(find.byType(MosaicDashedBorder), findsNothing);

    await tester.pumpWidget(
      _harness(const MosaicCard(state: MosaicCardState.completed, word: 'بحر')),
    );
    expect(find.bySemanticsLabel('مكتملة'), findsOneWidget);

    await tester.pumpWidget(
      _harness(const MosaicCard(state: MosaicCardState.disabled, word: 'بحر')),
    );
    expect(find.text('بحر'), findsOneWidget);
    final opacity = tester.widget<Opacity>(find.byType(Opacity));
    expect(opacity.opacity, MosaicOpacity.disabled);
  });

  testWidgets('slot progress fills from the right and previews a drop', (
    tester,
  ) async {
    await tester.pumpWidget(
      _harness(const MosaicSlot(state: MosaicSlotState.empty)),
    );
    expect(find.text('خانة فارغة'), findsOneWidget);
    expect(find.text('اسحب بطاقة مجموعة هنا'), findsOneWidget);
    expect(find.byType(MosaicDashedBorder), findsOneWidget);

    await tester.pumpWidget(
      _harness(
        const MosaicSlot(
          state: MosaicSlotState.active,
          clue: 'كلمات الماء',
          filled: 2,
          total: 4,
          members: ['بحر', 'موج'],
        ),
      ),
    );
    expect(find.text('كلمات الماء'), findsOneWidget);
    expect(find.text(ArabicDigits.progress(2, 4)), findsOneWidget);
    expect(find.text('بحر · موج'), findsOneWidget);
    final pips = find.byType(MosaicPip);
    expect(pips, findsNWidgets(4));
    final widgets = tester.widgetList<MosaicPip>(pips).toList();
    expect(widgets.map((pip) => pip.filled), [true, true, false, false]);
    expect(
      tester.getTopLeft(pips.at(0)).dx,
      greaterThan(tester.getTopLeft(pips.at(3)).dx),
    );

    await tester.pumpWidget(
      _harness(
        const MosaicSlot(
          state: MosaicSlotState.dropTarget,
          clue: 'كلمات الماء',
          filled: 2,
          total: 4,
          members: ['بحر', 'موج'],
        ),
      ),
    );
    expect(find.byType(MosaicDashedBorder), findsOneWidget);
    final preview = tester.widgetList<MosaicPip>(find.byType(MosaicPip));
    expect(preview.where((pip) => pip.filled), hasLength(3));

    await tester.pumpWidget(
      _harness(
        const MosaicSlot(state: MosaicSlotState.completed, filled: 4, total: 4),
      ),
    );
    expect(find.text('اكتملت المجموعة!'), findsOneWidget);
    expect(find.textContaining('تُزال من اللوحة'), findsOneWidget);
    expect(find.textContaining('—'), findsOneWidget);
    expect(find.byType(MosaicDashedBorder), findsNothing);
  });

  testWidgets('buttons use kind, RTL icon side, press, and disabled', (
    tester,
  ) async {
    await tester.pumpWidget(
      _harness(MosaicButton(label: 'متابعة', onPressed: () {})),
    );
    final primary = _fill(tester);
    expect(primary.color, MosaicColors.terracotta600);
    expect(primary.boxShadow, MosaicShadows.card);
    expect(
      tester.getTopLeft(find.byIcon(Icons.arrow_forward)).dx,
      lessThan(tester.getTopLeft(find.text('متابعة')).dx),
    );

    await tester.press(find.text('متابعة'));
    await tester.pump();
    expect(
      tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale,
      MosaicMotion.pressedScale,
    );
    expect(_fill(tester).boxShadow, isNull);

    await tester.pumpWidget(
      _harness(
        const MosaicButton(label: 'رجوع', kind: MosaicButtonKind.secondary),
      ),
    );
    expect(_fill(tester).color, MosaicColors.paper);
    expect(_fill(tester).border?.top.color, MosaicColors.emerald600);
    expect(_fill(tester).boxShadow, isNull);
    final opacity = tester.widget<Opacity>(find.byType(Opacity));
    expect(opacity.opacity, MosaicOpacity.disabled);
    expect(
      tester.getTopLeft(find.byIcon(Icons.arrow_back)).dx,
      greaterThan(tester.getTopLeft(find.text('رجوع')).dx),
    );

    var taps = 0;
    await tester.pumpWidget(
      _harness(
        MosaicButton(
          label: 'حذف',
          kind: MosaicButtonKind.danger,
          onPressed: () => taps++,
        ),
      ),
    );
    await tester.tap(find.text('حذف'));
    await tester.pump();
    expect(taps, 1);
    expect(_fill(tester).color, MosaicColors.danger700);
  });

  testWidgets('HUD chip formats the count and keeps the icon at the start', (
    tester,
  ) async {
    await tester.pumpWidget(
      _harness(
        MosaicHudChip.count(
          icon: MosaicHudIcon.coin,
          amount: 30,
          label: 'عملة',
        ),
      ),
    );
    expect(find.text('٣٠'), findsOneWidget);
    expect(find.text('عملة'), findsOneWidget);
    expect(
      tester.getTopLeft(find.byType(MosaicCoinIcon)).dx,
      greaterThan(tester.getTopLeft(find.text('٣٠')).dx),
    );

    await tester.pumpWidget(
      _harness(
        MosaicHudChip.count(
          icon: MosaicHudIcon.hint,
          amount: 3,
          showLabel: false,
        ),
      ),
    );
    expect(find.text('٣'), findsOneWidget);
    expect(find.text('عملة'), findsNothing);
    expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget);
  });
}

Widget _harness(Widget child) {
  return MaterialApp(
    theme: MosaicThemeData.light(),
    builder: (context, child) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      );
    },
    home: Scaffold(body: Center(child: child)),
  );
}

BoxDecoration _fill(WidgetTester tester) {
  final decorations = tester
      .widgetList<DecoratedBox>(find.byType(DecoratedBox))
      .map((box) => box.decoration)
      .whereType<BoxDecoration>()
      .where((decoration) => decoration.color != null);
  return decorations.first;
}
