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
    this.actionsEnabled = true,
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
  final bool actionsEnabled;

  String get _semanticLabel {
    final appointmentStatus = AppointmentStatus.fromValue(status);
    return '$startTime a $endTime, $clientName, $serviceType, ${appointmentStatus.label}';
  }

  List<_CardAction> get _actions {
    final appointmentStatus = AppointmentStatus.fromValue(status);
    final actions = <_CardAction>[];

    if (onMarkComplete != null &&
        appointmentStatus == AppointmentStatus.agendado) {
      actions.add(
        _CardAction(
          label: markCompleteString,
          icon: Icons.check_circle_outline,
          color: HubColors.seed,
          onPressed: onMarkComplete!,
        ),
      );
    }
    if (onCancel != null && appointmentStatus == AppointmentStatus.agendado) {
      actions.add(
        _CardAction(
          label: cancelAppointmentActionString,
          icon: Icons.cancel_outlined,
          color: HubColors.warning,
          onPressed: onCancel!,
        ),
      );
    }
    if (onViewCare != null) {
      actions.add(
        _CardAction(
          label: clientCareActionString,
          icon: Icons.forum_outlined,
          color: HubColors.schedule,
          onPressed: onViewCare!,
        ),
      );
    } else if (onAddNotes != null) {
      actions.add(
        _CardAction(
          label: quickNotesString,
          icon: Icons.note_add_outlined,
          color: HubColors.inkMuted,
          onPressed: onAddNotes!,
        ),
      );
    }
    if (onEdit != null) {
      actions.add(
        _CardAction(
          label: editActionString,
          icon: Icons.edit_outlined,
          color: HubColors.inkMuted,
          onPressed: onEdit!,
        ),
      );
    }
    if (onDelete != null) {
      actions.add(
        _CardAction(
          label: deleteString,
          icon: Icons.delete_outline,
          color: HubColors.error,
          onPressed: onDelete!,
        ),
      );
    }

    return actions;
  }

  @override
  Widget build(BuildContext context) {
    final appointmentStatus = AppointmentStatus.fromValue(status);
    final showNotes =
        appointmentStatus == AppointmentStatus.concluido &&
        notes != null &&
        notes!.trim().isNotEmpty;
    final actions = _actions;

    return Semantics(
      container: true,
      label: _semanticLabel,
      child: HubSurface(
        margin: EdgeInsets.only(bottom: DSSpacing.sm.value),
        onTap: onTap,
        semanticButton: false,
        padding: EdgeInsets.all(DSSpacing.md.value),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExcludeSemantics(
                  child: _TimeBlock(start: startTime, end: endTime),
                ),
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
                      if (clientPhone != null &&
                          clientPhone!.trim().isNotEmpty) ...[
                        DSSpacing.xxs.y,
                        DSCaptionText(
                          formatBrPhone(clientPhone!),
                          color: HubColors.inkMuted,
                        ),
                      ],
                      DSSpacing.xxs.y,
                      DSCaptionText(
                        serviceType,
                        color: HubColors.schedule,
                        fontWeight: FontWeight.w600,
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
              ],
            ),
            if (actions.isNotEmpty) ...[
              DSSpacing.sm.y,
              Divider(height: 1, color: Theme.of(context).colorScheme.outline),
              DSSpacing.xs.y,
              _ActionBar(actions: actions, enabled: actionsEnabled),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.actions, required this.enabled});

  final List<_CardAction> actions;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < actions.length; i++) ...[
          if (i > 0) DSSpacing.xs.x,
          Expanded(child: _ActionButton(action: actions[i], enabled: enabled)),
        ],
      ],
    );
  }
}

class _CardAction {
  const _CardAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.action, required this.enabled});

  final _CardAction action;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actionBg = theme.scaffoldBackgroundColor;
    final labelColor = theme.colorScheme.onSurfaceVariant;

    return Semantics(
      button: true,
      label: action.label,
      enabled: enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.38,
        child: Material(
          color: actionBg,
          borderRadius: BorderRadius.circular(DSSpacing.xs.value),
          child: InkWell(
            onTap: enabled ? action.onPressed : null,
            borderRadius: BorderRadius.circular(DSSpacing.xs.value),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: HubTheme.minTouchTarget,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: DSSpacing.xs.value,
                  horizontal: DSSpacing.xxs.value,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(action.icon, size: 18, color: action.color),
                    DSSpacing.xxs.y,
                    DSCaptionSmallText(
                      action.label,
                      color: labelColor,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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
