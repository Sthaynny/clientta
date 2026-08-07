import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/theme/hub_colors.dart';

/// Lista de benefícios Pro com ícone de confirmação — hierarquia legível na tela de plano.
class HubProBenefitsList extends StatelessWidget {
  const HubProBenefitsList({
    super.key,
    required this.benefits,
  });

  final List<String> benefits;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < benefits.length; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 20,
                color: HubColors.seed,
              ),
              DSSpacing.sm.x,
              Expanded(
                child: DSBodyText(
                  benefits[i],
                  color: HubColors.ink,
                  height: 1.4,
                ),
              ),
            ],
          ),
          if (i < benefits.length - 1) DSSpacing.sm.y,
        ],
      ],
    );
  }
}
