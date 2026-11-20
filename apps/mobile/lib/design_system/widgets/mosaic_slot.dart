import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mobile/design_system/arabic_digits.dart';
import 'package:mobile/design_system/mosaic_theme.dart';
import 'package:mobile/design_system/mosaic_tokens.dart';
import 'package:mobile/design_system/widgets/mosaic_dashed_border.dart';
import 'package:mobile/design_system/widgets/mosaic_star.dart';

/// Association slot state. Each state has a non-color cue.
enum MosaicSlotState { empty, active, dropTarget, completed }

/// 10px progress pip. Filled pips are the first children so they sit on the
/// right under RTL.
class MosaicPip extends StatelessWidget {
  const MosaicPip({super.key, required this.filled});

  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MosaicSizes.pip,
      height: MosaicSizes.pip,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? MosaicColors.saffron500 : Colors.transparent,
        border: Border.all(
          color: filled ? MosaicColors.saffron500 : MosaicColors.line,
          width: MosaicBorder.normal,
        ),
      ),
    );
  }
}

/// Association slot.
///
/// [filled] and [total] drive the pip row and the `٢/٤` chip. Pass [width]
/// as `double.infinity` inside a bounded parent to stretch the slot.
/// A drop target previews one extra filled pip.
class MosaicSlot extends StatelessWidget {
  const MosaicSlot({
    super.key,
    required this.state,
    this.clue = '',
    this.filled = 0,
    this.total = 4,
    this.members = const <String>[],
    this.width = MosaicSizes.slotWidth,
    this.emptyTitle = 'خانة فارغة',
    this.emptyHint = 'اسحب بطاقة مجموعة هنا',
    this.completedTitle = 'اكتملت المجموعة!',
  });

  final MosaicSlotState state;
  final String clue;
  final int filled;
  final int total;
  final List<String> members;
  final double width;
  final String emptyTitle;
  final String emptyHint;
  final String completedTitle;

  @override
  Widget build(BuildContext context) {
    final text = MosaicTheme.of(context).text;
    final chrome = _chrome();
    final shown = state == MosaicSlotState.dropTarget
        ? math.min(total, filled + 1)
        : math.min(total, filled);

    final column = Padding(
      padding: const EdgeInsets.all(MosaicSpacing.s8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: MosaicSpacing.s6,
        children: switch (state) {
          MosaicSlotState.empty => [
            const MosaicStar(
              size: 26,
              color: MosaicColors.saffron500,
              strokeWidth: 1.5,
            ),
            Text(
              emptyTitle,
              style: text.labelM,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              emptyHint,
              style: text.labelS,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          MosaicSlotState.active || MosaicSlotState.dropTarget => [
            _Header(clue: clue, filled: filled, total: total),
            if (total > 0) _Pips(filled: shown, total: total),
            if (members.isNotEmpty)
              Text(
                ArabicDigits.joinWords(members),
                style: state == MosaicSlotState.dropTarget
                    ? text.labelM.copyWith(color: MosaicColors.emerald600)
                    : text.bodyS,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
          MosaicSlotState.completed => [
            const MosaicStar(
              size: 30,
              color: MosaicColors.saffron500,
              filled: true,
              strokeWidth: 1,
            ),
            Text(
              completedTitle,
              style: text.titleS.copyWith(color: MosaicColors.success700),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              ArabicDigits.dashJoin([
                ArabicDigits.progress(filled, total),
                'تُزال من اللوحة',
              ]),
              style: text.labelS,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        },
      ),
    );

    final decorated = DecoratedBox(
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
              dashPattern: MosaicDash.slotEmpty,
              child: column,
            )
          : column,
    );

    return SizedBox(
      width: width,
      height: MosaicSizes.slotHeight,
      child: decorated,
    );
  }

  _SlotChrome _chrome() {
    return switch (state) {
      MosaicSlotState.empty => const _SlotChrome(
        fill: MosaicColors.plaster,
        stroke: MosaicColors.emerald600,
        strokeWidth: MosaicBorder.normal,
        dashed: true,
      ),
      MosaicSlotState.active => const _SlotChrome(
        fill: MosaicColors.paper,
        stroke: MosaicColors.lapis700,
        strokeWidth: MosaicBorder.emphasis,
        shadow: MosaicShadows.card,
      ),
      MosaicSlotState.dropTarget => const _SlotChrome(
        fill: MosaicColors.mint100,
        stroke: MosaicColors.emerald600,
        strokeWidth: MosaicBorder.dropTarget,
        dashed: true,
      ),
      MosaicSlotState.completed => const _SlotChrome(
        fill: MosaicColors.saffron100,
        stroke: MosaicColors.success700,
        strokeWidth: MosaicBorder.emphasis,
      ),
    };
  }
}

class _SlotChrome {
  const _SlotChrome({
    required this.fill,
    required this.stroke,
    required this.strokeWidth,
    this.dashed = false,
    this.shadow,
  });

  final Color fill;
  final Color stroke;
  final double strokeWidth;
  final bool dashed;
  final List<BoxShadow>? shadow;
}

class _Header extends StatelessWidget {
  const _Header({
    required this.clue,
    required this.filled,
    required this.total,
  });

  final String clue;
  final int filled;
  final int total;

  @override
  Widget build(BuildContext context) {
    final text = MosaicTheme.of(context).text;
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: MosaicColors.lapis700,
        borderRadius: BorderRadius.circular(MosaicRadii.sm),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              clue,
              style: text.cardClue,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: MosaicSpacing.s6),
          DecoratedBox(
            decoration: BoxDecoration(
              color: MosaicColors.saffron500,
              borderRadius: BorderRadius.circular(MosaicRadii.pill),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                ArabicDigits.progress(filled, total),
                style: text.labelM.copyWith(color: MosaicColors.emerald900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pips extends StatelessWidget {
  const _Pips({required this.filled, required this.total});

  final int filled;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < total; i++) ...[
          if (i > 0) const SizedBox(width: MosaicSpacing.s6),
          MosaicPip(filled: i < filled),
        ],
      ],
    );
  }
}
