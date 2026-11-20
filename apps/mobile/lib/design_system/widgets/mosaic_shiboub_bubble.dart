import 'package:flutter/material.dart';
import 'package:mobile/design_system/mosaic_illustrations.dart';
import 'package:mobile/design_system/mosaic_theme.dart';
import 'package:mobile/design_system/mosaic_tokens.dart';

/// Shiboub portrait in a saffron ring.
class MosaicShiboubAvatar extends StatelessWidget {
  const MosaicShiboubAvatar({super.key, this.size = 52});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: MosaicColors.saffron500, width: 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          MosaicIllustrations.shiboubPortrait,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const ColoredBox(color: MosaicColors.saffron100),
        ),
      ),
    );
  }
}

/// Speech bubble with the portrait on the start side (right in RTL).
///
/// The tail is the physical bottom-right corner, next to the avatar.
class MosaicShiboubBubble extends StatelessWidget {
  const MosaicShiboubBubble({
    super.key,
    required this.line,
    this.speaker = 'شيبوب',
  });

  final String line;
  final String speaker;

  @override
  Widget build(BuildContext context) {
    final text = MosaicTheme.of(context).text;
    return Row(
      children: [
        const MosaicShiboubAvatar(),
        const SizedBox(width: MosaicSpacing.s8 + 2),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: MosaicColors.paper,
              borderRadius: MosaicRadii.bubble,
              border: Border.all(color: MosaicColors.line),
              boxShadow: MosaicShadows.card,
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(14, 10, 14, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    speaker,
                    style: text.labelS.copyWith(
                      color: MosaicColors.terracotta600,
                    ),
                  ),
                  Text(line, style: text.bodyS),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
