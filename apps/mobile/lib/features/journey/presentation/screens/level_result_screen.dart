import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/app/navigation/app_router.dart';
import 'package:mobile/features/gameplay/application/gameplay_state.dart';
import 'package:mobile/features/journey/application/journey_providers.dart';

/// Shown after the player wins a level.
/// Displays the reward breakdown and provides navigation to the next level
/// or the journey screen. Progression is updated here.
class LevelResultScreen extends ConsumerStatefulWidget {
  const LevelResultScreen({
    super.key,
    required this.reward,
    required this.levelId,
    required this.globalLevelNumber,
  });

  final WinRewardPreview reward;
  final String levelId;
  final int globalLevelNumber;

  @override
  ConsumerState<LevelResultScreen> createState() => _LevelResultScreenState();
}

class _LevelResultScreenState extends ConsumerState<LevelResultScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fadeIn;
  bool _progressUpdated = false;
  bool _isChapterComplete = false;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeIn = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _anim.forward();
    _updateProgression();
  }

  Future<void> _updateProgression() async {
    if (_progressUpdated) return;
    _progressUpdated = true;

    final controller = ref.read(journeyControllerProvider.notifier);
    await controller.recordLevelCompleted(
      levelId: widget.levelId,
      globalNumber: widget.globalLevelNumber,
    );

    // Check if this was a chapter-ending level (every 50th)
    if (mounted) {
      setState(() {
        _isChapterComplete = widget.globalLevelNumber % 50 == 0;
      });
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _continue() {
    Navigator.of(context)
      ..pop() // pop result
      ..pop() // pop gameplay
      ..pushReplacementNamed(AppRoutes.home);
  }

  void _goJourney() {
    Navigator.of(context)
      ..popUntil((r) => r.settings.name == AppRoutes.home || r.isFirst)
      ..pushReplacementNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.reward;
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                const SizedBox(height: 24),
                const _WinBadge(),
                const SizedBox(height: 32),
                if (_isChapterComplete) ...[
                  const _ChapterCompleteLabel(),
                  const SizedBox(height: 12),
                ],
                const _RewardRow(label: 'المكافأة الأساسية', value: 50),
                const SizedBox(height: 8),
                _RewardRow(
                    label: 'مكافأة الحركات (${r.remainingMoves}×2)',
                    value: r.movesBonus),
                const SizedBox(height: 8),
                if (r.earnedStreakCoins > 0)
                  _RewardRow(
                      label: 'مكافأة التسلسل', value: r.earnedStreakCoins),
                if (_isChapterComplete) ...[
                  const SizedBox(height: 8),
                  const _RewardRow(label: 'مكافأة إتمام الفصل', value: 500),
                ],
                const Divider(color: Color(0xFFD4A017), thickness: 0.5, height: 32),
                _TotalRow(total: r.total + (_isChapterComplete ? 500 : 0)),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _continue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4A017),
                      foregroundColor: const Color(0xFF0D1B2A),
                      minimumSize: const Size.fromHeight(54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'متابعة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _goJourney,
                  child: const Text(
                    'العودة للرحلة',
                    style: TextStyle(
                      color: Color(0xFFD4A017),
                      fontFamily: 'Cairo',
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WinBadge extends StatelessWidget {
  const _WinBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFD4A017),
      ),
      child: const Icon(Icons.star, color: Color(0xFF0D1B2A), size: 56),
    );
  }
}

class _ChapterCompleteLabel extends StatelessWidget {
  const _ChapterCompleteLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFD4A017).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD4A017)),
      ),
      child: const Text(
        'اكتمل الفصل!',
        style: TextStyle(
          color: Color(0xFFD4A017),
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _RewardRow extends StatelessWidget {
  const _RewardRow({required this.label, required this.value});
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '+$value عملة',
          style: const TextStyle(
            color: Color(0xFFD4A017),
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        const Spacer(),
        Text(
          label,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontFamily: 'Cairo',
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.total});
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$total عملة',
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w900,
            fontSize: 24,
          ),
        ),
        const Spacer(),
        Text(
          'إجمالي المكافأة',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontFamily: 'Cairo',
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
