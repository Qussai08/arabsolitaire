import 'package:flutter/material.dart';
import 'package:mobile/design_system/mosaic_theme.dart';
import 'package:mobile/design_system/mosaic_tokens.dart';
import 'package:mobile/design_system/mosaic_typography.dart';
import 'package:mobile/design_system/widgets/mosaic_dashed_border.dart';
import 'package:mobile/design_system/widgets/mosaic_star.dart';

/// Visual state of a tableau card.
///
/// Every state has a cue other than color: a pattern, a word, a kicker,
/// or a badge glyph.
enum MosaicCardState {
  faceDown,
  word,
  clue,
  selected,
  validTarget,
  invalid,
  completed,
  disabled,
}

/// 72×96 card with a mihrab arch.
///
/// [countLabel] is caller-supplied copy such as `٤ كلمات`. The widget does
/// not pluralize. Badges sit on the start corner (the right side in RTL),
/// matching the component sheet.
class MosaicCard extends StatelessWidget {
  const MosaicCard({
    super.key,
    required this.state,
    this.word,
    this.clue,
    this.countLabel,
  });

  final MosaicCardState state;
  final String? word;
  final String? clue;
  final String? countLabel;

  @override
  Widget build(BuildContext context) {
    final text = MosaicTheme.of(context).text;
    final chrome = _chrome();
    final arch = Padding(
      padding: EdgeInsets.all(MosaicSizes.cardPadding + chrome.strokeWidth),
      child: _Arch(
        stroke: chrome.archStroke,
        fill: chrome.archFill,
        child: _content(text, chrome),
      ),
    );

    final body = DecoratedBox(
      decoration: BoxDecoration(
        color: chrome.fill,
        borderRadius: BorderRadius.circular(MosaicRadii.md),
        border: chrome.dashed
            ? null
            : Border.all(color: chrome.stroke, width: chrome.strokeWidth),
        boxShadow: chrome.shadow,
      ),
      child: chrome.dashed
          ? MosaicDashedBorder(
              color: chrome.stroke,
              strokeWidth: chrome.strokeWidth,
              radius: MosaicRadii.md,
              dashPattern: MosaicDash.validTarget,
              child: arch,
            )
          : arch,
    );

    Widget card = SizedBox(
      width: MosaicSizes.cardWidth,
      height: MosaicSizes.cardHeight,
      child: body,
    );

    if (chrome.badge != null) {
      card = Stack(
        clipBehavior: Clip.none,
        children: [
          card,
          PositionedDirectional(
            top: -8,
            start: -8,
            child: _Badge(kind: chrome.badge!),
          ),
        ],
      );
    } else {
      card = Stack(clipBehavior: Clip.none, children: [card]);
    }

    if (state == MosaicCardState.disabled) {
      card = Opacity(opacity: MosaicOpacity.disabled, child: card);
    }

    if (state == MosaicCardState.faceDown) {
      card = Semantics(label: 'بطاقة مقلوبة', child: card);
    }

    return card;
  }

