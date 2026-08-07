import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/features/billing/shared/plan_pro_catalog.dart';
import 'package:clientta/features/shared/hub/hub_surface.dart';

/// Grid de benefícios Pro com ícone, título e descrição — preenche a tela com clareza.
class HubProBenefitsGrid extends StatelessWidget {
  const HubProBenefitsGrid({
    super.key,
    required this.benefits,
  });

  final List<PlanProBenefitItem> benefits;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = (constraints.maxWidth - DSSpacing.sm.value) / 2;

        return Wrap(
          spacing: DSSpacing.sm.value,
          runSpacing: DSSpacing.sm.value,
          children: benefits.map((benefit) {
            return SizedBox(
              width: tileWidth,
              child: _BenefitTile(benefit: benefit),
            );
          }).toList(),
        );
      },
    );
  }
}

class _BenefitTile extends StatelessWidget {
  const _BenefitTile({required this.benefit});

  final PlanProBenefitItem benefit;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: '${benefit.title}. ${benefit.description}',
      child: HubSurface(
        padding: EdgeInsets.all(DSSpacing.md.value),
        tint: HubColors.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: HubColors.successTint,
                borderRadius: BorderRadius.circular(DSSpacing.xs.value),
              ),
              child: Padding(
                padding: EdgeInsets.all(DSSpacing.xs.value),
                child: Icon(
                  benefit.icon,
                  size: 22,
                  color: HubColors.seed,
                ),
              ),
            ),
            DSSpacing.sm.y,
            DSCaptionText(
              benefit.title,
              color: HubColors.ink,
              fontWeight: FontWeight.w700,
              overflow: TextOverflow.clip,
            ),
            DSSpacing.xxs.y,
            DSCaptionSmallText(
              benefit.description,
              color: HubColors.inkMuted,
              height: 1.35,
              overflow: TextOverflow.clip,
            ),
          ],
        ),
      ),
    );
  }
}
