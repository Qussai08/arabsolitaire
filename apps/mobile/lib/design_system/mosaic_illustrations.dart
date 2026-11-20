import 'package:flutter/material.dart';
import 'package:mobile/design_system/mosaic_tokens.dart';

/// Illustration assets from the فسيفساء handoff.
///
/// Arch crops use a semicircular top and a 14px bottom radius.
abstract final class MosaicIllustrations {
  static const heroShiboub =
      'assets/illustrations/illustration-hero-shiboub.png';
  static const cairoChapter =
      'assets/illustrations/illustration-cairo-chapter.png';
  static const win = 'assets/illustrations/illustration-win.png';
  static const dailyGift = 'assets/illustrations/illustration-daily-gift.png';
  static const shiboubPortrait = 'assets/illustrations/shiboub-portrait.png';

  static const all = <String>[
    heroShiboub,
    cairoChapter,
    win,
    dailyGift,
    shiboubPortrait,
  ];
}

class MosaicArchImage extends StatelessWidget {
  const MosaicArchImage({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String asset;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final resolvedWidth =
            width ??
            (constraints.hasBoundedWidth ? constraints.maxWidth : null);
        final topRadius = resolvedWidth == null || !resolvedWidth.isFinite
            ? MosaicRadii.md
            : resolvedWidth / 2;
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topRadius),
            topRight: Radius.circular(topRadius),
            bottomLeft: const Radius.circular(MosaicRadii.md),
            bottomRight: const Radius.circular(MosaicRadii.md),
          ),
          child: Image.asset(asset, width: width, height: height, fit: fit),
        );
      },
    );
  }
}
