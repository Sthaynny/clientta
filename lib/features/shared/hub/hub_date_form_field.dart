import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/theme/hub_colors.dart';

/// Outlined date trigger aligned with [HubTheme] input decoration (dropdowns).
class HubDateFormField extends StatelessWidget {
  const HubDateFormField({
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
                  Icons.calendar_today_outlined,
                  color: HubColors.inkMuted,
                ),
              ),
              child: DSBodyText(
                value,
                color: HubColors.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
