import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/features/client_care/domain/models/care_timeline_entry.dart';
import 'package:clientta/features/shared/hub/hub_surface.dart';

class HubTimelineEntryCard extends StatelessWidget {
  const HubTimelineEntryCard({
    super.key,
    required this.entry,
    required this.timestampLabel,
  });

  final CareTimelineEntry entry;
  final String timestampLabel;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, String label, Color accent, Color bg) =
        switch (entry.source) {
          CareTimelineSource.encounter => (
            Icons.forum_outlined,
            careTimelineEncounterLabelString,
            HubColors.seed,
            HubColors.successTint,
          ),
          CareTimelineSource.appointment => (
            Icons.event_note_outlined,
            clientCareFromAppointmentString,
            HubColors.schedule,
            HubColors.scheduleMuted,
          ),
        };

    return Padding(
      padding: EdgeInsets.only(bottom: DSSpacing.sm.value),
      child: HubSurface(
        padding: EdgeInsets.all(DSSpacing.md.value),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(DSSpacing.xs.value),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: DSSpacing.sm.value,
                      vertical: DSSpacing.xxs.value,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 14, color: accent),
                        DSSpacing.xxs.x,
                        DSCaptionSmallText(
                          label,
                          color: accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                DSCaptionText(
                  timestampLabel,
                  color: HubColors.inkMuted,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            if (entry.serviceType != null &&
                entry.serviceType!.trim().isNotEmpty) ...[
              DSSpacing.xs.y,
              DSCaptionSmallText(
                entry.serviceType!,
                color: HubColors.inkMuted,
              ),
            ],
            if (entry.contextLabel != null &&
                entry.contextLabel!.trim().isNotEmpty) ...[
              DSSpacing.xxs.y,
              DSCaptionSmallText(
                entry.contextLabel!,
                color: HubColors.schedule,
                fontWeight: FontWeight.w600,
              ),
            ],
            DSSpacing.xs.y,
            DSBodyText(
              entry.body,
              color: HubColors.ink,
            ),
          ],
        ),
      ),
    );
  }
}
