import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/design_system/design_system.dart';
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

    final gutter = MosaicSpacing.gutterForWidth(
      MediaQuery.sizeOf(context).width,
    );
    return Scaffold(
      backgroundColor: MosaicColors.limestone,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(gutter, 8, gutter, 16),
          child: Column(
            children: [
              Row(
                children: [
                  if (widget.beat.skippable)
                    MosaicButton(
                      label: 'تخطي',
                      kind: MosaicButtonKind.ghost,
                      showIcon: false,
                      onPressed: () {
                        ref
                            .read(journeyControllerProvider.notifier)
                            .markStoryBeatViewed(widget.beat.storyBeatId);
                        widget.onDismiss();
                      },
                    ),
                  const Spacer(),
                  Text(
                    widget.beat.chapterId,
                    style: MosaicTheme.of(context).text.labelS,
                  ),
                ],
              ),
              const Spacer(),
              MosaicShiboubBubble(speaker: line.speakerKey, line: line.textAr),
              const SizedBox(height: MosaicSpacing.s16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < widget.beat.dialogue.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: MosaicPip(filled: i <= _lineIndex),
                    ),
                ],
              ),
              const Spacer(),
              MosaicButton(
                label: isLast ? 'متابعة' : 'التالي',
                expanded: true,
                onPressed: _advance,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
