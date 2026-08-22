import 'package:flutter/material.dart';
import 'package:mobile/features/gameplay/application/gameplay_state.dart';

/// Top gameplay bar: move counter, streak, undo, hint buttons.
class GameplayToolbar extends StatelessWidget {
  const GameplayToolbar({
    super.key,
    required this.state,
    required this.onUndo,
    required this.onHint,
  });

  final GameplayPlaying state;
  final VoidCallback onUndo;
  final VoidCallback onHint;

  @override
  Widget build(BuildContext context) {
    final gs = state.gameState;
    final canUndo = gs.undo.available;

    return Container(
      color: const Color(0xFF0D1830),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Moves remaining
          Semantics(
            label: 'الحركات المتبقية: ${gs.movesRemaining}',
            child: _pill(
              icon: Icons.sports_score_outlined,
              label: '${gs.movesRemaining}',
              color: gs.movesRemaining <= 5
                  ? const Color(0xFFFF6B6B)
                  : const Color(0xFF4ECDC4),
            ),
          ),
          const SizedBox(width: 8),
          // Streak
          Semantics(
            label: 'السلسلة: ${gs.streak.currentCounter}/${gs.streak.targetTier}',
            child: _pill(
              icon: Icons.local_fire_department,
              label: '${gs.streak.currentCounter}/${gs.streak.targetTier}',
              color: const Color(0xFFFFD700),
            ),
          ),
          const Spacer(),
          // Hint
          Semantics(
            label: 'تلميح',
            button: true,
            child: _toolbarBtn(
              icon: state.hint.phase == HintPhase.loading
                  ? Icons.hourglass_empty
                  : Icons.lightbulb_outline,
              onTap: state.hint.phase != HintPhase.loading ? onHint : null,
              color: const Color(0xFFFFD700),
            ),
          ),
          const SizedBox(width: 8),
          // Undo
          Semantics(
            label: 'تراجع',
            button: true,
            enabled: canUndo,
            child: _toolbarBtn(
              icon: Icons.undo,
              onTap: canUndo ? onUndo : null,
              color: canUndo
                  ? Colors.white70
                  : const Color(0xFF3A5A8C).withAlpha((255 * 0.5).round()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2D50),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha((255 * 0.4).round())),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _toolbarBtn({
    required IconData icon,
    required VoidCallback? onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF1A2D50),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}
