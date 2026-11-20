import 'package:flutter/material.dart';
import 'package:mobile/design_system/design_system.dart';
import 'package:mobile/features/economy/domain/economy_models.dart';
import 'package:mobile/features/gameplay/application/gameplay_state.dart';

/// Overlays for win, out-of-moves, dead-end, and error states.
class GameplayOverlay extends StatelessWidget {
  const GameplayOverlay({
    super.key,
    required this.state,
    required this.onRestart,
    required this.onExit,
  });

  final GameplayViewState state;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      GameplayWon(:final reward) => _WinOverlay(
        reward: reward,
        onRestart: onRestart,
        onExit: onExit,
      ),
      GameplayOutOfMoves() => _BottomSheet(
        title: 'نفدت الحركات!',
        message: 'انتهت حركات هذه المحاولة. يمكنك إعادة المستوى أو الخروج.',
        onRestart: onRestart,
        onExit: onExit,
        offer: const _MovesOffer(),
      ),
      GameplayConfirmedDeadEnd() => _BottomSheet(
        title: 'طريق مسدود',
        message: 'لا يوجد مسار للفوز من الوضع الحالي.',
        onRestart: onRestart,
        onExit: onExit,
      ),
      GameplayError(:final message, :final recoverable) => _BottomSheet(
        title: 'تعذّر المتابعة',
        message: message,
        onRestart: recoverable ? onRestart : null,
        onExit: onExit,
        restartLabel: 'حاول مرة أخرى',
      ),
      _ => const SizedBox.shrink(),
    };
  }
}

class _WinOverlay extends StatelessWidget {
  const _WinOverlay({
    required this.reward,
    required this.onRestart,
    required this.onExit,
  });

  final WinRewardPreview reward;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final text = MosaicTheme.of(context).text;
    return ColoredBox(
      color: MosaicColors.limestone,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(MosaicSpacing.s16),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(MosaicRadii.lg),
                child: Image.asset(
                  MosaicIllustrations.win,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(height: 120),
                ),
              ),
              const SizedBox(height: MosaicSpacing.s16),
              Text('أحسنت!', style: text.displayL),
              const SizedBox(height: MosaicSpacing.s12),
              _RewardCard(reward: reward),
              const Spacer(),
              MosaicButton(
                label: 'مرحلة جديدة',
                expanded: true,
                onPressed: onRestart,
              ),
              MosaicButton(
                label: 'خروج',
                kind: MosaicButtonKind.ghost,
                expanded: true,
                onPressed: onExit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({required this.reward});

  final WinRewardPreview reward;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: MosaicColors.paper,
        borderRadius: BorderRadius.circular(MosaicRadii.md),
        border: Border.all(color: MosaicColors.line),
      ),
      child: Padding(
        padding: const EdgeInsets.all(MosaicSpacing.s16),
        child: Column(
          children: [
            _line(
              'مكافأة الحركات (${ArabicDigits.format(reward.remainingMoves)} × ٢)',
              reward.movesBonus,
            ),
            _line('مكافأة السلسلة', reward.earnedStreakCoins),
            const Divider(height: 24),
            _line('المجموع', reward.total, emphasis: true),
          ],
        ),
      ),
    );
  }

  Widget _line(String label, int value, {bool emphasis = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            '+${ArabicDigits.format(value)}',
            style: TextStyle(
              fontFamily: MosaicFonts.readexPro,
              fontWeight: emphasis ? FontWeight.w700 : FontWeight.w600,
              color: emphasis
                  ? MosaicColors.terracotta600
                  : MosaicColors.emerald900,
            ),
          ),
          const Spacer(),
          Text(
            label,
            style: const TextStyle(
              fontFamily: MosaicFonts.readexPro,
              color: MosaicColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomSheet extends StatelessWidget {
  const _BottomSheet({
    required this.title,
    required this.message,
    required this.onExit,
    this.onRestart,
    this.restartLabel = 'إعادة المستوى',
    this.offer,
  });

  final String title;
  final String message;
  final VoidCallback onExit;
  final VoidCallback? onRestart;
  final String restartLabel;
  final Widget? offer;

  @override
  Widget build(BuildContext context) {
    final text = MosaicTheme.of(context).text;
    return Material(
      color: MosaicColors.scrim,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: MosaicColors.paper,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(MosaicRadii.lg),
            ),
            boxShadow: MosaicShadows.sheet,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
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
                const SizedBox(height: MosaicSpacing.s12),
                Row(
                  children: [
                    const MosaicShiboubAvatar(size: 64),
                    const SizedBox(width: MosaicSpacing.s12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: text.displayL),
                          Text(message, style: text.bodyS),
                        ],
                      ),
                    ),
                  ],
                ),
                if (offer != null) ...[
                  const SizedBox(height: MosaicSpacing.s12),
                  offer!,
                ],
                const SizedBox(height: MosaicSpacing.s12),
                if (onRestart != null)
                  MosaicButton(
                    label: restartLabel,
                    kind: MosaicButtonKind.secondary,
                    expanded: true,
                    onPressed: onRestart,
                  ),
                MosaicButton(
                  label: 'الرئيسية',
                  kind: MosaicButtonKind.ghost,
                  expanded: true,
                  onPressed: onExit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows the approved extra-move price. The button stays disabled because
/// the engine has no action that adds moves to the board.
class _MovesOffer extends StatelessWidget {
  const _MovesOffer();

  @override
  Widget build(BuildContext context) {
    final text = MosaicTheme.of(context).text;
    final grant = ArabicDigits.format(EconomyConfig.extraMovesGrant);
    final price = ArabicDigits.format(EconomyConfig.extraMovesCostFirst);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: MosaicColors.saffron100,
        borderRadius: BorderRadius.circular(MosaicRadii.md),
        border: Border.all(color: MosaicColors.saffron500),
      ),
      child: Padding(
        padding: const EdgeInsets.all(MosaicSpacing.s16),
        child: Column(
          children: [
            Row(
              children: [
                const MosaicIcon(MosaicIconKind.moves, size: 18),
                const SizedBox(width: MosaicSpacing.s8),
                Text('+$grant حركات', style: text.titleS),
              ],
            ),
            const SizedBox(height: MosaicSpacing.s12),
            MosaicButton(
              label: 'اشترِ بـ $price عملة',
              kind: MosaicButtonKind.reward,
              expanded: true,
            ),
            const SizedBox(height: MosaicSpacing.s8),
            Text(
              'شراء الحركات لا يُضاف إلى اللوحة في هذه النسخة.',
              style: text.labelS,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
