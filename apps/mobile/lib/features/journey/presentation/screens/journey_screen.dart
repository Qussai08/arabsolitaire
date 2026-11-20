import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/app/navigation/app_router.dart';
import 'package:mobile/design_system/design_system.dart';
import 'package:mobile/features/economy/application/wallet_controller.dart';
import 'package:mobile/features/gameplay/application/gameplay_providers.dart';
import 'package:mobile/features/journey/application/journey_providers.dart';
import 'package:mobile/features/journey/domain/journey_models.dart';
import 'package:mobile/features/journey/presentation/screens/story_beat_screen.dart';

/// Chapter path. Tapping an unlocked level still opens that level.
class JourneyScreen extends ConsumerWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeyState = ref.watch(journeyControllerProvider);
    return switch (journeyState) {
      JourneyLoading() => const Scaffold(
        backgroundColor: MosaicColors.limestone,
        body: Center(
          child: CircularProgressIndicator(color: MosaicColors.emerald600),
        ),
      ),
      JourneyError(:final message) => Scaffold(
        backgroundColor: MosaicColors.limestone,
        body: Center(child: Text(message)),
      ),
      JourneyReady() => _JourneyReady(state: journeyState),
    };
  }
}

class _JourneyReady extends ConsumerWidget {
  const _JourneyReady({required this.state});

  final JourneyReady state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletControllerProvider);
    final coins = wallet is WalletReady
        ? wallet.snapshot.effectiveCoinBalance
        : null;
    final current = _currentLevel();
    final gutter = MosaicSpacing.gutterForWidth(
      MediaQuery.sizeOf(context).width,
    );
    final chapters = state.chapters.toList()
      ..sort((a, b) => b.order.compareTo(a.order));

    return Scaffold(
      backgroundColor: MosaicColors.limestone,
      body: SafeArea(
        child: Column(
          children: [
            MosaicHeader(
              title: 'الرحلة',
              subtitle: 'الموسم ١: صحوة الروابط',
              backLabel: 'الرئيسية',
              onBack: () => Navigator.of(context).maybePop(),
              trailing: coins == null
                  ? null
                  : MosaicHudChip.count(
                      icon: MosaicHudIcon.coin,
                      amount: coins,
                      showLabel: false,
                    ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(gutter, 0, gutter, 12),
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: MosaicColors.saffron100,
                      borderRadius: BorderRadius.circular(MosaicRadii.lg),
                      border: Border.all(color: MosaicColors.saffron500),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          for (var i = 0; i < chapters.length; i++) ...[
                            _ChapterRow(
                              chapter: chapters[i],
                              chapterState: state.chapterState(chapters[i]),
                              levels: state.levels
                                  .where(
                                    (level) =>
                                        level.chapterId ==
                                        chapters[i].chapterId,
                                  )
                                  .toList(),
                              state: state,
                              nodeFirst: chapters[i].order.isOdd,
                              onLevelTap: (level) =>
                                  _onLevelTap(context, ref, state, level),
                            ),
                            if (i != chapters.length - 1)
                              const SizedBox(height: MosaicSpacing.s12),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: MosaicSpacing.s12),
                  const _Legend(),
                ],
              ),
            ),
            if (current != null)
              Padding(
                padding: EdgeInsets.fromLTRB(gutter, 0, gutter, 16),
                child: MosaicButton(
                  label:
                      'العب المستوى ${ArabicDigits.format(current.globalLevelNumber)}',
                  expanded: true,
                  onPressed: () => _onLevelTap(context, ref, state, current),
                ),
              ),
          ],
        ),
      ),
    );
  }

  LevelDefinition? _currentLevel() {
    for (final level in state.levels) {
      if (level.globalLevelNumber == state.progress.highestUnlockedLevel) {
        return level;
      }
    }
    return null;
  }

  void _onLevelTap(
    BuildContext context,
    WidgetRef ref,
    JourneyReady state,
    LevelDefinition level,
  ) {
    ref.read(currentPlayingLevelProvider.notifier).state = level;
    final pendingBeats = state.pendingBeatsFor(level.globalLevelNumber);
    if (pendingBeats.isNotEmpty) {
      Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => StoryBeatScreen(
            beat: pendingBeats.first,
            onDismiss: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(AppRoutes.gameplay);
            },
          ),
        ),
      );
    } else {
      Navigator.of(context).pushNamed(AppRoutes.gameplay);
    }
  }
}

class _ChapterRow extends StatelessWidget {
  const _ChapterRow({
    required this.chapter,
    required this.chapterState,
    required this.levels,
    required this.state,
    required this.nodeFirst,
    required this.onLevelTap,
  });

  final ChapterDefinition chapter;
  final ChapterState chapterState;
  final List<LevelDefinition> levels;
  final JourneyReady state;
  final bool nodeFirst;
  final void Function(LevelDefinition level) onLevelTap;

  @override
  Widget build(BuildContext context) {
    final node = MosaicLevelNode(
      state: switch (chapterState) {
        ChapterState.completed => MosaicLevelNodeState.done,
        ChapterState.locked => MosaicLevelNodeState.locked,
        ChapterState.unlocked ||
        ChapterState.inProgress => MosaicLevelNodeState.current,
      },
      number: chapter.order,
      caption: switch (chapterState) {
        ChapterState.completed => 'مكتملة',
        ChapterState.locked => 'مقفلة',
        ChapterState.unlocked || ChapterState.inProgress => 'جارية',
      },
    );
    final card = Expanded(
      child: _ChapterCard(
        chapter: chapter,
        chapterState: chapterState,
        levels: levels,
        state: state,
        onLevelTap: onLevelTap,
      ),
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: nodeFirst
          ? [node, const SizedBox(width: MosaicSpacing.s8), card]
          : [card, const SizedBox(width: MosaicSpacing.s8), node],
    );
  }
}

