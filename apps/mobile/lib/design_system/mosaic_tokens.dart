import 'package:flutter/material.dart';

/// Light-mode tokens for «فسيفساء المعاني».
///
/// Transcribed from `apps/mobile/design/tokens.json` (Figma export, 2026-11-20).
/// `test/design_system/mosaic_tokens_test.dart` fails if these drift from that file.
abstract final class MosaicColors {
  static const limestone = Color(0xFFF3ECDF);
  static const paper = Color(0xFFFBF7EF);
  static const plaster = Color(0xFFE8DECD);
  static const line = Color(0xFFD8CBB4);
  static const emerald900 = Color(0xFF0E3A33);
  static const emerald600 = Color(0xFF1D6B5B);
  static const mint100 = Color(0xFFD3E8DE);
  static const lapis700 = Color(0xFF233F7A);
  static const lapis100 = Color(0xFFDDE4F3);
  static const terracotta600 = Color(0xFFC2532B);
  static const terracotta100 = Color(0xFFF7DDD0);
  static const saffron500 = Color(0xFFE5A23A);
  static const saffron100 = Color(0xFFFBE8C4);
  static const textPrimary = Color(0xFF1B2A27);
  static const textMuted = Color(0xFF5E6B66);
  static const onDark = Color(0xFFFBF7EF);
  static const danger700 = Color(0xFFA8321F);
  static const danger100 = Color(0xFFF6DAD3);
  static const success700 = Color(0xFF2B7A55);
  static const coinStroke = Color(0xFF9A6416);

  /// Modal scrim is [emerald900] at [MosaicOpacity.scrim].
  static const scrim = Color(0xB30E3A33);

  /// OS permission dialog scrim.
  static const systemScrim = Color(0x80000000);
}

abstract final class MosaicFonts {
  static const reemKufi = 'Reem Kufi';
  static const readexPro = 'Readex Pro';
}

abstract final class MosaicRadii {
  static const sm = 8.0;
  static const md = 14.0;
  static const lg = 22.0;
  static const pill = 999.0;
  static const archTop = 30.0;
  static const archBottom = 5.0;
  static const badge = 12.0;

  /// Bubble tail is the physical bottom-right corner (avatar sits on the right).
  static const bubble = BorderRadius.only(
    topLeft: Radius.circular(16),
    topRight: Radius.circular(16),
    bottomRight: Radius.circular(4),
    bottomLeft: Radius.circular(16),
  );
}

abstract final class MosaicSpacing {
  static const s4 = 4.0;
  static const s6 = 6.0;
  static const s8 = 8.0;
  static const s12 = 12.0;
  static const s16 = 16.0;
  static const s20 = 20.0;
  static const s24 = 24.0;
  static const gutterPhone = 16.0;
  static const gutterTablet = 24.0;
  static const gutterCompact = 12.0;
  static const columnStackOverlap = -62.0;
  static const columnStackVisibleStrip = 34.0;

  static double gutterForWidth(double width) {
    if (width >= MosaicSizes.tabletWidth) {
      return gutterTablet;
    }
    if (width <= MosaicSizes.compactWidth) {
      return gutterCompact;
    }
    return gutterPhone;
  }
}

abstract final class MosaicBorder {
  static const hairline = 1.0;
  static const normal = 1.5;
  static const emphasis = 2.0;
  static const dropTarget = 2.5;
  static const selected = 3.0;
  static const currentLevel = 4.0;
}

abstract final class MosaicDash {
  static const slotEmpty = <double>[6, 4];
  static const validTarget = <double>[5, 3];
  static const medallion = <double>[6, 5];
}

abstract final class MosaicOpacity {
  static const disabled = 0.45;
  static const scrim = 0.7;
  static const systemScrim = 0.5;
  static const swatchLabel = 0.9;
  static const closeIcon = 0.4;
  static const lockedTile = 0.7;
  static const statusBar = 0.8;
  static const infoMuted = 0.85;
}

abstract final class MosaicSizes {
  static const phoneWidth = 390.0;
  static const tabletWidth = 768.0;
  static const compactWidth = 360.0;
  static const cardWidth = 72.0;
  static const cardHeight = 96.0;
  static const cardPadding = 5.0;
  static const cardBadge = 24.0;
  static const slotWidth = 166.0;
  static const slotWidthCompact = 164.0;
  static const slotHeight = 116.0;
  static const buttonHeight = 54.0;
  static const buttonHeightLarge = 58.0;
  static const buttonPaddingX = 20.0;
  static const buttonGap = 10.0;
  static const buttonIcon = 20.0;
  static const hudHeight = 54.0;
  static const hudHeightCompact = 38.0;
  static const hudIcon = 20.0;
  static const pip = 10.0;
  static const minTouchTarget = 44.0;
}

/// Shadows from the Figma effect styles.
///
/// Alphas are the nearest 8-bit values of the exported opacity
/// (0.18 → 0x2E, 0.10 → 0x1A, 0.22 → 0x38, 0.55 → 0x8C).
abstract final class MosaicShadows {
  static const card = <BoxShadow>[
    BoxShadow(color: Color(0x2E3D2B14), offset: Offset(0, 2)),
    BoxShadow(color: Color(0x1A3D2B14), offset: Offset(0, 6), blurRadius: 12),
  ];

  static const sheet = <BoxShadow>[
    BoxShadow(color: Color(0x380D2621), offset: Offset(0, -8), blurRadius: 32),
  ];

  static const selectedGlow = <BoxShadow>[
    BoxShadow(color: Color(0x8CE5A33B), blurRadius: 14, spreadRadius: 2),
  ];
}

/// Pressed scale for tappables. Not drawn in Figma; specified as recommended.
abstract final class MosaicMotion {
  static const pressedScale = 0.97;
}
