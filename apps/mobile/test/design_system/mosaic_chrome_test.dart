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

  testWidgets('toast tones keep an icon cue', (tester) async {
    await tester.pumpWidget(
      _harness(
        const MosaicToast(
          tone: MosaicToastTone.success,
          title: 'تم',
          message: 'حُفظ التقدم',
        ),
      ),
    );
    expect(find.text('تم'), findsOneWidget);
    expect(find.text('حُفظ التقدم'), findsOneWidget);
    expect(find.byType(MosaicIcon), findsOneWidget);

    await tester.pumpWidget(
      _harness(
        const MosaicToast(
          tone: MosaicToastTone.error,
          showTitle: false,
          message: 'تعذر',
        ),
      ),
    );
    expect(find.text('تعذر'), findsOneWidget);
    expect(find.byType(MosaicIcon), findsOneWidget);
  });

  testWidgets('row toggle moves the knob and header keeps back on the start', (
    tester,
  ) async {
    var on = false;
    await tester.pumpWidget(
      _harness(
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                const MosaicHeader(title: 'العنوان', subtitle: 'فرع'),
                MosaicRow(
                  title: 'الموسيقى',
                  showSubtitle: false,
                  trailing: MosaicRowTrailing.toggle,
                  toggleValue: on,
                  onToggle: (value) => setState(() => on = value),
                ),
              ],
            );
          },
        ),
      ),
    );

    expect(
      tester.getTopLeft(find.text('رجوع')).dx,
      greaterThan(tester.getTopLeft(find.text('العنوان')).dx),
    );
    final knob = find.descendant(
      of: find.byType(AnimatedAlign),
      matching: find.byType(Container),
    );
    final before = tester.getCenter(knob).dx;
    await tester.tap(find.byType(AnimatedContainer));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    expect(on, isTrue);
    expect(
      tester.widget<AnimatedAlign>(find.byType(AnimatedAlign)).alignment,
      AlignmentDirectional.centerEnd,
    );
    expect(tester.getCenter(knob).dx, lessThan(before));
  });

  testWidgets('tool badge and level node keep a non-color cue', (tester) async {
    await tester.pumpWidget(
      _harness(
        const Column(
          children: [
            MosaicToolButton(
              icon: MosaicIconKind.hint,
              label: 'تلميح',
              badge: 0,
              showBadge: true,
              onPressed: _noop,
            ),
            MosaicLevelNode(state: MosaicLevelNodeState.locked),
            MosaicLevelNode(state: MosaicLevelNodeState.current, number: 37),
          ],
        ),
      ),
    );
    expect(find.text('٠'), findsOneWidget);
    expect(find.text('مقفل'), findsOneWidget);
    expect(find.text('الحالي'), findsOneWidget);
    expect(find.text('٣٧'), findsOneWidget);
    expect(ArabicDigits.hasMiddleDotBesideDigits('٣٧'), isFalse);
  });

  testWidgets('shiboub bubble includes the portrait once', (tester) async {
    await tester.pumpWidget(
      _harness(const MosaicShiboubBubble(line: 'يا سلام')),
    );
    expect(find.text('شيبوب'), findsOneWidget);
    expect(find.text('يا سلام'), findsOneWidget);
    expect(find.byType(MosaicShiboubAvatar), findsOneWidget);
  });
}

void _noop() {}

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
