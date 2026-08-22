import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/journey/application/journey_providers.dart';
import 'package:mobile/features/journey/data/journey_content.dart';
import 'package:mobile/features/journey/domain/journey_models.dart';
import 'package:mobile/features/journey/presentation/screens/story_beat_screen.dart';

class StoryArchiveScreen extends ConsumerWidget {
  const StoryArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeyState = ref.watch(journeyControllerProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        title: const Text(
          'أرشيف الحكاية',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: switch (journeyState) {
        JourneyLoading() => const Center(
            child: CircularProgressIndicator(color: Color(0xFFD4A017)),
          ),
        JourneyError(:final message) => Center(
            child: Text(message,
                style: const TextStyle(color: Colors.white, fontFamily: 'Cairo')),
          ),
        JourneyReady(:final flags) => _ArchiveBody(flags: flags),
      },
    );
  }
}

class _ArchiveBody extends StatelessWidget {
  const _ArchiveBody({required this.flags});
  final PlayerLocalFlags flags;

  @override
  Widget build(BuildContext context) {
    const chapters = JourneyContent.chapters;
    const beats = JourneyContent.storyBeats;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: chapters.length,
      itemBuilder: (ctx, i) {
        final chapter = chapters[i];
        final chapterBeats = beats
            .where((b) => b.chapterId == chapter.chapterId)
            .toList()
          ..sort((a, b) => a.triggerLevelNumber.compareTo(b.triggerLevelNumber));

        return _ChapterBeatSection(
          chapter: chapter,
          beats: chapterBeats,
          unlockedIds: flags.unlockedStoryBeatIds,
        );
      },
    );
  }
}

class _ChapterBeatSection extends StatelessWidget {
  const _ChapterBeatSection({
    required this.chapter,
    required this.beats,
    required this.unlockedIds,
  });
  final ChapterDefinition chapter;
  final List<StoryBeat> beats;
  final Set<String> unlockedIds;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(
              chapter.titleAr,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                color: Color(0xFFD4A017),
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          ...beats.map((b) => _BeatTile(
                beat: b,
                isUnlocked: unlockedIds.contains(b.storyBeatId),
              )),
        ],
      ),
    );
  }
}

class _BeatTile extends ConsumerWidget {
  const _BeatTile({required this.beat, required this.isUnlocked});
  final StoryBeat beat;
  final bool isUnlocked;

  String _typeLabel(StoryBeatType t) => switch (t) {
        StoryBeatType.start => 'البداية',
        StoryBeatType.midpoint => 'المنتصف',
        StoryBeatType.ending => 'الخاتمة',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: isUnlocked
            ? () => Navigator.of(context).push<void>(
                  MaterialPageRoute(
                    builder: (_) => StoryBeatScreen(
                      beat: beat,
                      onDismiss: () => Navigator.of(context).pop(),
                    ),
                  ),
                )
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isUnlocked
                ? const Color(0xFF162033)
                : const Color(0xFF0F1928),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isUnlocked
                  ? const Color(0xFFD4A017).withValues(alpha: 0.3)
                  : const Color(0xFF1C2C42),
            ),
          ),
          child: Row(
            children: [
              Icon(
                isUnlocked ? Icons.play_circle_outline : Icons.lock_outline,
                color: isUnlocked
                    ? const Color(0xFFD4A017)
                    : Colors.white.withValues(alpha: 0.3),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isUnlocked
                      ? _typeLabel(beat.type)
                      : '???',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: isUnlocked
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.3),
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
