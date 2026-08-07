import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/theme/hub_colors.dart';

/// Filtro por tipo de serviço em chips — mais rápido que dropdown em mobile.
class HubServiceTypeFilter extends StatelessWidget {
  const HubServiceTypeFilter({
    super.key,
    required this.label,
    required this.allLabel,
    required this.types,
    required this.selected,
    required this.onChanged,
  });

  final String label;
  final String allLabel;
  final List<String> types;
  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    if (types.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DSCaptionText(
          label,
          color: HubColors.inkMuted,
          fontWeight: FontWeight.w600,
        ),
        DSSpacing.sm.y,
        Wrap(
          spacing: DSSpacing.xs.value,
          runSpacing: DSSpacing.xs.value,
          children: [
            _FilterChip(
              label: allLabel,
              selected: selected == null,
              onTap: () => onChanged(null),
            ),
            for (final type in types)
              _FilterChip(
                label: type,
                selected: selected == type,
                onTap: () => onChanged(type),
              ),
          ],
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? HubColors.successTint : HubColors.canvas;
    final fg = selected ? HubColors.seed : HubColors.inkMuted;
    final border = selected ? HubColors.seed : HubColors.border;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DSSpacing.xs.value),
          side: BorderSide(color: border),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DSSpacing.xs.value),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: DSSpacing.sm.value,
              vertical: DSSpacing.xs.value,
            ),
            child: DSCaptionText(
              label,
              color: fg,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
