import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/journey/application/journey_providers.dart';
import 'package:mobile/features/journey/domain/journey_models.dart';

/// Displays a list of [DialogueLine] for a single [StoryBeat], then
/// calls [onDismiss] when the player has finished reading.
class StoryBeatScreen extends ConsumerStatefulWidget {
  const StoryBeatScreen({
    super.key,
    required this.beat,
    required this.onDismiss,
  });

  final StoryBeat beat;
  final VoidCallback onDismiss;

  @override
  ConsumerState<StoryBeatScreen> createState() => _StoryBeatScreenState();
}

class _StoryBeatScreenState extends ConsumerState<StoryBeatScreen> {
  int _lineIndex = 0;

  void _advance() {
    if (_lineIndex < widget.beat.dialogue.length - 1) {
      setState(() => _lineIndex++);
    } else {
      ref
          .read(journeyControllerProvider.notifier)
          .markStoryBeatViewed(widget.beat.storyBeatId);
      widget.onDismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    final line = widget.beat.dialogue[_lineIndex];
    final isLast = _lineIndex == widget.beat.dialogue.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: GestureDetector(
          onTap: _advance,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              // decorative top arc
              const Positioned(
                top: -80,
                left: -80,
                child: _GlowCircle(color: Color(0xFFD4A017), size: 240),
              ),
              const Positioned(
                bottom: -60,
                right: -60,
                child: _GlowCircle(color: Color(0xFF1A4A7C), size: 200),
              ),
              Column(
                children: [
                  const SizedBox(height: 32),
                  _ChapterLabel(beat: widget.beat),
                  const Spacer(),
                  _DialogueCard(
                    speakerKey: line.speakerKey,
                    textAr: line.textAr,
                  ),
                  const SizedBox(height: 32),
                  _ProgressDots(
                    total: widget.beat.dialogue.length,
                    current: _lineIndex,
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: _AdvanceButton(isLast: isLast, onTap: _advance),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
              // skip button
              if (widget.beat.skippable)
                Positioned(
                  top: 16,
                  left: 16,
                  child: TextButton(
                    onPressed: () {
                      ref
                          .read(journeyControllerProvider.notifier)
                          .markStoryBeatViewed(widget.beat.storyBeatId);
                      widget.onDismiss();
                    },
                    child: const Text(
                      'تخطي',
                      style: TextStyle(
                        color: Color(0xFFD4A017),
                        fontFamily: 'Cairo',
                      ),
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

class _ChapterLabel extends StatelessWidget {
  const _ChapterLabel({required this.beat});
  final StoryBeat beat;

  @override
  Widget build(BuildContext context) {
    return Text(
      beat.chapterId,
      style: const TextStyle(
        color: Color(0xFFD4A017),
        fontFamily: 'Cairo',
        fontSize: 13,
        letterSpacing: 2,
      ),
    );
  }
}

class _DialogueCard extends StatelessWidget {
  const _DialogueCard({required this.speakerKey, required this.textAr});
  final String speakerKey;
  final String textAr;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF162033),
          border: Border.all(
            color: const Color(0xFFD4A017).withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              speakerKey,
              style: const TextStyle(
                color: Color(0xFFD4A017),
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              textAr,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontSize: 18,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressDots extends StatelessWidget {
  const _ProgressDots({required this.total, required this.current});
  final int total;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFFD4A017)
                : const Color(0xFFD4A017).withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class _AdvanceButton extends StatelessWidget {
  const _AdvanceButton({required this.isLast, required this.onTap});
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD4A017),
          foregroundColor: const Color(0xFF0D1B2A),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          isLast ? 'متابعة' : 'التالي',
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.08),
      ),
    );
  }
}
