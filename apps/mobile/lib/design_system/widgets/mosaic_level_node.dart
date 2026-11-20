import 'package:flutter/material.dart';
import 'package:mobile/design_system/arabic_digits.dart';
import 'package:mobile/design_system/mosaic_theme.dart';
import 'package:mobile/design_system/mosaic_tokens.dart';
import 'package:mobile/design_system/widgets/mosaic_icon.dart';
import 'package:mobile/design_system/widgets/mosaic_pressable.dart';

/// Progress state of a level disc. Each state has a caption or a lock.
enum MosaicLevelNodeState { done, current, locked }

/// 52px disc plus a caption. Locked shows a lock instead of a number.
class MosaicLevelNode extends StatelessWidget {
  const MosaicLevelNode({
    super.key,
    required this.state,
    this.number,
    this.onPressed,
    this.caption,
  });

  final MosaicLevelNodeState state;
  final int? number;
  final VoidCallback? onPressed;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final text = MosaicTheme.of(context).text;
    final label = caption ?? _defaultCaption(state);
    final disc = Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: switch (state) {
          MosaicLevelNodeState.done => MosaicColors.mint100,
          MosaicLevelNodeState.current => MosaicColors.terracotta600,
          MosaicLevelNodeState.locked => MosaicColors.plaster,
        },
        border: Border.all(
          color: switch (state) {
            MosaicLevelNodeState.done => MosaicColors.emerald600,
            MosaicLevelNodeState.current => MosaicColors.saffron500,
            MosaicLevelNodeState.locked => MosaicColors.line,
          },
          width: switch (state) {
            MosaicLevelNodeState.current => MosaicBorder.currentLevel,
            MosaicLevelNodeState.done => MosaicBorder.emphasis,
            MosaicLevelNodeState.locked => MosaicBorder.normal,
          },
        ),
        boxShadow: state == MosaicLevelNodeState.current
            ? MosaicShadows.selectedGlow
            : null,
      ),
      child: state == MosaicLevelNodeState.locked
          ? const MosaicIcon(
              MosaicIconKind.lock,
              size: 20,
              color: MosaicColors.textMuted,
            )
          : Text(
              ArabicDigits.format(number ?? 0),
              style: text.numberHud.copyWith(
                color: state == MosaicLevelNodeState.current
                    ? MosaicColors.onDark
                    : MosaicColors.emerald900,
              ),
            ),
    );

    final column = SizedBox(
      width: 56,
      height: 72,
      child: Column(
        children: [
          disc,
          const SizedBox(height: 2),
          Text(
            label,
            style: text.labelS.copyWith(
              color: state == MosaicLevelNodeState.current
                  ? MosaicColors.terracotta600
                  : MosaicColors.textMuted,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    if (state == MosaicLevelNodeState.locked || onPressed == null) {
      return Semantics(label: label, child: column);
    }
    return MosaicPressable(
      onPressed: onPressed,
      semanticsLabel: label,
      borderRadius: BorderRadius.circular(MosaicRadii.pill),
      child: column,
    );
  }

  static String _defaultCaption(MosaicLevelNodeState state) {
    return switch (state) {
      MosaicLevelNodeState.done => '✓ مكتمل',
      MosaicLevelNodeState.current => 'الحالي',
      MosaicLevelNodeState.locked => 'مقفل',
    };
  }
}
