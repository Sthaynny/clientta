import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/theme/hub_theme.dart';
import 'package:clientta/core/utils/input_masks.dart';
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
    this.clientPhone,
    this.notes,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onMarkComplete,
    this.onAddNotes,
    this.onViewCare,
    this.onCancel,
  });

  final String clientName;
  final String serviceType;
  final String startTime;
  final String endTime;
  final String status;
  final String? clientPhone;
  final String? notes;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onMarkComplete;
  final VoidCallback? onAddNotes;
  final VoidCallback? onViewCare;
  final VoidCallback? onCancel;

  String get _semanticLabel {
    final appointmentStatus = AppointmentStatus.fromValue(status);
    return '$startTime a $endTime, $clientName, $serviceType, ${appointmentStatus.label}';
  }

  @override
  Widget build(BuildContext context) {
    final appointmentStatus = AppointmentStatus.fromValue(status);
    final showNotes =
        appointmentStatus == AppointmentStatus.concluido &&
        notes != null &&
        notes!.trim().isNotEmpty;

    return Semantics(
      label: _semanticLabel,
      button: onTap != null,
      child: HubSurface(
        margin: EdgeInsets.only(bottom: DSSpacing.sm.value),
        onTap: onTap,
        semanticsLabel: _semanticLabel,
        padding: EdgeInsets.all(DSSpacing.md.value),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(child: _TimeBlock(start: startTime, end: endTime)),
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
                  if (clientPhone != null && clientPhone!.trim().isNotEmpty) ...[
                    DSSpacing.xxs.y,
                    DSCaptionText(
                      formatBrPhone(clientPhone!),
                      color: HubColors.inkMuted,
                    ),
                  ],
                  DSSpacing.xxs.y,
                  DSCaptionText(
                    serviceType,
                    color: HubColors.inkMuted,
                  ),
                  if (showNotes) ...[
                    DSSpacing.xs.y,
                    DSCaptionText(
                      notes!,
                      color: HubColors.inkMuted,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  DSSpacing.xs.y,
                  _StatusBadge(status: appointmentStatus),
                ],
              ),
            ),
            if (onEdit != null ||
                onDelete != null ||
                onMarkComplete != null ||
                onAddNotes != null ||
                onViewCare != null ||
                onCancel != null)
              Column(
                children: [
                  if (onMarkComplete != null &&
                      appointmentStatus == AppointmentStatus.agendado)
                    _ActionIcon(
                      label: markCompleteString,
                      icon: Icons.check_circle_outline,
                      color: HubColors.seed,
                      onPressed: onMarkComplete!,
                    ),
                  if (onCancel != null &&
                      appointmentStatus == AppointmentStatus.agendado)
                    _ActionIcon(
                      label: cancelAppointmentActionString,
                      icon: Icons.cancel_outlined,
                      color: HubColors.warning,
                      onPressed: onCancel!,
                    ),
                  if (onAddNotes != null)
                    _ActionIcon(
                      label: quickNotesString,
                      icon: Icons.note_add_outlined,
                      color: HubColors.inkMuted,
                      onPressed: onAddNotes!,
                    ),
                  if (onViewCare != null)
                    _ActionIcon(
                      label: clientCareActionString,
                      icon: Icons.forum_outlined,
                      color: HubColors.schedule,
                      onPressed: onViewCare!,
                    ),
                  if (onEdit != null)
                    _ActionIcon(
                      label: editActionString,
                      icon: Icons.edit_outlined,
                      color: HubColors.inkMuted,
                      onPressed: onEdit!,
                    ),
                  if (onDelete != null)
                    _ActionIcon(
                      label: deleteString,
                      icon: Icons.delete_outline,
                      color: HubColors.error,
                      onPressed: onDelete!,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: IconButton(
        tooltip: label,
        style: IconButton.styleFrom(
          minimumSize: const Size(HubTheme.minTouchTarget, HubTheme.minTouchTarget),
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        color: color,
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
      AppointmentStatus.agendado => (HubColors.warningTint, HubColors.warning),
      AppointmentStatus.concluido => (HubColors.successTint, HubColors.success),
      AppointmentStatus.cancelado => (HubColors.errorTint, HubColors.error),
    };

    return Semantics(
      label: 'Status: ${status.label}',
      child: DecoratedBox(
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
