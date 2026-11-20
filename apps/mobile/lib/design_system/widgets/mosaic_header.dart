import 'package:flutter/material.dart';
import 'package:mobile/design_system/mosaic_theme.dart';
import 'package:mobile/design_system/mosaic_tokens.dart';
import 'package:mobile/design_system/widgets/mosaic_icon.dart';
import 'package:mobile/design_system/widgets/mosaic_pressable.dart';

/// Screen header: back pill on the start, centered title, trailing slot.
class MosaicHeader extends StatelessWidget {
  const MosaicHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showSubtitle = true,
    this.backLabel = 'رجوع',
    this.onBack,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final bool showSubtitle;
  final String backLabel;
  final VoidCallback? onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final text = MosaicTheme.of(context).text;
    final caption = showSubtitle ? subtitle : null;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 8),
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            MosaicPressable(
              onPressed: onBack,
              semanticsLabel: backLabel,
              borderRadius: BorderRadius.circular(MosaicRadii.pill),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: MosaicColors.paper,
                  borderRadius: BorderRadius.circular(MosaicRadii.pill),
                  border: Border.all(color: MosaicColors.line),
                ),
                child: SizedBox(
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const MosaicIcon(MosaicIconKind.back, size: 18),
                        const SizedBox(width: MosaicSpacing.s6),
                        Text(backLabel, style: text.labelM),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: text.titleM,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  if (caption != null && caption.isNotEmpty)
                    Text(
                      caption,
                      style: text.labelS,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
            trailing ?? const SizedBox(width: 84),
          ],
        ),
      ),
    );
  }
}
