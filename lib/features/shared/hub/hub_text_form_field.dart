import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clientta/core/theme/hub_colors.dart';

/// Campo de texto com tema Hub, suporte a senha e acessibilidade.
class HubTextFormField extends StatefulWidget {
  const HubTextFormField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.errorText,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.maxLines = 1,
    this.enabled = true,
    this.obscureText = false,
    this.autofillHints,
    this.semanticsLabel,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController? controller;
  final String label;
  final String? hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool enabled;
  final bool obscureText;
  final Iterable<String>? autofillHints;
  final String? semanticsLabel;
  final TextCapitalization textCapitalization;

  @override
  State<HubTextFormField> createState() => _HubTextFormFieldState();
}

class _HubTextFormFieldState extends State<HubTextFormField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant HubTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.obscureText) {
      _obscured = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticsLabel ?? widget.label,
      textField: true,
      child: TextFormField(
        controller: widget.controller,
        enabled: widget.enabled,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        inputFormatters: widget.inputFormatters,
        maxLines: widget.maxLines,
        obscureText: _obscured,
        autofillHints: widget.autofillHints,
        textCapitalization: widget.textCapitalization,
        onChanged: widget.onChanged,
        validator: widget.validator,
        style: const TextStyle(
          fontSize: 16,
          height: 1.25,
          color: HubColors.ink,
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          errorText: widget.errorText,
          suffixIcon:
              widget.obscureText
                  ? Semantics(
                    button: true,
                    label: _obscured ? 'Mostrar senha' : 'Ocultar senha',
                    child: IconButton(
                      onPressed:
                          () => setState(() => _obscured = !_obscured),
                      icon: Icon(
                        _obscured
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: HubColors.inkMuted,
                      ),
                    ),
                  )
                  : null,
        ),
      ),
    );
  }
}
