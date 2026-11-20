import 'package:flutter/material.dart';
import 'package:mobile/design_system/mosaic_tokens.dart';
import 'package:mobile/design_system/mosaic_typography.dart';

/// Named text styles carried on [ThemeData.extensions].
///
/// Colors, radii, spacing, and shadows stay compile-time constants
/// ([MosaicColors] and the rest): the export has a single Light mode.
/// They are also written into [ColorScheme] by [MosaicThemeData.light].
@immutable
class MosaicTheme extends ThemeExtension<MosaicTheme> {
  const MosaicTheme({required this.text});

  static const standard = MosaicTheme(text: MosaicTextStyles.standard);

  final MosaicTextStyles text;

  static MosaicTheme of(BuildContext context) {
    final theme = Theme.of(context).extension<MosaicTheme>();
    if (theme == null) {
      throw FlutterError(
        'MosaicTheme is not installed. Use MosaicThemeData.light() as '
        'ThemeData.',
      );
    }
    return theme;
  }

  @override
  MosaicTheme copyWith({MosaicTextStyles? text}) {
    return MosaicTheme(text: text ?? this.text);
  }

  @override
  MosaicTheme lerp(ThemeExtension<MosaicTheme>? other, double t) {
    if (other is! MosaicTheme) {
      return this;
    }
    return MosaicTheme(text: text.lerp(other.text, t));
  }
}

/// Builds the app [ThemeData] for «فسيفساء المعاني».
abstract final class MosaicThemeData {
  static ThemeData light() {
    const text = MosaicTextStyles.standard;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: MosaicColors.terracotta600,
          brightness: Brightness.light,
        ).copyWith(
          primary: MosaicColors.terracotta600,
          onPrimary: MosaicColors.onDark,
          primaryContainer: MosaicColors.terracotta100,
          onPrimaryContainer: MosaicColors.emerald900,
          secondary: MosaicColors.emerald600,
          onSecondary: MosaicColors.onDark,
          secondaryContainer: MosaicColors.mint100,
          onSecondaryContainer: MosaicColors.emerald900,
          tertiary: MosaicColors.saffron500,
          onTertiary: MosaicColors.emerald900,
          tertiaryContainer: MosaicColors.saffron100,
          onTertiaryContainer: MosaicColors.emerald900,
          error: MosaicColors.danger700,
          onError: MosaicColors.onDark,
          errorContainer: MosaicColors.danger100,
          onErrorContainer: MosaicColors.danger700,
          surface: MosaicColors.limestone,
          onSurface: MosaicColors.textPrimary,
          onSurfaceVariant: MosaicColors.textMuted,
          outline: MosaicColors.line,
          outlineVariant: MosaicColors.line,
          shadow: const Color(0xFF3D2B14),
          scrim: MosaicColors.emerald900,
          inverseSurface: MosaicColors.emerald900,
          onInverseSurface: MosaicColors.onDark,
          inversePrimary: MosaicColors.terracotta100,
          surfaceTint: const Color(0x00000000),
        );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(MosaicRadii.md),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: MosaicColors.limestone,
      fontFamily: MosaicFonts.readexPro,
      textTheme: text.toMaterial(),
      extensions: const <ThemeExtension<dynamic>>[MosaicTheme.standard],
      dividerColor: MosaicColors.line,
      iconTheme: const IconThemeData(color: MosaicColors.emerald900),
      appBarTheme: AppBarTheme(
        backgroundColor: MosaicColors.limestone,
        foregroundColor: MosaicColors.emerald900,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: text.titleM,
        iconTheme: const IconThemeData(color: MosaicColors.emerald900),
      ),
      cardTheme: CardThemeData(
        color: MosaicColors.paper,
        elevation: 0,
        shape: shape,
        margin: EdgeInsets.zero,
      ),
      dialogTheme: const DialogThemeData(backgroundColor: MosaicColors.paper),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: MosaicColors.paper,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(MosaicRadii.lg),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: MosaicColors.terracotta600,
          foregroundColor: MosaicColors.onDark,
          textStyle: text.titleS,
          minimumSize: const Size(64, MosaicSizes.buttonHeight),
          shape: shape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: MosaicColors.emerald600,
          textStyle: text.titleS,
          side: const BorderSide(
            color: MosaicColors.emerald600,
            width: MosaicBorder.normal,
          ),
          minimumSize: const Size(64, MosaicSizes.buttonHeight),
          shape: shape,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: MosaicColors.emerald600,
          textStyle: text.titleS,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: MosaicColors.emerald600,
      ),
    );
  }
}
