import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/theme/hub_theme.dart';

/// CTA primário da marca — alvo de toque ≥48px e semântica de botão.
class HubPrimaryButton extends StatelessWidget {
  const HubPrimaryButton({
    super.key,
    required this.onPressed,
    this.label,
    this.isLoading = false,
    this.isEnabled = true,
    this.leadingIcon,
    this.trailingIcon,
    this.semanticsLabel,
  });

  final void Function()? onPressed;
  final String? label;
  final bool isLoading;
  final bool isEnabled;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: isEnabled && !isLoading,
      label: semanticsLabel ?? label,
      child: SizedBox(
        width: double.infinity,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: HubTheme.minTouchTarget),
          child: DSClassicPrimaryButton(
            onPressed: onPressed,
            label: label,
            isLoading: isLoading,
            isEnabled: isEnabled,
            leadingIcon: leadingIcon,
            trailingIcon: trailingIcon,
            backgroundColor: HubColors.seed,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
