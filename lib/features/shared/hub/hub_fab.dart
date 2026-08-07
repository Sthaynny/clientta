import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/theme/hub_colors.dart';

class HubFab extends StatelessWidget {
  const HubFab({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: FloatingActionButton.extended(
        onPressed: onPressed,
        icon: const Icon(Icons.add_rounded),
        label: Text(label),
        backgroundColor: HubColors.seed,
        foregroundColor: Colors.white,
        elevation: 2,
        extendedPadding: EdgeInsets.symmetric(horizontal: DSSpacing.md.value),
      ),
    );
  }
}
