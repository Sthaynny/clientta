import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/config/app_config.dart';

/// Faixa informativa exibida no lugar de banners de anúncio no perfil universitário.
class UniversityInfoStrip extends StatelessWidget {
  const UniversityInfoStrip({super.key});

  @override
  Widget build(BuildContext context) {
    if (!AppConfig.isUniversityMode) {
      return const SizedBox.shrink();
    }

    return Material(
      color: DSColors.primary.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: DSColors.primary, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: DSBodyText(
                'ConectaFERSA — facilitador acadêmico da comunidade universitária.',
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
