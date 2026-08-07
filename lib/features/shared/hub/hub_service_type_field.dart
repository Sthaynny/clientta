import 'package:flutter/material.dart';
import 'package:clientta/core/theme/hub_colors.dart';

/// Campo de tipo de serviço com sugestões e digitação livre.
class HubServiceTypeField extends StatelessWidget {
  const HubServiceTypeField({
    super.key,
    required this.controller,
    required this.options,
    required this.label,
    this.hint,
    this.errorText,
    this.onChanged,
    this.enabled = true,
  });

  final TextEditingController controller;
  final List<String> options;
  final String label;
  final String? hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (textEditingValue) {
        final query = textEditingValue.text.trim().toLowerCase();
        if (query.isEmpty) {
          return options;
        }
        return options.where((option) => option.toLowerCase().contains(query));
      },
      displayStringForOption: (option) => option,
      onSelected: (selection) {
        controller.text = selection;
        onChanged?.call(selection);
      },
      fieldViewBuilder: (context, fieldController, focusNode, onFieldSubmitted) {
        if (fieldController.text != controller.text) {
          fieldController.value = fieldController.value.copyWith(
            text: controller.text,
            selection: TextSelection.collapsed(offset: controller.text.length),
          );
        }

        return TextFormField(
          controller: fieldController,
          focusNode: focusNode,
          enabled: enabled,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (value) {
            controller.text = value;
            onChanged?.call(value);
          },
          onFieldSubmitted: (_) => onFieldSubmitted(),
          style: const TextStyle(
            fontSize: 16,
            height: 1.25,
            color: HubColors.ink,
          ),
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            errorText: errorText,
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, iterableOptions) {
        final optionList = iterableOptions.toList();
        if (optionList.isEmpty) {
          return const SizedBox.shrink();
        }

        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200, minWidth: 280),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: optionList.length,
                itemBuilder: (context, index) {
                  final option = optionList[index];
                  return ListTile(
                    dense: true,
                    title: Text(option),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
