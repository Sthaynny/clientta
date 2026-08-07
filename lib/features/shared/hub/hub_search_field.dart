import 'package:flutter/material.dart';
import 'package:clientta/core/theme/hub_colors.dart';

/// Campo de busca com ícone, tema Hub e botão limpar quando há texto.
class HubSearchField extends StatefulWidget {
  const HubSearchField({
    super.key,
    required this.controller,
    required this.label,
    this.onChanged,
    this.onClear,
  });

  final TextEditingController controller;
  final String label;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  @override
  State<HubSearchField> createState() => _HubSearchFieldState();
}

class _HubSearchFieldState extends State<HubSearchField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  void _clear() {
    widget.controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.isNotEmpty;

    return Semantics(
      label: widget.label,
      textField: true,
      child: TextField(
        controller: widget.controller,
        textInputAction: TextInputAction.search,
        style: const TextStyle(
          fontSize: 16,
          height: 1.25,
          color: HubColors.ink,
        ),
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          labelText: widget.label,
          prefixIcon: const Icon(Icons.search_rounded, color: HubColors.inkMuted),
          suffixIcon: hasText
              ? Semantics(
                  button: true,
                  label: 'Limpar busca',
                  child: IconButton(
                    onPressed: _clear,
                    icon: const Icon(
                      Icons.close_rounded,
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
