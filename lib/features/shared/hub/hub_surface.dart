import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:university_hub/core/theme/hub_colors.dart';

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
    final radius = BorderRadius.circular(DSSpacing.md.value);
    final content = Padding(
      padding: padding ?? EdgeInsets.all(DSSpacing.md.value),
      child: child,
    );

    Widget surface = Material(
      color: tint ?? HubColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: showBorder
            ? const BorderSide(color: HubColors.border)
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap != null
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

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: surface,
    );
  }
}
