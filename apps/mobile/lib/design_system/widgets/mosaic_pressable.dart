import 'package:flutter/material.dart';
import 'package:mobile/design_system/mosaic_tokens.dart';

/// Shared press, disabled, and focus treatment for Mosaic tappables.
///
/// Pressed scales to 0.97. Disabled is opacity 0.45. Focus draws a 2px
/// saffron ring, 2px outside the child.
class MosaicPressable extends StatefulWidget {
  const MosaicPressable({
    super.key,
    required this.child,
    this.onPressed,
    this.semanticsLabel,
    this.borderRadius = const BorderRadius.all(Radius.circular(MosaicRadii.md)),
    this.enabled,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final String? semanticsLabel;
  final BorderRadius borderRadius;

  /// Overrides the default, which treats a null [onPressed] as disabled.
  final bool? enabled;

  bool get isEnabled => enabled ?? onPressed != null;

  @override
  State<MosaicPressable> createState() => _MosaicPressableState();
}

class _MosaicPressableState extends State<MosaicPressable> {
  bool _pressed = false;
  bool _focused = false;

  void _setPressed(bool value) {
    if (!widget.isEnabled || _pressed == value) {
      return;
    }
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.isEnabled;
    return Focus(
      canRequestFocus: enabled,
      onFocusChange: (focused) {
        if (_focused != focused) {
          setState(() => _focused = focused);
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? widget.onPressed : null,
        onTapDown: enabled ? (_) => _setPressed(true) : null,
        onTapUp: enabled ? (_) => _setPressed(false) : null,
        onTapCancel: enabled ? () => _setPressed(false) : null,
        child: Semantics(
          button: true,
          enabled: enabled,
          label: widget.semanticsLabel,
          child: Opacity(
            opacity: enabled ? 1 : MosaicOpacity.disabled,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedScale(
                  scale: _pressed ? MosaicMotion.pressedScale : 1,
                  duration: const Duration(milliseconds: 80),
                  child: widget.child,
                ),
                if (_focused && enabled)
                  Positioned(
                    left: -4,
                    top: -4,
                    right: -4,
                    bottom: -4,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: widget.borderRadius,
                          border: const Border.fromBorderSide(
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
}
