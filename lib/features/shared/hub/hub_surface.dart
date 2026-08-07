import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class HubSurface extends StatelessWidget {
  const HubSurface({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.tint,
    this.showBorder = true,
    this.semanticsLabel,
    this.semanticButton = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? tint;
  final bool showBorder;
  final String? semanticsLabel;
  final bool semanticButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(DSSpacing.md.value);
    final content = Padding(
      padding: padding ?? EdgeInsets.all(DSSpacing.md.value),
      child: child,
    );

    Widget surface = Material(
      color: tint ?? theme.colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side:
            showBorder
                ? BorderSide(color: theme.colorScheme.outline)
                : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child:
          onTap != null
              ? InkWell(
                onTap: onTap,
                borderRadius: radius,
                child: content,
              )
              : content,
    );

    surface = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1A1F24),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: surface,
    );

    final padded = Padding(
      padding: margin ?? EdgeInsets.zero,
      child: surface,
    );

    if (onTap == null || !semanticButton) return padded;

    return Semantics(
      button: true,
      label: semanticsLabel,
      child: padded,
    );
  }
}
