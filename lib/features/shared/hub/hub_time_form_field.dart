import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/theme/hub_colors.dart';

/// Outlined time trigger aligned with [HubTheme] input decoration (dropdowns).
class HubTimeFormField extends StatelessWidget {
  const HubTimeFormField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      value: value,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DSSpacing.sm.value),
          child: IgnorePointer(
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: label,
                suffixIcon: const Icon(
                  Icons.schedule_outlined,
                  color: HubColors.inkMuted,
                ),
              ),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.25,
                  color: HubColors.ink,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
