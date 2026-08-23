import 'package:flutter/material.dart';
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
      GameplayWon(:final reward) => _overlay(
        context,
        title: 'أحسنت!',
        subtitle: 'تم حل المستوى',
        color: const Color(0xFF1A4A1A),
        borderColor: const Color(0xFFFFD700),
        body: _WinBody(reward: reward),
        primaryLabel: 'مرحلة جديدة',
        onPrimary: onRestart,
        secondaryLabel: 'خروج',
        onSecondary: onExit,
      ),
      GameplayOutOfMoves() => _overlay(
        context,
        title: 'نفدت الحركات',
        subtitle: '',
        color: const Color(0xFF3A1A1A),
        borderColor: const Color(0xFFFF6B6B),
        body: null,
        primaryLabel: 'إعادة المحاولة',
        onPrimary: onRestart,
        secondaryLabel: 'خروج',
        onSecondary: onExit,
      ),
      GameplayConfirmedDeadEnd() => _overlay(
        context,
        title: 'لا يوجد مسار للفوز',
        subtitle: 'لا يوجد مسار للفوز من الوضع الحالي',
        color: const Color(0xFF3A2A1A),
        borderColor: const Color(0xFFFF9966),
        body: null,
        primaryLabel: 'إعادة المحاولة',
        onPrimary: onRestart,
        secondaryLabel: 'خروج',
        onSecondary: onExit,
      ),
      GameplayError(:final message, :final recoverable) => _overlay(
        context,
        title: 'خطأ',
        subtitle: message,
        color: const Color(0xFF2A1A2A),
        borderColor: const Color(0xFFCC66CC),
        body: null,
        primaryLabel: recoverable ? 'حاول مرة أخرى' : null,
        onPrimary: recoverable ? onRestart : null,
        secondaryLabel: 'خروج',
        onSecondary: onExit,
      ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _overlay(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Color color,
    required Color borderColor,
    required Widget? body,
    required String? primaryLabel,
    required VoidCallback? onPrimary,
    required String? secondaryLabel,
    required VoidCallback? onSecondary,
  }) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
              if (body != null) ...[const SizedBox(height: 16), body],
              const SizedBox(height: 20),
              if (primaryLabel != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: borderColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onPrimary,
                  child: Text(primaryLabel),
                ),
              if (secondaryLabel != null) ...[
                const SizedBox(height: 10),
                TextButton(
                  onPressed: onSecondary,
                  child: Text(
                    secondaryLabel,
                    style: const TextStyle(color: Colors.white54),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _WinBody extends StatelessWidget {
  const _WinBody({required this.reward});

  final WinRewardPreview reward;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row('الحركات المتبقية:', '${reward.remainingMoves}'),
        _row('مكافأة الحركات:', '+${reward.movesBonus}'),
        _row('مكافأة السلسلة:', '+${reward.earnedStreakCoins}'),
        const Divider(color: Colors.white30),
        _row('الإجمالي:', '${reward.total} 🪙', bold: true),
      ],
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: bold ? 15 : 13,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: bold ? 16 : 13,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
