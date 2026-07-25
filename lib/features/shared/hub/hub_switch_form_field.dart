import 'package:flutter/material.dart';

/// Boolean control with the same outlined shell as dropdowns and date fields.
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
      decoration: InputDecoration(labelText: label),
      child: Align(
        alignment: Alignment.centerRight,
        child: Switch.adaptive(
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
