import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/theme/hub_colors.dart';

/// Toggle row for forms — label + optional subtitle on the left, switch on the right.
/// Not an [InputDecorator]; avoids the empty “text field” look.
class HubSwitchFormField extends StatelessWidget {
  const HubSwitchFormField({
    super.key,
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      toggled: value,
      label: label,
      child: Material(
        color: HubColors.surface,
        borderRadius: BorderRadius.circular(DSSpacing.sm.value),
        child: InkWell(
          onTap: () => onChanged(!value),
          borderRadius: BorderRadius.circular(DSSpacing.sm.value),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DSSpacing.sm.value),
              border: Border.all(color: HubColors.border),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                DSSpacing.md.value,
                DSSpacing.sm.value,
                DSSpacing.xs.value,
                DSSpacing.sm.value,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: HubColors.ink,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                          ),
                        ),
                        if (subtitle != null) ...[
                          SizedBox(height: DSSpacing.xxs.value),
                          Text(
                            subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: HubColors.inkMuted,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: value,
                    onChanged: onChanged,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
