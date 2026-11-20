import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/design_system/mosaic_illustrations.dart';
import 'package:mobile/design_system/mosaic_theme.dart';
import 'package:mobile/design_system/mosaic_tokens.dart';
import 'package:mobile/design_system/mosaic_typography.dart';

void main() {
  late Map<String, dynamic> tokens;

  setUp(() {
    tokens =
        jsonDecode(_packageFile('design/tokens.json').readAsStringSync())
            as Map<String, dynamic>;
  });

  test('color tokens match the Figma export', () {
    final color = tokens['color']! as Map<String, dynamic>;
    void expectHex(String key, Color actual) {
      final entry = color[key]! as Map<String, dynamic>;
      expect(_parseHex(entry['hex']! as String), actual, reason: key);
    }

    expectHex('surface/limestone', MosaicColors.limestone);
    expectHex('surface/paper', MosaicColors.paper);
    expectHex('surface/plaster', MosaicColors.plaster);
    expectHex('line/default', MosaicColors.line);
    expectHex('ink/emerald-900', MosaicColors.emerald900);
    expectHex('brand/emerald-600', MosaicColors.emerald600);
    expectHex('brand/mint-100', MosaicColors.mint100);
    expectHex('brand/lapis-700', MosaicColors.lapis700);
    expectHex('brand/lapis-100', MosaicColors.lapis100);
    expectHex('accent/terracotta-600', MosaicColors.terracotta600);
    expectHex('accent/terracotta-100', MosaicColors.terracotta100);
    expectHex('accent/saffron-500', MosaicColors.saffron500);
    expectHex('accent/saffron-100', MosaicColors.saffron100);
    expectHex('text/primary', MosaicColors.textPrimary);
    expectHex('text/muted', MosaicColors.textMuted);
    expectHex('text/on-dark', MosaicColors.onDark);
    expectHex('feedback/danger-700', MosaicColors.danger700);
    expectHex('feedback/danger-100', MosaicColors.danger100);
    expectHex('feedback/success-700', MosaicColors.success700);

    final extra = color['_extra']! as Map<String, dynamic>;
    final coin = extra['coin/stroke']! as Map<String, dynamic>;
    expect(_parseHex(coin['hex']! as String), MosaicColors.coinStroke);
    final scrim = extra['scrim']! as Map<String, dynamic>;
    expect(scrim['opacity'], MosaicOpacity.scrim);
    expect(_parseHex(scrim['hex']! as String), MosaicColors.emerald900);
    final system = extra['scrim/system']! as Map<String, dynamic>;
    expect(system['opacity'], MosaicOpacity.systemScrim);
  });

  test('text styles match the Figma export', () {
    final styles =
        (tokens['typography']! as Map<String, dynamic>)['styles']!
            as Map<String, dynamic>;
    final actual = <String, TextStyle>{
      'Display/XL': MosaicTextStyles.standard.displayXl,
      'Display/L': MosaicTextStyles.standard.displayL,
      'Title/M': MosaicTextStyles.standard.titleM,
      'Title/S': MosaicTextStyles.standard.titleS,
      'Body/M': MosaicTextStyles.standard.bodyM,
      'Body/S': MosaicTextStyles.standard.bodyS,
      'Label/M': MosaicTextStyles.standard.labelM,
      'Label/S': MosaicTextStyles.standard.labelS,
      'Card/Word': MosaicTextStyles.standard.cardWord,
      'Card/Clue': MosaicTextStyles.standard.cardClue,
      'Number/HUD': MosaicTextStyles.standard.numberHud,
    };

    expect(actual.keys.toSet(), styles.keys.toSet());
    for (final entry in actual.entries) {
      final spec = styles[entry.key]! as Map<String, dynamic>;
      final style = entry.value;
      expect(style.fontFamily, spec['fontFamily'], reason: entry.key);
      expect(style.fontSize, (spec['fontSize']! as num).toDouble());
      final weight = spec['fontWeight']! as int;
      expect(style.fontWeight, FontWeight.values[weight ~/ 100 - 1]);
      expect(
        style.height,
        closeTo(
          (spec['lineHeight']! as num) / (spec['fontSize']! as num),
          0.0001,
        ),
      );
      expect(style.letterSpacing, spec['letterSpacing']);
    }
  });

  test('radii, spacing, borders, opacity, and sizes match', () {
    final radius = tokens['radius']! as Map<String, dynamic>;
    expect(radius['sm'], MosaicRadii.sm);
    expect(radius['md'], MosaicRadii.md);
    expect(radius['lg'], MosaicRadii.lg);
    expect(radius['pill'], MosaicRadii.pill);
    final arch =
        (radius['_observed']! as Map<String, dynamic>)['cardArch']!
            as List<dynamic>;
    expect(arch[0], MosaicRadii.archTop);
    expect(arch[2], MosaicRadii.archBottom);

    final spacing = tokens['spacing']! as Map<String, dynamic>;
    final scale = spacing['scale']! as Map<String, dynamic>;
    expect(scale['4'], MosaicSpacing.s4);
    expect(scale['8'], MosaicSpacing.s8);
    expect(scale['12'], MosaicSpacing.s12);
    expect(scale['16'], MosaicSpacing.s16);
    expect(scale['20'], MosaicSpacing.s20);
    expect(scale['24'], MosaicSpacing.s24);
    final gutter = spacing['screenGutter']! as Map<String, dynamic>;
    expect(gutter['phone'], MosaicSpacing.gutterPhone);
    expect(gutter['tablet'], MosaicSpacing.gutterTablet);
    expect(gutter['compact'], MosaicSpacing.gutterCompact);
    expect(spacing['columnStackOverlap'], MosaicSpacing.columnStackOverlap);

    final border = tokens['borderWidth']! as Map<String, dynamic>;
    expect(border['hairline'], MosaicBorder.hairline);
    expect(border['default'], MosaicBorder.normal);
    expect(border['emphasis'], MosaicBorder.emphasis);
    expect(border['dropTarget'], MosaicBorder.dropTarget);
    expect(border['selected'], MosaicBorder.selected);
    expect(border['currentLevel'], MosaicBorder.currentLevel);
    final dash = border['dash']! as Map<String, dynamic>;
    expect(dash['slotEmpty'], MosaicDash.slotEmpty);
    expect(dash['validTarget'], MosaicDash.validTarget);
    expect(dash['medallion'], MosaicDash.medallion);

    final opacity = tokens['opacity']! as Map<String, dynamic>;
    expect(opacity['disabled'], MosaicOpacity.disabled);
    expect(opacity['scrim'], MosaicOpacity.scrim);
    expect(opacity['systemScrim'], MosaicOpacity.systemScrim);

    final size = tokens['size']! as Map<String, dynamic>;
    final card = size['card']! as Map<String, dynamic>;
    final phoneCard = card['phone']! as List<dynamic>;
    expect(phoneCard[0], MosaicSizes.cardWidth);
    expect(phoneCard[1], MosaicSizes.cardHeight);
    final button = size['button']! as Map<String, dynamic>;
    expect(button['height'], MosaicSizes.buttonHeight);
    expect(button['heightLarge'], MosaicSizes.buttonHeightLarge);
    expect(size['pip'], MosaicSizes.pip);
  });

  test('shadow layers match the effect styles', () {
    final effects = tokens['effects']! as Map<String, dynamic>;
    _expectShadows(
      effects['Elevation/Card']! as Map<String, dynamic>,
      MosaicShadows.card,
    );
    _expectShadows(
      effects['Elevation/Sheet']! as Map<String, dynamic>,
      MosaicShadows.sheet,
    );
    _expectShadows(
      effects['Glow/Selected']! as Map<String, dynamic>,
      MosaicShadows.selectedGlow,
    );
  });

  test('theme installs the palette and the text styles', () {
    final theme = MosaicThemeData.light();
    expect(theme.colorScheme.primary, MosaicColors.terracotta600);
    expect(theme.colorScheme.secondary, MosaicColors.emerald600);
    expect(theme.colorScheme.surface, MosaicColors.limestone);
    expect(theme.scaffoldBackgroundColor, MosaicColors.limestone);
    expect(theme.textTheme.displayLarge?.fontFamily, MosaicFonts.reemKufi);
    expect(theme.textTheme.bodyLarge?.fontFamily, MosaicFonts.readexPro);
    expect(theme.extension<MosaicTheme>(), MosaicTheme.standard);
  });

  test('illustration files are present', () {
    for (final asset in MosaicIllustrations.all) {
      expect(_packageFile(asset).existsSync(), isTrue, reason: asset);
    }
  });
}

