import 'package:flutter/material.dart';
import 'package:mobile/design_system/arabic_digits.dart';
import 'package:mobile/design_system/mosaic_theme.dart';
import 'package:mobile/design_system/mosaic_tokens.dart';
import 'package:mobile/design_system/widgets/mosaic_icon.dart';
import 'package:mobile/design_system/widgets/mosaic_pressable.dart';

/// Board tool: icon, label, optional count badge on the start corner.
///
/// A null [onPressed] is disabled (opacity 0.45). The badge number is the
/// non-color cue for a counted tool such as hints.
class MosaicToolButton extends StatelessWidget {
  const MosaicToolButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.badge,
    this.showBadge = false,
  });

  final MosaicIconKind icon;
  final String label;
  final VoidCallback? onPressed;
  final int? badge;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    final text = MosaicTheme.of(context).text;
    final showCount = showBadge && badge != null;
    return MosaicPressable(
      onPressed: onPressed,
      semanticsLabel: showCount
          ? '$label ${ArabicDigits.format(badge!)}'
          : label,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: MosaicColors.paper,
          borderRadius: BorderRadius.circular(MosaicRadii.md),
          border: Border.all(color: MosaicColors.line),
        ),
        child: SizedBox(
          height: 64,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MosaicIcon(icon, size: 22),
                    const SizedBox(height: MosaicSpacing.s4),
                    Text(label, style: text.labelM),
                  ],
                ),
              ),
              if (showCount)
                PositionedDirectional(
                  top: -6,
                  start: -4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: MosaicColors.terracotta600,
                      borderRadius: BorderRadius.circular(MosaicRadii.pill),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 1,
                      ),
                      child: Text(
                        ArabicDigits.format(badge!),
                        style: text.labelM.copyWith(color: MosaicColors.onDark),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
