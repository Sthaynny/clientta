import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/theme/hub_colors.dart';

/// Agrupa campos de formulário com título e espaçamento consistente.
class HubFormSection extends StatelessWidget {
  const HubFormSection({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: DSCaptionText(
            title,
            color: HubColors.inkMuted,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (subtitle != null) ...[
          DSSpacing.xxs.y,
          DSCaptionSmallText(
            subtitle!,
            color: HubColors.inkMuted,
          ),
        ],
        DSSpacing.sm.y,
        ...children,
      ],
    );
  }
}