void _expectShadows(Map<String, dynamic> effect, List<BoxShadow> actual) {
  final layers = effect['layers']! as List<dynamic>;
  expect(actual, hasLength(layers.length));
  for (var i = 0; i < layers.length; i++) {
    final layer = layers[i]! as Map<String, dynamic>;
    final shadow = actual[i];
    expect(shadow.offset.dx, (layer['x']! as num).toDouble());
    expect(shadow.offset.dy, (layer['y']! as num).toDouble());
    expect(shadow.blurRadius, (layer['blur']! as num).toDouble());
    expect(shadow.spreadRadius, (layer['spread']! as num).toDouble());
    final rgb = _parseHex(layer['color']! as String);
    expect(shadow.color.r, closeTo(rgb.r, 0.01));
    expect(shadow.color.g, closeTo(rgb.g, 0.01));
    expect(shadow.color.b, closeTo(rgb.b, 0.01));
    expect(shadow.color.a, closeTo(layer['alpha']! as num, 0.02));
  }
}

Color _parseHex(String hex) {
  final value = int.parse(hex.replaceFirst('#', ''), radix: 16);
  return Color(0xFF000000 | value);
}

File _packageFile(String relative) {
  final direct = File(relative);
  if (direct.existsSync()) {
    return direct;
  }
  final nested = File('apps/mobile/$relative');
  if (nested.existsSync()) {
    return nested;
  }
  return direct;
}
