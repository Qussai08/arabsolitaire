import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/app/navigation/app_router.dart';
import 'package:mobile/design_system/design_system.dart';
import 'package:mobile/features/economy/application/wallet_controller.dart';
import 'package:mobile/features/gameplay/application/gameplay_providers.dart';
import 'package:mobile/features/gameplay/data/level_content_factory.dart';
import 'package:mobile/features/journey/application/journey_providers.dart';
import 'package:mobile/features/journey/domain/journey_models.dart';

/// Primary hub. Continue, journey, story archive, and settings stay wired
/// to the existing routes. Shop and daily reward have no screens yet.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeyState = ref.watch(journeyControllerProvider);
    final wallet = ref.watch(walletControllerProvider);
    final readyWallet = wallet is WalletReady ? wallet.snapshot : null;
    final gutter = MosaicSpacing.gutterForWidth(
      MediaQuery.sizeOf(context).width,
    );

    return Scaffold(
      backgroundColor: MosaicColors.limestone,
      body: SafeArea(
        child: switch (journeyState) {
          JourneyReady() => _HomeBody(
            state: journeyState,
            coins: readyWallet?.effectiveCoinBalance,
            hints: readyWallet?.effectiveHintBalance,
            gutter: gutter,
          ),
          JourneyError(:final message) => Center(child: Text(message)),
          JourneyLoading() => const Center(
            child: CircularProgressIndicator(color: MosaicColors.emerald600),
          ),
        },
      ),
    );
  }
}

class _HomeBody extends ConsumerWidget {
  const _HomeBody({
    required this.state,
    required this.gutter,
    this.coins,
    this.hints,
  });

  final JourneyReady state;
  final double gutter;
  final int? coins;
  final int? hints;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapter = _currentChapter(state);
    final level = _levelToPlay(state);
    final completed = chapter == null
        ? 0
        : state.levels
              .where(
                (item) =>
                    item.chapterId == chapter.chapterId &&
                    state.progress.isLevelCompleted(item.levelDefinitionId),
              )
              .length;
    final chapterSize = chapter == null
        ? 1
        : chapter.levelEnd - chapter.levelStart + 1;
    final config = level == null ? null : levelConfigurationFor(level);
    final cardCount = config == null
        ? 0
        : config.tableauColumnSizes.fold<int>(0, (sum, size) => sum + size) +
              config.stockCardCount;

    return ListView(
      padding: EdgeInsets.fromLTRB(gutter, 8, gutter, 24),
      children: [
        Row(
          children: [
            if (coins != null)
              MosaicHudChip.count(
                icon: MosaicHudIcon.coin,
                amount: coins!,
                label: 'عملة',
              ),
            if (hints != null) ...[
              const SizedBox(width: MosaicSpacing.s8),
              MosaicHudChip.count(
                icon: MosaicHudIcon.hint,
                amount: hints!,
                label: 'تلميحات',
              ),
            ],
            const Spacer(),
            MosaicIconButton(
              kind: MosaicIconKind.settings,
              semanticsLabel: 'الإعدادات',
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.settings),
            ),
          ],
        ),
        const SizedBox(height: MosaicSpacing.s16),
        _HeroArch(chapter: chapter, completed: completed, total: chapterSize),
        const SizedBox(height: MosaicSpacing.s16),
        if (level != null)
          MosaicButton(
            label:
                'متابعة — المستوى ${ArabicDigits.format(level.globalLevelNumber)}',
            expanded: true,
            onPressed: () {
              ref.read(currentPlayingLevelProvider.notifier).state = level;
              Navigator.of(context).pushNamed(AppRoutes.gameplay);
            },
          ),
        if (config != null) ...[
          const SizedBox(height: MosaicSpacing.s8),
          Text(
            ArabicDigits.dashJoin(
              [
                '${ArabicDigits.format(cardCount)} بطاقة',
                '${ArabicDigits.format(config.moveLimit)} حركة',
                chapter?.subtitleAr ?? '',
              ].where((part) => part.isNotEmpty).toList(),
            ),
            style: MosaicTheme.of(context).text.labelS,
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: MosaicSpacing.s16),
        Row(
          children: [
            Expanded(
              child: _Shortcut(
                label: 'الرحلة',
                icon: MosaicIconKind.map,
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.journey),
              ),
            ),
            const SizedBox(width: MosaicSpacing.s8),
            Expanded(
              child: _Shortcut(
                label: 'الحكاية',
                icon: MosaicIconKind.archive,
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.storyArchive),
              ),
            ),
            const SizedBox(width: MosaicSpacing.s8),
            Expanded(
              child: _Shortcut(
                label: 'الإعدادات',
                icon: MosaicIconKind.settings,
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.settings),
              ),
            ),
          ],
        ),
      ],
    );
  }

  ChapterDefinition? _currentChapter(JourneyReady ready) {
    final number = ready.progress.highestUnlockedLevel;
    for (final chapter in ready.chapters) {
      if (chapter.levelStart <= number && chapter.levelEnd >= number) {
        return chapter;
      }
    }
    return ready.chapters.isEmpty ? null : ready.chapters.last;
  }

  LevelDefinition? _levelToPlay(JourneyReady ready) {
    for (final level in ready.levels) {
      if (level.globalLevelNumber == ready.progress.highestUnlockedLevel) {
        return level;
      }
    }
    return ready.levels.isEmpty ? null : ready.levels.first;
  }
}

