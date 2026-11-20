import 'package:flutter/material.dart';
import 'package:mobile/design_system/mosaic_theme.dart';
import 'package:mobile/design_system/mosaic_tokens.dart';
import 'package:mobile/design_system/widgets/mosaic_star.dart';

enum MosaicButtonKind { primary, secondary, reward, ghost, danger }

/// Pill-free rounded button (height 54, radius 14).
///
/// A null [onPressed] is the disabled state: opacity 0.45 and no shadow.
/// Pressed drops the shadow and scales to 0.97. Focus draws a saffron ring.
/// Those three states are specified as recommended; they are not drawn in Figma.
///
/// In RTL the forward icon sits on the end (left, pointing left) and the back
/// icon sits on the start (right, pointing right). The coin stays on the start
/// with the other non-directional icons.
class MosaicButton extends StatefulWidget {
  const MosaicButton({
    super.key,
    required this.label,
    this.kind = MosaicButtonKind.primary,
    this.showIcon = true,
    this.icon,
    this.onPressed,
    this.expanded = false,
  });

  final String label;
  final MosaicButtonKind kind;
  final bool showIcon;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool expanded;

  @override
  State<MosaicButton> createState() => _MosaicButtonState();
}

class _MosaicButtonState extends State<MosaicButton> {
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => widget.onPressed != null;

  bool get _iconAtStart => switch (widget.kind) {
    MosaicButtonKind.secondary ||
    MosaicButtonKind.ghost ||
    MosaicButtonKind.reward => true,
    MosaicButtonKind.primary || MosaicButtonKind.danger => false,
  };

  void _setPressed(bool value) {
    if (!_enabled || _pressed == value) {
      return;
    }
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final text = MosaicTheme.of(context).text;
    final colors = _colors();
    final showShadow =
        _enabled && !_pressed && colors.shadow != null && colors.fill != null;

    final label = Text(
      widget.label,
      style: text.titleS.copyWith(color: colors.label),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );

    final icon = widget.showIcon ? (widget.icon ?? _defaultIcon(colors)) : null;
    final row = Row(
      mainAxisSize: widget.expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null && _iconAtStart) ...[
          icon,
          const SizedBox(width: MosaicSizes.buttonGap),
        ],
        if (widget.expanded) Flexible(child: label) else label,
        if (icon != null && !_iconAtStart) ...[
          const SizedBox(width: MosaicSizes.buttonGap),
          icon,
        ],
      ],
    );

    final visual = DecoratedBox(
      decoration: BoxDecoration(
        color: colors.fill,
        borderRadius: BorderRadius.circular(MosaicRadii.md),
        border: colors.border,
        boxShadow: showShadow ? colors.shadow : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: MosaicSizes.buttonPaddingX,
        ),
        child: SizedBox(height: MosaicSizes.buttonHeight, child: row),
      ),
    );

    return Focus(
      canRequestFocus: _enabled,
      onFocusChange: (focused) {
        if (_focused != focused) {
          setState(() => _focused = focused);
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        onTapDown: _enabled ? (_) => _setPressed(true) : null,
        onTapUp: _enabled ? (_) => _setPressed(false) : null,
        onTapCancel: _enabled ? () => _setPressed(false) : null,
        child: Semantics(
          button: true,
          enabled: _enabled,
          child: Opacity(
            opacity: _enabled ? 1 : MosaicOpacity.disabled,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedScale(
                  scale: _pressed ? MosaicMotion.pressedScale : 1,
                  duration: const Duration(milliseconds: 80),
                  child: visual,
                ),
                if (_focused && _enabled)
                  const Positioned(
                    left: -4,
                    top: -4,
                    right: -4,
                    bottom: -4,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(MosaicRadii.md + 4),
                          ),
                          border: Border.fromBorderSide(
                            BorderSide(
                              color: MosaicColors.saffron500,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _defaultIcon(_ButtonColors colors) {
    return switch (widget.kind) {
      MosaicButtonKind.primary || MosaicButtonKind.danger => Icon(
        Icons.arrow_forward,
        size: MosaicSizes.buttonIcon,
        color: colors.label,
      ),
      MosaicButtonKind.secondary || MosaicButtonKind.ghost => Icon(
        Icons.arrow_back,
        size: MosaicSizes.buttonIcon,
        color: colors.label,
      ),
      MosaicButtonKind.reward => const MosaicCoinIcon(
        size: MosaicSizes.buttonIcon,
      ),
    };
  }

  _ButtonColors _colors() {
    return switch (widget.kind) {
      MosaicButtonKind.primary => const _ButtonColors(
        fill: MosaicColors.terracotta600,
        label: MosaicColors.onDark,
        shadow: MosaicShadows.card,
      ),
      MosaicButtonKind.secondary => const _ButtonColors(
        fill: MosaicColors.paper,
        label: MosaicColors.emerald600,
        border: Border.fromBorderSide(
          BorderSide(
            color: MosaicColors.emerald600,
            width: MosaicBorder.normal,
          ),
        ),
      ),
      MosaicButtonKind.reward => const _ButtonColors(
        fill: MosaicColors.saffron500,
        label: MosaicColors.emerald900,
        shadow: MosaicShadows.card,
      ),
      MosaicButtonKind.ghost => const _ButtonColors(
        label: MosaicColors.emerald600,
      ),
      MosaicButtonKind.danger => const _ButtonColors(
        fill: MosaicColors.danger700,
        label: MosaicColors.onDark,
        shadow: MosaicShadows.card,
      ),
    };
  }
}

class _ButtonColors {
  const _ButtonColors({
    required this.label,
    this.fill,
    this.border,
    this.shadow,
  });

  final Color? fill;
  final Color label;
  final BoxBorder? border;
  final List<BoxShadow>? shadow;
}
