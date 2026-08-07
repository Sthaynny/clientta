import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clientta/core/theme/hub_colors.dart';

/// Text input using [HubTheme.inputDecorationTheme] — same outline as dropdowns.
class HubTextFormField extends StatelessWidget {
  const HubTextFormField({
    super.key,
    this.controller,
    required this.label,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.maxLines = 1,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final String label;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(
        fontSize: 16,
        height: 1.25,
        color: HubColors.ink,
      ),
      decoration: InputDecoration(labelText: label),
    );
  }
}
