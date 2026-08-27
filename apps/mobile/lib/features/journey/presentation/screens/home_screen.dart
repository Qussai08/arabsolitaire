import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/app/navigation/app_router.dart';
import 'package:mobile/features/gameplay/application/gameplay_providers.dart';
import 'package:mobile/features/journey/application/journey_providers.dart';
import 'package:mobile/features/journey/domain/journey_models.dart';

/// Primary hub screen. Shows:
/// - brand / title hero
/// - Continue button (if active attempt or unlocked level exists)
/// - Enter Journey
/// - Story Archive
/// - Settings
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeyState = ref.watch(journeyControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: Stack(
        children: [
          // Background glow
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD4A017).withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1A4A7C).withValues(alpha: 0.1),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 48),
                  // Brand hero
                  const Text(
                    'سوليتير',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFD4A017),
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w900,
                      fontSize: 48,
                      height: 1.1,
                    ),
                  ),
                  const Text(
                    'العرب',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'أسطورة المعاني',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  // Progress summary
                  if (journeyState is JourneyReady)
                    _ProgressSummary(state: journeyState),
                  const SizedBox(height: 32),
                  // Continue button
                  _ContinueButton(journeyState: journeyState),
                  const SizedBox(height: 12),
                  // Enter Journey
                  _NavButton(
                    label: 'الرحلة الرئيسية',
                    icon: Icons.map_outlined,
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRoutes.journey),
                  ),
                  const SizedBox(height: 8),
                  // Story Archive
                  _NavButton(
                    label: 'أرشيف الحكاية',
                    icon: Icons.menu_book_outlined,
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRoutes.storyArchive),
                  ),
                  const SizedBox(height: 8),
                  // Settings
                  _NavButton(
                    label: 'الإعدادات',
                    icon: Icons.settings_outlined,
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRoutes.settings),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressSummary extends StatelessWidget {
  const _ProgressSummary({required this.state});
  final JourneyReady state;

  String _chapterTitle(JourneyReady s) {
    final level = s.progress.highestUnlockedLevel;
    final chapter = s.chapters.cast<ChapterDefinition?>().firstWhere(
      (c) => c != null && c.levelStart <= level && c.levelEnd >= level,
      orElse: () => s.chapters.isNotEmpty ? s.chapters.last : null,
    );
    return chapter?.titleAr ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final title = _chapterTitle(state);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF162033),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFD4A017).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'المستوى ${state.progress.highestUnlockedLevel}',
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
          const Icon(
            Icons.auto_stories_outlined,
            color: Color(0xFFD4A017),
            size: 28,
          ),
        ],
      ),
    );
  }
}

class _ContinueButton extends ConsumerWidget {
  const _ContinueButton({required this.journeyState});
  final JourneyViewState journeyState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ready = journeyState is JourneyReady
        ? journeyState as JourneyReady
        : null;
    if (ready == null) return const SizedBox.shrink();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Set the current level so GameplayScreen can report result back.
          final levelToPlay = ready.levels.cast<LevelDefinition?>().firstWhere(
            (l) => l?.globalLevelNumber == ready.progress.highestUnlockedLevel,
            orElse: () => ready.levels.isNotEmpty ? ready.levels.first : null,
          );
          if (levelToPlay != null) {
            ref.read(currentPlayingLevelProvider.notifier).state = levelToPlay;
          }
          Navigator.of(context).pushNamed(AppRoutes.gameplay);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD4A017),
          foregroundColor: const Color(0xFF0D1B2A),
          minimumSize: const Size.fromHeight(60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'متابعة اللعب',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF162033),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFD4A017).withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFD4A017), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(Icons.chevron_left, color: Colors.white38, size: 20),
          ],
        ),
      ),
    );
  }
}
