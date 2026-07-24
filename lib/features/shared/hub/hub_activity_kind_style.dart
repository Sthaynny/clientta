import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/theme/hub_colors.dart';
import 'package:ufersa_hub/features/activities/domain/models/activity_entry.dart';

class HubActivityKindStyle {
  const HubActivityKindStyle({required this.label, required this.color});

  final String label;
  final Color color;

  static HubActivityKindStyle forKind(ActivityKind kind) {
    return switch (kind) {
      ActivityKind.aula => const HubActivityKindStyle(
        label: 'Presença',
        color: HubColors.seed,
      ),
      ActivityKind.estudo => const HubActivityKindStyle(
        label: 'Estudo',
        color: HubColors.schedule,
      ),
      ActivityKind.trabalho => const HubActivityKindStyle(
        label: 'Entrega',
        color: Color(0xFF8B5A2B),
      ),
      ActivityKind.prova => const HubActivityKindStyle(
        label: 'Prova',
        color: Color(0xFF9B2C4A),
      ),
      ActivityKind.outro => const HubActivityKindStyle(
        label: 'Outro',
        color: HubColors.inkMuted,
      ),
    };
  }
}
