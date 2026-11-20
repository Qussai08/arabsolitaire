import 'package:flutter/material.dart';
import 'package:mobile/design_system/design_system.dart';

/// Level title, pause, and coin chip.
class GameplayTopBar extends StatelessWidget {
  const GameplayTopBar({
    super.key,
    required this.levelLabel,
    required this.chapterLabel,
    required this.onPause,
    this.coins,
  });

  final String levelLabel;
  final String chapterLabel;
  final VoidCallback onPause;
  final int? coins;

  @override
  Widget build(BuildContext context) {
    final text = MosaicTheme.of(context).text;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
      child: Row(
        children: [
          MosaicPressable(
            onPressed: onPause,
            semanticsLabel: 'إيقاف',
            borderRadius: BorderRadius.circular(MosaicRadii.pill),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: MosaicColors.paper,
                borderRadius: BorderRadius.circular(MosaicRadii.pill),
                border: Border.all(color: MosaicColors.line),
              ),
              child: const SizedBox(
                height: 40,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MosaicIcon(MosaicIconKind.pause, size: 18),
                      SizedBox(width: MosaicSpacing.s6),
                      Text('إيقاف'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  levelLabel,
                  style: text.titleS,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  chapterLabel,
                  style: text.labelS,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (coins != null)
            MosaicHudChip.count(
              icon: MosaicHudIcon.coin,
              amount: coins!,
              showLabel: false,
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }
}

/// Moves counter and streak meter.
class GameplayStats extends StatelessWidget {
  const GameplayStats({
    super.key,
    required this.movesRemaining,
    required this.moveLimit,
    required this.streakCurrent,
    required this.streakTarget,
  });

  final int movesRemaining;
  final int moveLimit;
  final int streakCurrent;
  final int streakTarget;

  @override
  Widget build(BuildContext context) {
    final text = MosaicTheme.of(context).text;
    final low = movesRemaining <= 5;
    final moves = ArabicDigits.progress(movesRemaining, moveLimit);
    final moveLabel = low ? '$moves حركة — قليلة' : '$moves حركة';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: MosaicColors.terracotta100,
                borderRadius: BorderRadius.circular(MosaicRadii.pill),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const MosaicIcon(
                      MosaicIconKind.flame,
                      size: 18,
                      color: MosaicColors.terracotta600,
                    ),
                    const SizedBox(width: MosaicSpacing.s6),
                    Expanded(
                      child: Text(
                        'السلسلة ${ArabicDigits.format(streakCurrent)} من ${ArabicDigits.format(streakTarget)}',
                        style: text.labelM,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '+${ArabicDigits.format(streakTarget)}',
                      style: text.labelM.copyWith(
                        color: MosaicColors.terracotta600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: MosaicSpacing.s8),
          DecoratedBox(
            decoration: BoxDecoration(
              color: MosaicColors.emerald900,
              borderRadius: BorderRadius.circular(MosaicRadii.pill),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    moveLabel,
                    style: text.labelM.copyWith(color: MosaicColors.onDark),
                  ),
                  const SizedBox(width: MosaicSpacing.s6),
                  const MosaicIcon(
                    MosaicIconKind.moves,
                    size: 16,
                    color: MosaicColors.onDark,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Hint, undo, restart, and a disabled report tool.
class GameplayBottomTools extends StatelessWidget {
  const GameplayBottomTools({
    super.key,
    required this.onHint,
    required this.onUndo,
    required this.onRestart,
    required this.canUndo,
    required this.hintLoading,
    this.hintCount,
  });

  final VoidCallback onHint;
  final VoidCallback onUndo;
  final VoidCallback onRestart;
  final bool canUndo;
  final bool hintLoading;
  final int? hintCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: MosaicToolButton(
              icon: hintLoading ? MosaicIconKind.restart : MosaicIconKind.hint,
              label: 'تلميح',
              badge: hintCount,
              showBadge: hintCount != null,
              onPressed: hintLoading ? null : onHint,
            ),
          ),
          const SizedBox(width: MosaicSpacing.s8),
          Expanded(
            child: MosaicToolButton(
              icon: MosaicIconKind.undo,
              label: 'تراجع',
              onPressed: canUndo ? onUndo : null,
            ),
          ),
          const SizedBox(width: MosaicSpacing.s8),
          Expanded(
            child: MosaicToolButton(
              icon: MosaicIconKind.restart,
              label: 'إعادة',
              onPressed: onRestart,
            ),
          ),
          const SizedBox(width: MosaicSpacing.s8),
          const Expanded(
            child: MosaicToolButton(icon: MosaicIconKind.flag, label: 'بلاغ'),
          ),
        ],
      ),
    );
  }
}

/// Phone column, or a side links panel once the window is tablet-wide.
class GameplayBoardLayout extends StatelessWidget {
  const GameplayBoardLayout({
    super.key,
    required this.header,
    required this.stats,
    required this.slots,
    required this.tableau,
    required this.stock,
    required this.tools,
    this.note,
  });

  final Widget header;
  final Widget stats;
  final Widget slots;
  final Widget tableau;
  final Widget stock;
  final Widget tools;
  final Widget? note;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= MosaicSizes.tabletWidth;
    final gutter = MosaicSpacing.gutterForWidth(
      MediaQuery.sizeOf(context).width,
    );
    final stockWell = DecoratedBox(
      decoration: BoxDecoration(
        color: MosaicColors.plaster,
        borderRadius: BorderRadius.circular(MosaicRadii.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: stock,
      ),
    );

    if (!wide) {
      return Column(
        children: [
          header,
          stats,
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: gutter),
              child: Column(
                children: [
                  slots,
                  const SizedBox(height: MosaicSpacing.s12),
                  tableau,
                  const SizedBox(height: MosaicSpacing.s12),
                  stockWell,
                  if (note != null) ...[
                    const SizedBox(height: MosaicSpacing.s12),
                    note!,
                  ],
                ],
              ),
            ),
          ),
          tools,
        ],
      );
    }

    return Column(
      children: [
        header,
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(gutter, 8, gutter, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      stats,
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              tableau,
                              const SizedBox(height: MosaicSpacing.s12),
                              stockWell,
                              if (note != null) ...[
                                const SizedBox(height: MosaicSpacing.s12),
                                note!,
                              ],
                            ],
                          ),
                        ),
                      ),
                      tools,
                    ],
                  ),
                ),
                const SizedBox(width: MosaicSpacing.s16),
                SizedBox(
                  width: 200,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: MosaicColors.paper,
                      borderRadius: BorderRadius.circular(MosaicRadii.lg),
                      border: Border.all(color: MosaicColors.line),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(MosaicSpacing.s16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'الروابط المفتوحة',
                            style: MosaicTheme.of(context).text.titleS,
                          ),
                          const SizedBox(height: MosaicSpacing.s12),
                          Expanded(child: SingleChildScrollView(child: slots)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> showGameplayPauseSheet({
  required BuildContext context,
  required VoidCallback onRestart,
  required VoidCallback onExit,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: MosaicColors.paper,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(MosaicRadii.lg),
            ),
            boxShadow: MosaicShadows.sheet,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: MosaicColors.line,
                    borderRadius: BorderRadius.circular(MosaicRadii.pill),
                  ),
                ),
                const SizedBox(height: MosaicSpacing.s16),
                Text(
                  'إيقاف',
                  style: MosaicTheme.of(sheetContext).text.displayL,
                ),
                const SizedBox(height: MosaicSpacing.s16),
                MosaicButton(
                  label: 'متابعة',
                  expanded: true,
                  onPressed: () => Navigator.of(sheetContext).pop(),
                ),
                const SizedBox(height: MosaicSpacing.s8),
                MosaicButton(
                  label: 'إعادة المستوى',
                  kind: MosaicButtonKind.secondary,
                  expanded: true,
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    onRestart();
                  },
                ),
                const SizedBox(height: MosaicSpacing.s8),
                MosaicButton(
                  label: 'الخروج',
                  kind: MosaicButtonKind.ghost,
                  expanded: true,
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    onExit();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
