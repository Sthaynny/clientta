import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/features/shared/hub/hub_surface.dart';

class HubHomeQuickActions extends StatelessWidget {
  const HubHomeQuickActions({
    super.key,
    required this.addAppointmentLabel,
    required this.onAddAppointment,
  });

  final String addAppointmentLabel;
  final VoidCallback onAddAppointment;

  @override
  Widget build(BuildContext context) {
    return HubSurface(
      onTap: onAddAppointment,
      semanticsLabel: addAppointmentLabel,
      padding: EdgeInsets.symmetric(
        horizontal: DSSpacing.md.value,
        vertical: DSSpacing.md.value,
      ),
      child: Row(
        children: [
          ExcludeSemantics(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: HubColors.scheduleMuted,
                borderRadius: BorderRadius.circular(DSSpacing.xs.value),
              ),
              child: Padding(
                padding: EdgeInsets.all(DSSpacing.xs.value),
                child: const Icon(
                  Icons.event_available_outlined,
                  size: 22,
                  color: HubColors.schedule,
                ),
              ),
            ),
          ),
          DSSpacing.sm.x,
          Expanded(
            child: DSBodyText(
              addAppointmentLabel,
              fontWeight: FontWeight.w600,
              color: HubColors.ink,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: HubColors.inkMuted,
            size: 22,
          ),
        ],
      ),
    );
  }
}
