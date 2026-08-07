import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/theme/hub_theme.dart';

/// Botão secundário com borda — login social e ações complementares.
class HubOutlinedButton extends StatelessWidget {
  const HubOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.semanticsLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final style = OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(HubTheme.minTouchTarget),
      side: const BorderSide(color: HubColors.border),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DSSpacing.sm.value),
      ),
    );

  final labelWidget = Text(
      label,
      style: const TextStyle(
        color: HubColors.ink,
        fontWeight: FontWeight.w600,
      ),
    );

    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: semanticsLabel ?? label,
      child: SizedBox(
        width: double.infinity,
        child: icon != null
            ? OutlinedButton.icon(
                onPressed: onPressed,
                icon: Icon(icon, size: 20, color: HubColors.inkMuted),
                label: labelWidget,
                style: style,
              )
            : OutlinedButton(
                onPressed: onPressed,
                style: style,
                child: labelWidget,
              ),
      ),
    );
  }
}
