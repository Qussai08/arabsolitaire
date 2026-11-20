import 'package:flutter/material.dart';
import 'package:mobile/design_system/mosaic_theme.dart';
import 'package:mobile/design_system/mosaic_tokens.dart';
import 'package:mobile/design_system/widgets/mosaic_icon.dart';

/// Tone of a toast. The icon is the non-color cue.
enum MosaicToastTone { info, success, error, hint }

/// Inline notice: badge, optional title, and message.
class MosaicToast extends StatelessWidget {
  const MosaicToast({
    super.key,
    required this.message,
    this.title,
    this.showTitle = true,
    this.tone = MosaicToastTone.info,
    this.icon,
  });

  final String message;
  final String? title;
  final bool showTitle;
  final MosaicToastTone tone;
  final MosaicIconKind? icon;

  @override
  Widget build(BuildContext context) {
    final text = MosaicTheme.of(context).text;
    final colors = _colors(tone);
    final glyph = icon ?? _defaultIcon(tone);
    final heading = showTitle ? title : null;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.fill,
        borderRadius: BorderRadius.circular(MosaicRadii.md),
        border: Border.all(color: colors.accent),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 14, 12),
        child: Row(
          children: [
            DecoratedBox(
              decoration: const BoxDecoration(
                color: MosaicColors.paper,
                shape: BoxShape.circle,
              ),
              child: SizedBox.square(
                dimension: 28,
                child: Center(
                  child: MosaicIcon(glyph, size: 16, color: colors.accent),
                ),
              ),
            ),
            const SizedBox(width: MosaicSpacing.s8 + 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (heading != null && heading.isNotEmpty)
                    Text(
                      heading,
                      style: text.titleS.copyWith(color: colors.accent),
                    ),
                  Text(message, style: text.bodyS),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static MosaicIconKind _defaultIcon(MosaicToastTone tone) {
    return switch (tone) {
      MosaicToastTone.info => MosaicIconKind.restart,
      MosaicToastTone.success => MosaicIconKind.check,
      MosaicToastTone.error => MosaicIconKind.close,
      MosaicToastTone.hint => MosaicIconKind.hint,
    };
  }

  static _ToastColors _colors(MosaicToastTone tone) {
    return switch (tone) {
      MosaicToastTone.info => const _ToastColors(
        fill: MosaicColors.lapis100,
        accent: MosaicColors.lapis700,
      ),
      MosaicToastTone.success => const _ToastColors(
        fill: MosaicColors.mint100,
        accent: MosaicColors.success700,
      ),
      MosaicToastTone.error => const _ToastColors(
        fill: MosaicColors.danger100,
        accent: MosaicColors.danger700,
      ),
      MosaicToastTone.hint => const _ToastColors(
        fill: MosaicColors.saffron100,
        accent: MosaicColors.emerald900,
      ),
    };
  }
}

class _ToastColors {
  const _ToastColors({required this.fill, required this.accent});

  final Color fill;
  final Color accent;
}
