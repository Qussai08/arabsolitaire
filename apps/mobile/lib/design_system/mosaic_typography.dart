import 'package:flutter/material.dart';
import 'package:mobile/design_system/mosaic_tokens.dart';

/// The eleven text styles from the Figma export.
///
/// Line height is `lineHeight / fontSize` with even leading so the box
/// matches the token, not Flutter's default alphabetic strut.
class MosaicTextStyles {
  const MosaicTextStyles({
    required this.displayXl,
    required this.displayL,
    required this.titleM,
    required this.titleS,
    required this.bodyM,
    required this.bodyS,
    required this.labelM,
    required this.labelS,
    required this.cardWord,
    required this.cardClue,
    required this.numberHud,
  });

  static const standard = MosaicTextStyles(
    displayXl: TextStyle(
      fontFamily: MosaicFonts.reemKufi,
      fontWeight: FontWeight.w700,
      fontSize: 40,
      height: 52 / 40,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
      color: MosaicColors.emerald900,
    ),
    displayL: TextStyle(
      fontFamily: MosaicFonts.reemKufi,
      fontWeight: FontWeight.w700,
      fontSize: 28,
      height: 38 / 28,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
      color: MosaicColors.emerald900,
    ),
    titleM: TextStyle(
      fontFamily: MosaicFonts.readexPro,
      fontWeight: FontWeight.w600,
      fontSize: 20,
      height: 28 / 20,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
      color: MosaicColors.emerald900,
    ),
    titleS: TextStyle(
      fontFamily: MosaicFonts.readexPro,
      fontWeight: FontWeight.w600,
      fontSize: 16,
      height: 24 / 16,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
      color: MosaicColors.emerald900,
    ),
    bodyM: TextStyle(
      fontFamily: MosaicFonts.readexPro,
      fontWeight: FontWeight.w400,
      fontSize: 15,
      height: 24 / 15,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
      color: MosaicColors.textPrimary,
    ),
    bodyS: TextStyle(
      fontFamily: MosaicFonts.readexPro,
      fontWeight: FontWeight.w400,
      fontSize: 13,
      height: 20 / 13,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
      color: MosaicColors.textPrimary,
    ),
    labelM: TextStyle(
      fontFamily: MosaicFonts.readexPro,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      height: 20 / 14,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
      color: MosaicColors.emerald900,
    ),
    labelS: TextStyle(
      fontFamily: MosaicFonts.readexPro,
      fontWeight: FontWeight.w500,
      fontSize: 11,
      height: 16 / 11,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
      color: MosaicColors.textMuted,
    ),
    cardWord: TextStyle(
      fontFamily: MosaicFonts.readexPro,
      fontWeight: FontWeight.w600,
      fontSize: 15,
      height: 20 / 15,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
      color: MosaicColors.textPrimary,
    ),
    cardClue: TextStyle(
      fontFamily: MosaicFonts.reemKufi,
      fontWeight: FontWeight.w700,
      fontSize: 14,
      height: 18 / 14,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
      color: MosaicColors.onDark,
    ),
    numberHud: TextStyle(
      fontFamily: MosaicFonts.readexPro,
      fontWeight: FontWeight.w700,
      fontSize: 22,
      height: 26 / 22,
      letterSpacing: 0,
      leadingDistribution: TextLeadingDistribution.even,
      color: MosaicColors.emerald900,
    ),
  );

  final TextStyle displayXl;
  final TextStyle displayL;
  final TextStyle titleM;
  final TextStyle titleS;
  final TextStyle bodyM;
  final TextStyle bodyS;
  final TextStyle labelM;
  final TextStyle labelS;
  final TextStyle cardWord;
  final TextStyle cardClue;
  final TextStyle numberHud;

  TextTheme toMaterial() {
    return TextTheme(
      displayLarge: displayXl,
      displayMedium: displayL,
      displaySmall: titleM,
      headlineLarge: displayL,
      headlineMedium: titleM,
      headlineSmall: titleS,
      titleLarge: titleM,
      titleMedium: titleS,
      titleSmall: labelM,
      bodyLarge: bodyM,
      bodyMedium: bodyS,
      bodySmall: labelS,
      labelLarge: labelM,
      labelMedium: labelS,
      labelSmall: labelS,
    );
  }

  MosaicTextStyles lerp(MosaicTextStyles other, double t) {
    TextStyle mix(TextStyle a, TextStyle b) => TextStyle.lerp(a, b, t)!;
    return MosaicTextStyles(
      displayXl: mix(displayXl, other.displayXl),
      displayL: mix(displayL, other.displayL),
      titleM: mix(titleM, other.titleM),
      titleS: mix(titleS, other.titleS),
      bodyM: mix(bodyM, other.bodyM),
      bodyS: mix(bodyS, other.bodyS),
      labelM: mix(labelM, other.labelM),
      labelS: mix(labelS, other.labelS),
      cardWord: mix(cardWord, other.cardWord),
      cardClue: mix(cardClue, other.cardClue),
      numberHud: mix(numberHud, other.numberHud),
    );
  }
}
