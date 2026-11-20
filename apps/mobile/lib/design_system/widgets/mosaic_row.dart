import 'package:flutter/material.dart';
import 'package:mobile/design_system/mosaic_theme.dart';
import 'package:mobile/design_system/mosaic_typography.dart';
import 'package:mobile/design_system/mosaic_tokens.dart';
import 'package:mobile/design_system/widgets/mosaic_icon.dart';
import 'package:mobile/design_system/widgets/mosaic_pressable.dart';

/// What sits on the end (left in RTL) of a settings row.
enum MosaicRowTrailing { chevron, toggle, value }

/// Paper row: lead icon, title, optional subtitle, trailing control.
///
/// A toggle's knob position is the non-color cue. On places the knob at the
/// end; off places it at the start.
class MosaicRow extends StatelessWidget {
  const MosaicRow({
    super.key,
    required this.title,
    this.subtitle,
    this.showSubtitle = true,
    this.icon,
    this.showIcon = true,
    this.value,
    this.trailing = MosaicRowTrailing.chevron,
    this.toggleValue = false,
    this.onPressed,
    this.onToggle,
  });

  final String title;
  final String? subtitle;
  final bool showSubtitle;
  final MosaicIconKind? icon;
  final bool showIcon;
  final String? value;
  final MosaicRowTrailing trailing;
  final bool toggleValue;
  final VoidCallback? onPressed;
  final ValueChanged<bool>? onToggle;

  @override
  Widget build(BuildContext context) {
    final text = MosaicTheme.of(context).text;
    final caption = showSubtitle ? subtitle : null;
    final row = DecoratedBox(
      decoration: BoxDecoration(
        color: MosaicColors.paper,
        borderRadius: BorderRadius.circular(MosaicRadii.md),
        border: Border.all(color: MosaicColors.line),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(14, 12, 14, 12),
        child: Row(
          children: [
            if (showIcon && icon != null) ...[
              DecoratedBox(
                decoration: const BoxDecoration(
                  color: MosaicColors.saffron100,
                  shape: BoxShape.circle,
                ),
                child: SizedBox.square(
                  dimension: 36,
                  child: Center(child: MosaicIcon(icon!, size: 20)),
                ),
              ),
              const SizedBox(width: MosaicSpacing.s12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: text.titleS.copyWith(color: MosaicColors.emerald900),
                  ),
                  if (caption != null && caption.isNotEmpty)
                    Text(caption, style: text.labelS),
                ],
              ),
            ),
            const SizedBox(width: MosaicSpacing.s12),
            _trailing(text),
          ],
        ),
      ),
    );

    if (trailing == MosaicRowTrailing.toggle) {
      return row;
    }
    return MosaicPressable(onPressed: onPressed, child: row);
  }

  Widget _trailing(MosaicTextStyles text) {
    return switch (trailing) {
      MosaicRowTrailing.chevron => const MosaicIcon(
        MosaicIconKind.forward,
        size: 18,
        color: MosaicColors.emerald600,
      ),
      MosaicRowTrailing.value => Text(
        value ?? '',
        style: text.labelM.copyWith(color: MosaicColors.emerald600),
      ),
      MosaicRowTrailing.toggle => _MosaicToggle(
        value: toggleValue,
        onChanged: onToggle,
      ),
    };
  }
}

class _MosaicToggle extends StatelessWidget {
  const _MosaicToggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;
    return Semantics(
      toggled: value,
      enabled: enabled,
      label: value ? 'مفعّل' : 'متوقف',
      child: GestureDetector(
        onTap: enabled ? () => onChanged!(!value) : null,
        child: Opacity(
          opacity: enabled ? 1 : MosaicOpacity.disabled,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: 56,
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: value ? MosaicColors.emerald600 : MosaicColors.plaster,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: value ? MosaicColors.emerald600 : MosaicColors.line,
              ),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 120),
              alignment: value
                  ? AlignmentDirectional.centerEnd
                  : AlignmentDirectional.centerStart,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: MosaicColors.paper,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
