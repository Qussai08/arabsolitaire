import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_engine/game_engine.dart';
import 'package:mobile/app/navigation/app_router.dart';
import 'package:mobile/features/gameplay/presentation/interaction/drag_payload.dart';
import 'package:mobile/features/gameplay/presentation/widgets/association_slots_view.dart';
import 'package:mobile/features/gameplay/presentation/widgets/tableau_view.dart';
import 'package:mobile/features/journey/application/journey_providers.dart';

// ── Tutorial board constants ──────────────────────────────────────────────────

const _assocId = 'tut_a1';
const _assocCardId = 'tut_a1_card';
const _memberCardId = 'tut_a1_m1';

/// Minimal 3-column, 1-slot, 1-association board used exclusively for the
/// interactive tutorial.  Cards carry Arabic [contentRefId] labels that the
/// card view renders as text.
GameState _buildTutorialState() {
  const assocCard = AssociationCard(
    id: _assocCardId,
    associationId: _assocId,
    contentRefId: 'كلمات الضوء',
  );
  const memberCard = MemberCard(
    id: _memberCardId,
    associationId: _assocId,
    contentRefId: 'نور',
  );
  return GameState(
    attemptId: 'tutorial_attempt',
    levelDefinitionId: 'tutorial_level',
    associations: const {
      _assocId: AssociationDefinition(
        associationId: _assocId,
        associationCardId: _assocCardId,
        requiredMemberCardIds: {_memberCardId},
      ),
    },
    tableau: [
      const TableauColumn(exposedUnit: SingleMember(memberCard)),
      const TableauColumn(),
      const TableauColumn(exposedUnit: SingleAssociation(assocCard)),
    ],
    stock: const StockState(),
    slots: const [AssociationSlot(index: 0)],
    moveLimit: 20,
    movesRemaining: 20,
  );
}

// ── Step descriptions ─────────────────────────────────────────────────────────

const _steps = [
  _TutorialHint(
    icon: Icons.swipe_outlined,
    titleAr: 'حرّك البطاقة',
    bodyAr: 'اسحب بطاقة "نور" من العمود الأول إلى العمود الأوسط.',
  ),
  _TutorialHint(
    icon: Icons.link_outlined,
    titleAr: 'اجمع الكلمات',
    bodyAr: 'اسحب بطاقة "كلمات الضوء" فوق بطاقة "نور" لتكوين مجموعة.',
  ),
  _TutorialHint(
    icon: Icons.check_circle_outline,
    titleAr: 'أتمّ الجمعية',
    bodyAr: 'اسحب المجموعة إلى الخانة المضيئة لإتمام الجمعية.',
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────

/// Interactive Engine-backed tutorial.
///
/// Shows a minimal 3-column board and guides the player through three moves
/// using real [GameEngine.applyAction] calls.  No fake transitions.
class TutorialScreen extends ConsumerStatefulWidget {
  const TutorialScreen({super.key});

  @override
  ConsumerState<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends ConsumerState<TutorialScreen>
    with SingleTickerProviderStateMixin {
  final _engine = const GameEngine();
  late GameState _state;
  int _revision = 0;
  int _step = 0; // 0-2 hint index; 3 = won
  bool _navigating = false;

  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _state = _buildTutorialState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulse = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _applyAction(GameAction action) {
    if (_state.status != AttemptStatus.inProgress) return;
    final transition = _engine.applyAction(_state, action);
    if (!transition.accepted) return;

    setState(() {
      _state = transition.nextState;
      _revision++;
      if (_state.status == AttemptStatus.won) {
        _step = 3;
      } else if (_step < _steps.length - 1) {
        _step++;
      }
    });

    if (_state.status == AttemptStatus.won) {
      _completeTutorial();
    }
  }

  void _completeTutorial() {
    if (_navigating) return;
    _navigating = true;
    unawaited(
      ref.read(journeyControllerProvider.notifier).completeTutorial().then((
        _,
      ) async {
        if (!mounted) return;
        await Future<void>.delayed(const Duration(milliseconds: 1200));
        if (!mounted) return;
        unawaited(Navigator.of(context).pushReplacementNamed(AppRoutes.home));
      }),
    );
  }

  void _skip() {
    unawaited(
      ref.read(journeyControllerProvider.notifier).completeTutorial().then((_) {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }),
    );
  }

  // ── Drop handlers ────────────────────────────────────────────────────────

  void _onTableauDrop(DragPayload payload, int targetColumn) {
    if (payload.revision != _revision) return;
    final action = payload.toTableauAction(targetColumn);
    if (action != null) _applyAction(action);
  }

  void _onSlotDrop(DragPayload payload, int slotIndex) {
    if (payload.revision != _revision) return;
    final action = payload.toSlotAction(slotIndex);
    if (action != null) _applyAction(action);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final won = _step == 3;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0D1B2A),
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              const SizedBox(height: 12),
              _buildProgressDots(),
              const Spacer(),
              _buildBoard(),
              const Spacer(),
              won ? _buildWonBanner() : _buildHintPanel(_steps[_step]),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: _skip,
            child: const Text(
              'تخطي',
              style: TextStyle(
                color: Color(0xFFD4A017),
                fontFamily: 'Cairo',
                fontSize: 15,
              ),
            ),
          ),
          const Text(
            'الدرس التعليمي',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
          const SizedBox(width: 56), // balance
        ],
      ),
    );
  }

  Widget _buildProgressDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_steps.length, (i) {
        final active = i == _step || (_step == 3 && i == _steps.length - 1);
        final done = i < _step;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: done
                ? const Color(0xFFD4A017)
                : active
                ? const Color(0xFFD4A017)
                : const Color(0xFFD4A017).withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildBoard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Association slot with pulsing highlight on step 2
          AnimatedBuilder(
            animation: _pulse,
            builder: (context, child) => Opacity(
              opacity: _step == 2 ? _pulse.value : 1.0,
              child: AssociationSlotsView(
                slots: _state.slots,
                revision: _revision,
                onDrop: _onSlotDrop,
                highlightedSlotIndex: _step == 2 ? 0 : null,
              ),
            ),
          ),
          const SizedBox(height: 20),
          TableauView(
            tableau: _state.tableau,
            revision: _revision,
            onDrop: _onTableauDrop,
            highlightedCardId: _highlightedCardId(),
          ),
        ],
      ),
    );
  }

  String? _highlightedCardId() {
    return switch (_step) {
      0 => _memberCardId,
      1 => _assocCardId,
      _ => null,
    };
  }

  Widget _buildHintPanel(_TutorialHint hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF162033),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFD4A017).withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD4A017).withValues(alpha: 0.12),
              ),
              child: Icon(hint.icon, color: const Color(0xFFD4A017), size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    hint.titleAr,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hint.bodyAr,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      height: 1.5,
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

  Widget _buildWonBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1A3A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD4A017)),
        ),
        child: const Column(
          children: [
            Icon(Icons.star, color: Color(0xFFD4A017), size: 48),
            SizedBox(height: 12),
            Text(
              'أحسنت! أتممت الدرس',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'ستنطلق رحلتك الآن...',
              style: TextStyle(
                color: Color(0xFFD4A017),
                fontFamily: 'Cairo',
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TutorialHint {
  const _TutorialHint({
    required this.icon,
    required this.titleAr,
    required this.bodyAr,
  });
  final IconData icon;
  final String titleAr;
  final String bodyAr;
}
