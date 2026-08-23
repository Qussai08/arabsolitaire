import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/app/navigation/app_router.dart';
import 'package:mobile/features/gameplay/application/gameplay_providers.dart';
import 'package:mobile/features/journey/application/journey_providers.dart';
import 'package:mobile/features/journey/domain/journey_models.dart';
import 'package:mobile/features/journey/presentation/screens/story_beat_screen.dart';

/// Home screen: shows the chapter map. On first launch transitions to onboarding
/// / tutorial; otherwise renders the chapter list with level progress.
class JourneyScreen extends ConsumerWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeyState = ref.watch(journeyControllerProvider);

    return switch (journeyState) {
      JourneyLoading() => const _LoadingView(),
      JourneyError(:final message) => _ErrorView(message: message),
      JourneyReady() => _JourneyReady(state: journeyState),
    };
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0D1B2A),
      body: Center(child: CircularProgressIndicator(color: Color(0xFFD4A017))),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
        ),
      ),
    );
  }
}

class _JourneyReady extends ConsumerWidget {
  const _JourneyReady({required this.state});
  final JourneyReady state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: CustomScrollView(
        slivers: [
          _JourneyAppBar(progress: state.progress),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _ChapterCard(
                  chapter: state.chapters[i],
                  chapterState: state.chapterState(state.chapters[i]),
                  levels: state.levels
                      .where((l) => l.chapterId == state.chapters[i].chapterId)
                      .toList(),
                  state: state,
                  onLevelTap: (level) =>
                      _onLevelTap(context, ref, state, level),
                ),
                childCount: state.chapters.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onLevelTap(
    BuildContext context,
    WidgetRef ref,
    JourneyReady state,
    LevelDefinition level,
  ) {
    // Register which level is being played before pushing gameplay.
    ref.read(currentPlayingLevelProvider.notifier).state = level;

    // Check for pending story beats before entering level.
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

// ── App Bar ───────────────────────────────────────────────────────────────────

class _JourneyAppBar extends StatelessWidget {
  const _JourneyAppBar({required this.progress});
  final JourneyProgress progress;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 160,
      backgroundColor: const Color(0xFF0D1B2A),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFD4A017).withValues(alpha: 0.08),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'سوليتير العرب',
                    style: TextStyle(
                      color: Color(0xFFD4A017),
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                    ),
                  ),
                  Text(
                    'المستوى ${progress.highestUnlockedLevel}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontFamily: 'Cairo',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Chapter Card ─────────────────────────────────────────────────────────────

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
  final void Function(LevelDefinition) onLevelTap;

  @override
  Widget build(BuildContext context) {
    final isLocked = chapterState == ChapterState.locked;
    final completedCount = levels
        .where((l) => state.levelStatus(l) == LevelStatus.completed)
        .length;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isLocked ? 0.45 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF162033),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: chapterState == ChapterState.completed
                  ? const Color(0xFFD4A017).withValues(alpha: 0.5)
                  : const Color(0xFFD4A017).withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            children: [
              _ChapterHeader(
                chapter: chapter,
                chapterState: chapterState,
                completedCount: completedCount,
                totalCount: levels.length,
              ),
              if (!isLocked)
                _LevelGrid(levels: levels, state: state, onTap: onLevelTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChapterHeader extends StatelessWidget {
  const _ChapterHeader({
    required this.chapter,
    required this.chapterState,
    required this.completedCount,
    required this.totalCount,
  });

  final ChapterDefinition chapter;
  final ChapterState chapterState;
  final int completedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chapter.titleAr,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                Text(
                  chapter.subtitleAr,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontFamily: 'Cairo',
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          _ProgressRing(
            completed: completedCount,
            total: totalCount,
            locked: chapterState == ChapterState.locked,
          ),
        ],
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({
    required this.completed,
    required this.total,
    required this.locked,
  });
  final int completed;
  final int total;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final fraction = total == 0 ? 0.0 : completed / total;
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: fraction,
            strokeWidth: 4,
            backgroundColor: const Color(0xFFD4A017).withValues(alpha: 0.15),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD4A017)),
          ),
          if (locked)
            const Icon(Icons.lock_outline, color: Color(0xFFD4A017), size: 20)
          else
            Text(
              '$completed/$total',
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
        ],
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
  final void Function(LevelDefinition) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 10,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 1,
        ),
        itemCount: levels.length,
        itemBuilder: (_, i) {
          final level = levels[i];
          final status = state.levelStatus(level);
          return _LevelDot(status: status, onTap: () => onTap(level));
        },
      ),
    );
  }
}

class _LevelDot extends StatelessWidget {
  const _LevelDot({required this.status, required this.onTap});
  final LevelStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (bg, border) = switch (status) {
      LevelStatus.completed => (
        const Color(0xFFD4A017),
        const Color(0xFFD4A017),
      ),
      LevelStatus.inProgress => (
        const Color(0xFF1A4A7C),
        const Color(0xFF4A9EFF),
      ),
      LevelStatus.unlocked => (
        const Color(0xFF1C2C42),
        const Color(0xFFD4A017).withValues(alpha: 0.4),
      ),
      LevelStatus.locked => (const Color(0xFF111D2C), const Color(0xFF1C2C42)),
    };

    return GestureDetector(
      onTap: status != LevelStatus.locked ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: border, width: 1),
        ),
      ),
    );
  }
}
