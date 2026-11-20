import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_engine/game_engine.dart';
import 'package:mobile/app/navigation/app_router.dart';
import 'package:mobile/design_system/design_system.dart';
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
    titleAr: 'حرّك البطاقة',
    bodyAr: 'اسحب بطاقة "نور" من العمود الأول إلى العمود الأوسط.',
  ),
  _TutorialHint(
    titleAr: 'اجمع الكلمات',
    bodyAr: 'اسحب بطاقة "كلمات الضوء" فوق بطاقة "نور" لتكوين مجموعة.',
  ),
  _TutorialHint(
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
    final expected = switch ((_step, action)) {
      (0, MoveTableauToTableau(fromColumn: 0, toColumn: 1)) ||
      (1, MoveTableauToTableau(fromColumn: 2, toColumn: 1)) ||
      (2, MoveTableauToSlot(fromColumn: 1, slotIndex: 0)) => true,
      _ => false,
    };
    if (!expected) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('جرّب الحركة اللي شرحها شيبوب.')),
        );
      return;
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
      unawaited(_completeTutorial());
    }
  }

  Future<void> _completeTutorial({bool skipped = false}) async {
    if (_navigating) return;
    _navigating = true;
    try {
      await ref.read(journeyControllerProvider.notifier).completeTutorial();
      if (!skipped) {
        await Future<void>.delayed(const Duration(milliseconds: 1200));
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      unawaited(Navigator.of(context).pushReplacementNamed(AppRoutes.home));
    } catch (_) {
      _navigating = false;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذّر حفظ الدرس. حاول مرة أخرى.')),
      );
    }
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

    final text = MosaicTheme.of(context).text;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: MosaicColors.limestone,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    MosaicButton(
                      label: 'تخطي',
                      kind: MosaicButtonKind.ghost,
                      showIcon: false,
                      onPressed: () =>
                          unawaited(_completeTutorial(skipped: true)),
                    ),
                    Expanded(
                      child: Text(
                        'الدرس التعليمي',
                        style: text.titleS,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 64),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < _steps.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: MosaicPip(
                        filled:
                            i <= _step && _step < 3 ||
                            (_step == 3 && i < _steps.length),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildBoard(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: won
                    ? _buildWonBanner()
                    : MosaicShiboubBubble(
                        line:
                            '${_steps[_step].titleAr} — ${_steps[_step].bodyAr}',
                      ),
              ),
            ],
          ),
        ),
      ),
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

  Widget _buildWonBanner() {
    return const Column(
      children: [
        MosaicMedallion(tone: MosaicMedallionTone.saffron),
        SizedBox(height: MosaicSpacing.s12),
        Text('أحسنت! أتممت الدرس'),
        SizedBox(height: MosaicSpacing.s6),
        Text('ستنطلق رحلتك الآن...'),
      ],
    );
  }
}

class _TutorialHint {
  const _TutorialHint({required this.titleAr, required this.bodyAr});

  final String titleAr;
  final String bodyAr;
}
