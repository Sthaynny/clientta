import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/features/appointments/domain/models/appointment_status.dart';
import 'package:clientta/features/shared/hub/hub_surface.dart';

class HubAppointmentCard extends StatelessWidget {
  const HubAppointmentCard({
    super.key,
    required this.clientName,
    required this.serviceType,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onMarkComplete,
    this.onAddNotes,
  });

  final String clientName;
  final String serviceType;
  final String startTime;
  final String endTime;
  final String status;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onMarkComplete;
  final VoidCallback? onAddNotes;

  @override
  Widget build(BuildContext context) {
    final appointmentStatus = AppointmentStatus.fromValue(status);

    return HubSurface(
      margin: EdgeInsets.only(bottom: DSSpacing.sm.value),
      onTap: onTap,
      padding: EdgeInsets.all(DSSpacing.md.value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TimeBlock(start: startTime, end: endTime),
          DSSpacing.md.x,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DSHeadlineSmallText(
                  clientName,
                  color: HubColors.ink,
                  height: 1.25,
                ),
                DSSpacing.xxs.y,
                DSCaptionText(
                  serviceType,
                  color: HubColors.inkMuted,
                ),
                DSSpacing.xs.y,
                _StatusBadge(status: appointmentStatus),
              ],
            ),
          ),
          if (onEdit != null || onDelete != null || onMarkComplete != null)
            Column(
              children: [
                if (onMarkComplete != null &&
                    appointmentStatus == AppointmentStatus.agendado)
                  Semantics(
                    button: true,
                    label: markCompleteString,
                    child: IconButton(
                      tooltip: markCompleteString,
                      style: IconButton.styleFrom(
                        minimumSize: const Size(48, 48),
                      ),
                      onPressed: onMarkComplete,
                      icon: const Icon(Icons.check_circle_outline, size: 20),
                      color: HubColors.seed,
                    ),
                  ),
                if (onAddNotes != null)
                  Semantics(
                    button: true,
                    label: quickNotesString,
                    child: IconButton(
                      tooltip: quickNotesString,
                      style: IconButton.styleFrom(
                        minimumSize: const Size(48, 48),
                      ),
                      onPressed: onAddNotes,
                      icon: const Icon(Icons.note_add_outlined, size: 20),
                      color: HubColors.inkMuted,
                    ),
                  ),
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

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final AppointmentStatus status;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg) = switch (status) {
      AppointmentStatus.agendado => (HubColors.scheduleMuted, HubColors.schedule),
      AppointmentStatus.concluido => (HubColors.successTint, HubColors.seed),
      AppointmentStatus.cancelado => (const Color(0xFFFCE8E8), HubColors.error),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(DSSpacing.xs.value),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DSSpacing.sm.value,
          vertical: DSSpacing.xxs.value,
        ),
        child: DSCaptionSmallText(
          status.label,
          color: fg,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TimeBlock extends StatelessWidget {
  const _TimeBlock({required this.start, required this.end});

  final String start;
  final String end;

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
      child: Column(
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