class _HeroArch extends StatelessWidget {
  const _HeroArch({
    required this.chapter,
    required this.completed,
    required this.total,
  });

  final ChapterDefinition? chapter;
  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final text = MosaicTheme.of(context).text;
    final fraction = total == 0 ? 0.0 : (completed / total).clamp(0.0, 1.0);
    return LayoutBuilder(
      builder: (context, constraints) {
        final radius = constraints.maxWidth / 2;
        return DecoratedBox(
          decoration: BoxDecoration(
            color: MosaicColors.emerald900,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(radius),
              bottom: const Radius.circular(MosaicRadii.md),
            ),
            border: Border.all(color: MosaicColors.saffron500, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 36, 28, 22),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MosaicStar(
                      size: 14,
                      color: MosaicColors.saffron500,
                      filled: true,
                    ),
                    SizedBox(width: 8),
                    MosaicStar(
                      size: 14,
                      color: MosaicColors.saffron500,
                      filled: true,
                    ),
                    SizedBox(width: 8),
                    MosaicStar(
                      size: 14,
                      color: MosaicColors.saffron500,
                      filled: true,
                    ),
                    SizedBox(width: 8),
                    MosaicStar(size: 14, color: MosaicColors.saffron500),
                    SizedBox(width: 8),
                    MosaicStar(size: 14, color: MosaicColors.saffron500),
                  ],
                ),
                const SizedBox(height: MosaicSpacing.s12),
                FittedBox(
                  child: Text(
                    'سوليتير العرب',
                    style: text.displayXl.copyWith(color: MosaicColors.onDark),
                  ),
                ),
                Text(
                  'أسطورة المعاني',
                  style: text.titleM.copyWith(color: MosaicColors.saffron500),
                ),
                const SizedBox(height: MosaicSpacing.s16),
                if (chapter != null)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: MosaicColors.emerald600,
                      borderRadius: BorderRadius.circular(MosaicRadii.md),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(
                            '${chapter!.titleAr} ${ArabicDigits.progress(completed, total)}',
                            style: text.labelM.copyWith(
                              color: MosaicColors.onDark,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: MosaicSpacing.s8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              MosaicRadii.pill,
                            ),
                            child: LinearProgressIndicator(
                              value: fraction,
                              minHeight: 8,
                              backgroundColor: MosaicColors.emerald900,
                              color: MosaicColors.saffron500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Shortcut extends StatelessWidget {
  const _Shortcut({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final MosaicIconKind icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MosaicPressable(
      onPressed: onPressed,
      semanticsLabel: label,
      borderRadius: BorderRadius.circular(MosaicRadii.pill),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: MosaicColors.paper,
          borderRadius: BorderRadius.circular(MosaicRadii.pill),
          border: Border.all(color: MosaicColors.line),
        ),
        child: SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MosaicIcon(icon, size: 18),
              const SizedBox(width: MosaicSpacing.s6),
              Flexible(
                child: Text(
                  label,
                  style: MosaicTheme.of(context).text.labelM,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
