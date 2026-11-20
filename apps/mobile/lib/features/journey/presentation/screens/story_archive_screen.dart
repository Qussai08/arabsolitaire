import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/design_system/design_system.dart';
import 'package:mobile/features/journey/application/journey_providers.dart';
import 'package:mobile/features/journey/data/journey_content.dart';
import 'package:mobile/features/journey/domain/journey_models.dart';
import 'package:mobile/features/journey/presentation/screens/story_beat_screen.dart';

class StoryArchiveScreen extends ConsumerWidget {
  const StoryArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeyState = ref.watch(journeyControllerProvider);
    final gutter = MosaicSpacing.gutterForWidth(
      MediaQuery.sizeOf(context).width,
    );
    return Scaffold(
      backgroundColor: MosaicColors.limestone,
      body: SafeArea(
        child: switch (journeyState) {
          JourneyLoading() => const Center(
            child: CircularProgressIndicator(color: MosaicColors.emerald600),
          ),
          JourneyError(:final message) => Center(child: Text(message)),
          JourneyReady(:final flags) => ListView(
            padding: EdgeInsets.fromLTRB(gutter, 0, gutter, 24),
            children: [
              MosaicHeader(
                title: 'أرشيف الحكاية',
                showSubtitle: false,
                onBack: () => Navigator.of(context).maybePop(),
              ),
              for (final chapter in JourneyContent.chapters) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 8),
                  child: Text(
                    chapter.titleAr,
                    style: MosaicTheme.of(context).text.titleS,
                  ),
                ),
                for (final beat
                    in (JourneyContent.storyBeats
                        .where((item) => item.chapterId == chapter.chapterId)
                        .toList()
                      ..sort(
                        (a, b) => a.triggerLevelNumber.compareTo(
                          b.triggerLevelNumber,
                        ),
                      )))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _BeatRow(beat: beat, flags: flags),
                  ),
              ],
            ],
          ),
        },
      ),
    );
  }
}

class _BeatRow extends ConsumerWidget {
  const _BeatRow({required this.beat, required this.flags});

  final StoryBeat beat;
  final PlayerLocalFlags flags;

  String _typeLabel(StoryBeatType type) => switch (type) {
    StoryBeatType.start => 'البداية',
    StoryBeatType.midpoint => 'المنتصف',
    StoryBeatType.ending => 'الخاتمة',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlocked = flags.unlockedStoryBeatIds.contains(beat.storyBeatId);
    return MosaicRow(
      title: unlocked ? _typeLabel(beat.type) : 'مقفل',
      showSubtitle: false,
      icon: unlocked ? MosaicIconKind.play : MosaicIconKind.lock,
      onPressed: unlocked
          ? () => Navigator.of(context).push<void>(
              MaterialPageRoute(
                builder: (_) => StoryBeatScreen(
                  beat: beat,
                  onDismiss: () => Navigator.of(context).pop(),
                ),
              ),
            )
          : null,
    );
  }
}
