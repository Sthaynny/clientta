import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Boolean control inside the same outlined shell as other Hub form fields.
class HubSwitchFormField extends StatelessWidget {
  const HubSwitchFormField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        contentPadding: EdgeInsets.fromLTRB(
          DSSpacing.md.value,
          DSSpacing.xs.value,
          DSSpacing.xs.value,
          DSSpacing.xs.value,
        ),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          height: 32,
          child: Switch.adaptive(
            value: value,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