class _ChapterCard extends StatelessWidget {
  const _ChapterCard({
    required this.chapter,
    required this.chapterState,
    required this.levels,
    required this.state,
    required this.onLevelTap,
  });

  final ChapterDefinition chapter;
  final ChapterState chapterState;
  final List<LevelDefinition> levels;
  final JourneyReady state;
  final void Function(LevelDefinition level) onLevelTap;

  @override
  Widget build(BuildContext context) {
    final text = MosaicTheme.of(context).text;
    final locked = chapterState == ChapterState.locked;
    final completed = levels
        .where((level) => state.levelStatus(level) == LevelStatus.completed)
        .length;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: locked ? MosaicColors.plaster : MosaicColors.paper,
        borderRadius: BorderRadius.circular(MosaicRadii.md),
        border: Border.all(
          color: chapterState == ChapterState.completed
              ? MosaicColors.success700
              : MosaicColors.line,
          width: chapterState == ChapterState.completed
              ? MosaicBorder.emphasis
              : MosaicBorder.hairline,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الفصل ${ArabicDigits.format(chapter.order)} — المستويات ${ArabicDigits.format(chapter.levelStart)}–${ArabicDigits.format(chapter.levelEnd)}',
              style: text.labelS,
            ),
            Text(chapter.titleAr, style: text.titleS),
            Text(locked ? 'مقفلة' : chapter.subtitleAr, style: text.labelS),
            if (!locked) ...[
              const SizedBox(height: MosaicSpacing.s8),
              ClipRRect(
                borderRadius: BorderRadius.circular(MosaicRadii.pill),
                child: LinearProgressIndicator(
                  value: levels.isEmpty ? 0 : completed / levels.length,
                  minHeight: 6,
                  backgroundColor: MosaicColors.plaster,
                  color: MosaicColors.terracotta600,
                ),
              ),
              const SizedBox(height: MosaicSpacing.s4),
              Text(
                ArabicDigits.progress(completed, levels.length),
                style: text.labelS,
              ),
              const SizedBox(height: MosaicSpacing.s8),
              _LevelGrid(levels: levels, state: state, onTap: onLevelTap),
            ],
          ],
        ),
      ),
    );
  }
}

class _LevelGrid extends StatelessWidget {
  const _LevelGrid({
    required this.levels,
    required this.state,
    required this.onTap,
  });

  final List<LevelDefinition> levels;
  final JourneyReady state;
  final void Function(LevelDefinition level) onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 10,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: levels.length,
      itemBuilder: (context, index) {
        final level = levels[index];
        final status = state.levelStatus(level);
        return _LevelCell(
          status: status,
          number: level.chapterLevelNumber,
          onTap: status == LevelStatus.locked ? null : () => onTap(level),
        );
      },
    );
  }
}

class _LevelCell extends StatelessWidget {
  const _LevelCell({
    required this.status,
    required this.number,
    required this.onTap,
  });

  final LevelStatus status;
  final int number;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final locked = status == LevelStatus.locked;
    final done = status == LevelStatus.completed;
    final current =
        status == LevelStatus.inProgress || status == LevelStatus.unlocked;
    final label = done
        ? 'مكتمل ${ArabicDigits.format(number)}'
        : locked
        ? 'مقفل'
        : ArabicDigits.format(number);
    return Semantics(
      button: onTap != null,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: done
                ? MosaicColors.mint100
                : current
                ? MosaicColors.paper
                : MosaicColors.plaster,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: status == LevelStatus.inProgress
                  ? MosaicColors.saffron500
                  : done
                  ? MosaicColors.emerald600
                  : MosaicColors.line,
              width: status == LevelStatus.inProgress ? 2 : 1,
            ),
          ),
          child: Center(
            child: locked
                ? const MosaicIcon(
                    MosaicIconKind.lock,
                    size: 12,
                    color: MosaicColors.textMuted,
                  )
                : done
                ? const MosaicIcon(
                    MosaicIconKind.check,
                    size: 12,
                    color: MosaicColors.success700,
                  )
                : Text(
                    ArabicDigits.format(number),
                    style: const TextStyle(
                      fontFamily: MosaicFonts.readexPro,
                      fontSize: 9,
                      color: MosaicColors.emerald900,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final text = MosaicTheme.of(context).text.labelS;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MosaicIcon(
              MosaicIconKind.check,
              size: 14,
              color: MosaicColors.success700,
            ),
            const SizedBox(width: 4),
            Text('مكتملة', style: text),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MosaicIcon(
              MosaicIconKind.flame,
              size: 14,
              color: MosaicColors.terracotta600,
            ),
            const SizedBox(width: 4),
            Text('جارية', style: text),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MosaicIcon(
              MosaicIconKind.lock,
              size: 14,
              color: MosaicColors.textMuted,
            ),
            const SizedBox(width: 4),
            Text('مقفلة', style: text),
          ],
        ),
      ],
    );
  }
}
