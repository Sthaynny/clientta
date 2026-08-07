import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/theme/hub_colors.dart';

/// Barra fixa no rodapé de formulários — CTA primário sempre visível no mobile.
class HubFormStickyBar extends StatelessWidget {
  const HubFormStickyBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HubColors.surface,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: HubColors.border)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.all(DSSpacing.md.value),
            child: child,
          ),
        ),
      ),
    );
  }
}
