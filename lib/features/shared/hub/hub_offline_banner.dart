import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/theme/hub_colors.dart';

enum HubOfflineBannerVariant { offline, syncPending }

/// Faixa informativa de offline ou sincronização pendente (Pro).
class HubOfflineBanner extends StatelessWidget {
  const HubOfflineBanner({
    super.key,
    required this.message,
    this.variant = HubOfflineBannerVariant.offline,
  });

  final String message;
  final HubOfflineBannerVariant variant;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, IconData icon) = switch (variant) {
      HubOfflineBannerVariant.offline => (
        HubColors.warningTint,
        HubColors.warning,
        Icons.cloud_off_outlined,
      ),
      HubOfflineBannerVariant.syncPending => (
        HubColors.scheduleMuted,
        HubColors.schedule,
        Icons.sync_problem_outlined,
      ),
    };

    return Semantics(
      liveRegion: true,
      label: message,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(DSSpacing.sm.value),
          border: Border.all(color: fg.withValues(alpha: 0.25)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: DSSpacing.md.value,
            vertical: DSSpacing.sm.value,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: fg),
              DSSpacing.sm.x,
              Expanded(
                child: DSCaptionText(
                  message,
                  color: HubColors.ink,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
