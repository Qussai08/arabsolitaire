import 'package:flutter/material.dart';
import 'package:mobile/design_system/mosaic_tokens.dart';
import 'package:mobile/design_system/widgets/mosaic_dashed_border.dart';
import 'package:mobile/design_system/widgets/mosaic_icon.dart';
import 'package:mobile/design_system/widgets/mosaic_star.dart';

/// Tone of a medallion. The icon is the non-color cue.
enum MosaicMedallionTone { emerald, saffron, terracotta, lapis, danger }

/// Dashed disc used for empty states and badges.
class MosaicMedallion extends StatelessWidget {
  const MosaicMedallion({
    super.key,
    this.tone = MosaicMedallionTone.emerald,
    this.icon,
    this.iconWidget,
    this.size = 136,
  });

  final MosaicMedallionTone tone;
  final MosaicIconKind? icon;
  final Widget? iconWidget;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = _colors(tone);
    return SizedBox.square(
      dimension: size,
      child: MosaicDashedBorder(
        color: colors.stroke,
        strokeWidth: MosaicBorder.emphasis,
        radius: size / 2,
        dashPattern: MosaicDash.medallion,
        child: Center(
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.fill,
              border: Border.all(color: colors.stroke, width: 3),
            ),
            alignment: Alignment.center,
            child:
                iconWidget ??
                (icon == null
                    ? MosaicStar(
                        size: 28,
                        color: colors.stroke,
                        filled: true,
                        strokeWidth: 1,
                      )
                    : MosaicIcon(icon!, size: 28, color: colors.stroke)),
          ),
        ),
      ),
    );
  }

  static _MedallionColors _colors(MosaicMedallionTone tone) {
    return switch (tone) {
      MosaicMedallionTone.emerald => const _MedallionColors(
        fill: MosaicColors.mint100,
        stroke: MosaicColors.emerald600,
      ),
      MosaicMedallionTone.saffron => const _MedallionColors(
        fill: MosaicColors.saffron100,
        stroke: MosaicColors.saffron500,
      ),
      MosaicMedallionTone.terracotta => const _MedallionColors(
        fill: MosaicColors.terracotta100,
        stroke: MosaicColors.terracotta600,
      ),
      MosaicMedallionTone.lapis => const _MedallionColors(
        fill: MosaicColors.lapis100,
        stroke: MosaicColors.lapis700,
      ),
      MosaicMedallionTone.danger => const _MedallionColors(
        fill: MosaicColors.danger100,
        stroke: MosaicColors.danger700,
      ),
    };
  }
}

class _MedallionColors {
  const _MedallionColors({required this.fill, required this.stroke});

  final Color fill;
  final Color stroke;
}
