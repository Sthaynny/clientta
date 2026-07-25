import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/theme/hub_colors.dart';

/// Primary call-to-action using ConectaFERSA brand green.
class HubPrimaryButton extends StatelessWidget {
  const HubPrimaryButton({
    super.key,
    required this.onPressed,
    this.label,
    this.isLoading = false,
    this.isEnabled = true,
    this.leadingIcon,
    this.trailingIcon,
  });

  final void Function()? onPressed;
  final String? label;
  final bool isLoading;
  final bool isEnabled;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return DSPrimaryButton(
      onPressed: onPressed,
      label: label,
      isLoading: isLoading,
      isEnabled: isEnabled,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      backgroundColor: HubColors.seed,
      foregroundColor: Colors.white,
    );
  }
}
