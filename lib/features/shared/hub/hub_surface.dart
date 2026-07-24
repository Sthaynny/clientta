import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/theme/hub_colors.dart';

class HubSurface extends StatelessWidget {
  const HubSurface({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.tint,
    this.showBorder = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? tint;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding ?? EdgeInsets.all(DSSpacing.md.value),
      child: child,
    );

    final decorated = DecoratedBox(
      decoration: BoxDecoration(
        color: tint ?? HubColors.surface,
        borderRadius: BorderRadius.circular(DSSpacing.md.value),
        border: showBorder ? Border.all(color: HubColors.border) : null,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1A1F24),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: content,
    );

  return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: onTap != null
            ? InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(DSSpacing.md.value),
              child: decorated,
            )
            : decorated,
      ),
    );
  }
}
