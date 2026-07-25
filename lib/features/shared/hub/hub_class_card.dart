import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/strings/daily_strings.dart';
import 'package:ufersa_hub/core/theme/hub_colors.dart';
import 'package:ufersa_hub/features/shared/hub/hub_surface.dart';

class HubClassCard extends StatelessWidget {
  const HubClassCard({
    super.key,
    required this.subject,
    required this.startTime,
    required this.endTime,
    this.room,
    this.weekdayLabel,
    this.timeVaries = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final String subject;
  final String startTime;
  final String endTime;
  final String? room;
  final String? weekdayLabel;
  final bool timeVaries;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return HubSurface(
      margin: EdgeInsets.only(bottom: DSSpacing.sm.value),
      onTap: onTap,
      padding: EdgeInsets.all(DSSpacing.md.value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TimeBlock(
            start: startTime,
            end: endTime,
            varies: timeVaries,
          ),
          DSSpacing.md.x,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DSHeadlineSmallText(
                  subject,
                  color: HubColors.ink,
                  height: 1.25,
                ),
                if (weekdayLabel != null) ...[
                  DSSpacing.xxs.y,
                  DSCaptionText(
                    weekdayLabel!,
                    color: HubColors.inkMuted,
                  ),
                ],
                if (room != null && room!.isNotEmpty) ...[
                  DSSpacing.xxs.y,
                  Row(
                    children: [
                      const Icon(
                        Icons.place_outlined,
                        size: 16,
                        color: HubColors.schedule,
                      ),
                      DSSpacing.xxs.x,
                      Expanded(
                        child: DSCaptionText(
                          room!,
                          color: HubColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (onEdit != null || onDelete != null)
            Column(
              children: [
                if (onEdit != null)
                  Semantics(
                    button: true,
                    label: editActionString,
                    child: IconButton(
                      tooltip: editActionString,
                      style: IconButton.styleFrom(
                        minimumSize: const Size(48, 48),
                      ),
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      color: HubColors.inkMuted,
                    ),
                  ),
                if (onDelete != null)
                  Semantics(
                    button: true,
                    label: deleteString,
                    child: IconButton(
                      tooltip: deleteString,
                      style: IconButton.styleFrom(
                        minimumSize: const Size(48, 48),
                      ),
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline, size: 20),
                      color: HubColors.error,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _TimeBlock extends StatelessWidget {
  const _TimeBlock({
    required this.start,
    required this.end,
    this.varies = false,
  });

  final String start;
  final String end;
  final bool varies;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      padding: EdgeInsets.symmetric(
        vertical: DSSpacing.xs.value,
        horizontal: DSSpacing.xs.value,
      ),
      decoration: BoxDecoration(
        color: HubColors.scheduleMuted,
        borderRadius: BorderRadius.circular(DSSpacing.xs.value),
      ),
      child: varies
          ? Center(
              child: DSCaptionSmallText(
                classScheduleTimeVariesString,
                color: HubColors.schedule,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
              ),
            )
          : Column(
              children: [
                DSCaptionText(
                  start,
                  fontWeight: FontWeight.w700,
                  color: HubColors.schedule,
                ),
                const SizedBox(height: 2),
                DSCaptionSmallText(
                  end,
                  color: HubColors.inkMuted,
                ),
              ],
            ),
    );
  }
}
