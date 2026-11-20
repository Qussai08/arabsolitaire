import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/app/navigation/app_router.dart';
import 'package:mobile/design_system/design_system.dart';
import 'package:mobile/features/gameplay/application/gameplay_state.dart';
import 'package:mobile/features/journey/application/journey_providers.dart';

/// Shown after the player wins a level.
///
/// Displays the reward breakdown and returns to the existing home route.
/// Progression is updated here. Navigation is unchanged.
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
      ..pop()
      ..pop()
      ..pushReplacementNamed(AppRoutes.home);
  }

  void _goJourney() {
    Navigator.of(context)
      ..popUntil(
        (route) => route.settings.name == AppRoutes.home || route.isFirst,
      )
      ..pushReplacementNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final reward = widget.reward;
    final text = MosaicTheme.of(context).text;
    final gutter = MosaicSpacing.gutterForWidth(
      MediaQuery.sizeOf(context).width,
    );
    final total = reward.total + (_isChapterComplete ? 500 : 0);
    return Scaffold(
      backgroundColor: MosaicColors.limestone,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: Padding(
            padding: EdgeInsets.fromLTRB(gutter, 8, gutter, 16),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(MosaicRadii.lg),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: MosaicColors.saffron500,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(MosaicRadii.lg),
                    ),
                    child: Image.asset(
                      MosaicIllustrations.win,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(
                            height: 120,
                            child: MosaicMedallion(
                              tone: MosaicMedallionTone.saffron,
                            ),
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: MosaicSpacing.s16),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: MosaicColors.paper,
                    borderRadius: BorderRadius.circular(MosaicRadii.md),
                    border: Border.all(color: MosaicColors.line),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const _RewardLine(
                          label: 'المكافأة الأساسية',
                          value: 50,
                        ),
                        _RewardLine(
                          label:
                              'مكافأة الحركات (${ArabicDigits.format(reward.remainingMoves)} × ٢)',
                          value: reward.movesBonus,
                        ),
                        if (reward.earnedStreakCoins > 0)
                          _RewardLine(
                            label: 'مكافأة التسلسل',
                            value: reward.earnedStreakCoins,
                          ),
                        if (_isChapterComplete)
                          const _RewardLine(
                            label: 'مكافأة إتمام الفصل',
                            value: 500,
                          ),
                        const Divider(height: 24),
                        Row(
                          children: [
                            Text(
                              '${ArabicDigits.format(total)} عملة',
                              style: text.titleM.copyWith(
                                color: MosaicColors.terracotta600,
                              ),
                            ),
                            const Spacer(),
                            Text('المجموع', style: text.titleS),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (_isChapterComplete) ...[
                  const SizedBox(height: MosaicSpacing.s12),
                  const MosaicToast(
                    tone: MosaicToastTone.success,
                    title: 'اكتمل الفصل',
                    message: 'فُتحت صفحة جديدة في أرشيف الحكاية.',
                    icon: MosaicIconKind.archive,
                  ),
                ],
                const Spacer(),
                MosaicButton(
                  label: 'متابعة',
                  expanded: true,
                  onPressed: _continue,
                ),
                MosaicButton(
                  label: 'العودة للرحلة',
                  kind: MosaicButtonKind.ghost,
                  expanded: true,
                  onPressed: _goJourney,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RewardLine extends StatelessWidget {
  const _RewardLine({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final text = MosaicTheme.of(context).text;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '+${ArabicDigits.format(value)}',
            style: text.titleS.copyWith(color: MosaicColors.emerald900),
          ),
          const Spacer(),
          Flexible(
            child: Text(label, style: text.bodyS, textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}