  Widget _content(MosaicTextStyles text, _CardChrome chrome) {
    final body = switch (state) {
      MosaicCardState.faceDown => const Center(
        child: MosaicStar(
          size: 28,
          color: MosaicColors.saffron500,
          strokeWidth: 1.5,
        ),
      ),
      MosaicCardState.clue => Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 3,
        children: [
          Text(
            'مجموعة',
            style: text.labelS.copyWith(color: MosaicColors.saffron100),
          ),
          Text(
            clue ?? '',
            style: text.cardClue,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (countLabel != null)
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const MosaicStar(
                    size: 10,
                    color: MosaicColors.saffron500,
                    filled: true,
                    strokeWidth: 1,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    countLabel!,
                    style: text.labelS.copyWith(color: MosaicColors.onDark),
                  ),
                ],
              ),
            ),
        ],
      ),
      _ => Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 3,
        children: [
          MosaicStar(
            size: 10,
            color: chrome.star,
            filled: state == MosaicCardState.selected,
            strokeWidth: 1,
          ),
          Text(
            word ?? '',
            style: text.cardWord.copyWith(color: chrome.wordColor),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    };
    if (state == MosaicCardState.faceDown) {
      return body;
    }
    // Wrap at the arch's content width, then scale down only if a long clue
    // or a large text scale still overflows the fixed 72×96 card.
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth.isFinite ? maxWidth : MosaicSizes.cardWidth,
            ),
            child: body,
          ),
        );
      },
    );
  }

  _CardChrome _chrome() {
    return switch (state) {
      MosaicCardState.faceDown => const _CardChrome(
        fill: MosaicColors.emerald600,
        stroke: MosaicColors.emerald900,
        strokeWidth: MosaicBorder.hairline,
        archStroke: MosaicColors.saffron500,
        shadow: MosaicShadows.card,
        star: MosaicColors.saffron500,
        wordColor: MosaicColors.textPrimary,
      ),
      MosaicCardState.word || MosaicCardState.disabled => const _CardChrome(
        fill: MosaicColors.paper,
        stroke: MosaicColors.line,
        strokeWidth: MosaicBorder.hairline,
        archStroke: MosaicColors.line,
        shadow: MosaicShadows.card,
        star: MosaicColors.saffron500,
        wordColor: MosaicColors.textPrimary,
      ),
      MosaicCardState.clue => const _CardChrome(
        fill: MosaicColors.lapis700,
        stroke: MosaicColors.emerald900,
        strokeWidth: MosaicBorder.hairline,
        archStroke: MosaicColors.saffron500,
        shadow: MosaicShadows.card,
        star: MosaicColors.saffron500,
        wordColor: MosaicColors.onDark,
      ),
      MosaicCardState.selected => const _CardChrome(
        fill: MosaicColors.paper,
        stroke: MosaicColors.saffron500,
        strokeWidth: MosaicBorder.selected,
        archStroke: MosaicColors.saffron500,
        archFill: MosaicColors.saffron100,
        shadow: MosaicShadows.selectedGlow,
        badge: _BadgeKind.selected,
        star: MosaicColors.saffron500,
        wordColor: MosaicColors.textPrimary,
      ),
      MosaicCardState.validTarget => const _CardChrome(
        fill: MosaicColors.mint100,
        stroke: MosaicColors.emerald600,
        strokeWidth: MosaicBorder.emphasis,
        dashed: true,
        archStroke: MosaicColors.emerald600,
        shadow: MosaicShadows.card,
        badge: _BadgeKind.valid,
        star: MosaicColors.emerald600,
        wordColor: MosaicColors.textPrimary,
      ),
      MosaicCardState.invalid => const _CardChrome(
        fill: MosaicColors.danger100,
        stroke: MosaicColors.danger700,
        strokeWidth: MosaicBorder.emphasis,
        archStroke: MosaicColors.danger700,
        shadow: MosaicShadows.card,
        badge: _BadgeKind.invalid,
        star: MosaicColors.danger700,
        wordColor: MosaicColors.danger700,
      ),
      MosaicCardState.completed => const _CardChrome(
        fill: MosaicColors.mint100,
        stroke: MosaicColors.success700,
        strokeWidth: MosaicBorder.emphasis,
        archStroke: MosaicColors.success700,
        shadow: MosaicShadows.card,
        badge: _BadgeKind.completed,
        star: MosaicColors.success700,
        wordColor: MosaicColors.success700,
      ),
    };
  }
}

class _CardChrome {
  const _CardChrome({
    required this.fill,
    required this.stroke,
    required this.strokeWidth,
    required this.archStroke,
    required this.shadow,
    required this.star,
    required this.wordColor,
    this.archFill,
    this.dashed = false,
    this.badge,
  });

  final Color fill;
  final Color stroke;
  final double strokeWidth;
  final bool dashed;
  final Color archStroke;
  final Color? archFill;
  final List<BoxShadow> shadow;
  final _BadgeKind? badge;
  final Color star;
  final Color wordColor;
}

class _Arch extends StatelessWidget {
  const _Arch({required this.stroke, required this.child, this.fill});

  final Color stroke;
  final Color? fill;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(MosaicRadii.archTop),
          topRight: Radius.circular(MosaicRadii.archTop),
          bottomLeft: Radius.circular(MosaicRadii.archBottom),
          bottomRight: Radius.circular(MosaicRadii.archBottom),
        ),
        border: Border.all(color: stroke),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: child,
      ),
    );
  }
}

enum _BadgeKind { selected, valid, invalid, completed }

class _Badge extends StatelessWidget {
  const _Badge({required this.kind});

  final _BadgeKind kind;

  @override
  Widget build(BuildContext context) {
    final (color, label, icon) = switch (kind) {
      _BadgeKind.selected => (
        MosaicColors.saffron500,
        'محددة',
        const MosaicStar(
          size: 14,
          color: MosaicColors.onDark,
          filled: true,
          strokeWidth: 1,
        ),
      ),
      _BadgeKind.valid => (
        MosaicColors.emerald600,
        'هدف صالح',
        const Icon(Icons.add, size: 14, color: MosaicColors.onDark),
      ),
      _BadgeKind.invalid => (
        MosaicColors.danger700,
        'مرفوضة',
        const Icon(Icons.close, size: 14, color: MosaicColors.onDark),
      ),
      _BadgeKind.completed => (
        MosaicColors.success700,
        'مكتملة',
        const Icon(Icons.check, size: 14, color: MosaicColors.onDark),
      ),
    };

    return Semantics(
      label: label,
      child: ExcludeSemantics(
        child: Container(
          width: MosaicSizes.cardBadge,
          height: MosaicSizes.cardBadge,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: MosaicColors.paper, width: 2),
          ),
          alignment: Alignment.center,
          child: icon,
        ),
      ),
    );
  }
}
