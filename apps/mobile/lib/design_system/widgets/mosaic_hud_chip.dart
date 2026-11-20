import 'package:flutter/material.dart';
import 'package:mobile/design_system/arabic_digits.dart';
import 'package:mobile/design_system/mosaic_theme.dart';
import 'package:mobile/design_system/mosaic_tokens.dart';
import 'package:mobile/design_system/widgets/mosaic_star.dart';

/// Icon that identifies the stat. The glyph is the non-color cue.
enum MosaicHudIcon { coin, hint, flame }

/// Paper stat chip: icon on the start side, value, optional caption.
///
/// [MosaicHudChip.count] formats [amount] with Arabic-Indic digits.
/// With [showLabel] false the chip is the 38px top-bar variant.
class MosaicHudChip extends StatelessWidget {
  const MosaicHudChip({
    super.key,
    required this.icon,
    required this.value,
    this.label,
    this.showLabel = true,
    this.onPressed,
  });

  factory MosaicHudChip.count({
    Key? key,
    required MosaicHudIcon icon,
    required num amount,
    String? label,
    bool showLabel = true,
    VoidCallback? onPressed,
  }) {
    return MosaicHudChip(
      key: key,
      icon: icon,
      value: ArabicDigits.format(amount),
      label: label,
      showLabel: showLabel,
      onPressed: onPressed,
    );
  }

  final MosaicHudIcon icon;
  final String value;
  final String? label;
  final bool showLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final text = MosaicTheme.of(context).text;
    final caption = showLabel ? label : null;
    final chip = DecoratedBox(
      decoration: BoxDecoration(
        color: MosaicColors.paper,
        borderRadius: BorderRadius.circular(MosaicRadii.md),
        border: Border.all(color: MosaicColors.line),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 10, 6),
        child: SizedBox(
          height: caption == null
              ? MosaicSizes.hudHeightCompact - 12
              : MosaicSizes.hudHeight - 12,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _HudIcon(icon: icon),
              const SizedBox(width: MosaicSpacing.s6),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: text.titleS.copyWith(color: MosaicColors.emerald900),
                  ),
                  if (caption != null) Text(caption, style: text.labelS),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return Semantics(
      button: onPressed != null,
      label: caption == null ? value : '$value $caption',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: chip,
      ),
    );
  }
}

class _HudIcon extends StatelessWidget {
  const _HudIcon({required this.icon});

  final MosaicHudIcon icon;

  @override
  Widget build(BuildContext context) {
    return switch (icon) {
      MosaicHudIcon.coin => const MosaicCoinIcon(size: MosaicSizes.hudIcon),
      MosaicHudIcon.hint => const Icon(
        Icons.lightbulb_outline,
        size: MosaicSizes.hudIcon,
        color: MosaicColors.emerald900,
      ),
      MosaicHudIcon.flame => const Icon(
        Icons.local_fire_department_outlined,
        size: MosaicSizes.hudIcon,
        color: MosaicColors.emerald900,
      ),
    };
  }
}
