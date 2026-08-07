import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/utils/input_masks.dart';
import 'package:clientta/features/clients/domain/models/client_profile.dart';
import 'package:clientta/features/shared/hub/hub_surface.dart';

class HubClientCard extends StatelessWidget {
  const HubClientCard({
    super.key,
    required this.profile,
    this.onTap,
  });

  final ClientProfile profile;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final phone = profile.clientPhone.trim();
    final subtitleParts = <String>[
      if (phone.isNotEmpty) formatBrPhone(phone),
      if (profile.serviceType != null && profile.serviceType!.trim().isNotEmpty)
        profile.serviceType!,
    ];

    return Semantics(
      label: profile.clientName,
      button: onTap != null,
      child: HubSurface(
        margin: EdgeInsets.only(bottom: DSSpacing.sm.value),
        onTap: onTap,
        padding: EdgeInsets.all(DSSpacing.md.value),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HubClientAvatar(initials: clientInitials(profile.clientName)),
            DSSpacing.md.x,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DSHeadlineSmallText(
                    profile.clientName,
                    color: HubColors.ink,
                    height: 1.25,
                  ),
                  if (subtitleParts.isNotEmpty) ...[
                    DSSpacing.xxs.y,
                    DSCaptionText(
                      subtitleParts.join(' · '),
                      color: HubColors.inkMuted,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  DSSpacing.xs.y,
                  Wrap(
                    spacing: DSSpacing.xs.value,
                    runSpacing: DSSpacing.xxs.value,
                    children: [
                      if (profile.appointmentCount > 0)
                        _MetaChip(
                          icon: Icons.event_note_outlined,
                          label: clientProfileAppointmentsLabel(
                            profile.appointmentCount,
                          ),
                        ),
                      if (profile.encounterCount > 0)
                        _MetaChip(
                          icon: Icons.forum_outlined,
                          label: clientProfileEncountersLabel(
                            profile.encounterCount,
                          ),
                        ),
                      if (profile.lastActivityAt != null)
                        _MetaChip(
                          icon: Icons.history_rounded,
                          label: clientProfileLastActivityLabel(
                            profile.lastActivityAt!,
                          ),
                        ),
                    ],
                  ),
                  if (profile.nextAppointmentDate != null &&
                      profile.nextAppointmentStartTime != null) ...[
                    DSSpacing.xs.y,
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_outlined,
                          size: 14,
                          color: HubColors.schedule,
                        ),
                        DSSpacing.xxs.x,
                        Expanded(
                          child: DSCaptionSmallText(
                            clientProfileNextAppointmentLabel(
                              date: profile.nextAppointmentDate!,
                              startTime: profile.nextAppointmentStartTime!,
                            ),
                            color: HubColors.schedule,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: HubColors.inkMuted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

String clientInitials(String clientName) {
  final parts =
      clientName
          .trim()
          .split(RegExp(r'\s+'))
          .where((part) => part.isNotEmpty)
          .toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) {
    return parts.first[0].toUpperCase();
  }
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}

class HubClientAvatar extends StatelessWidget {
  const HubClientAvatar({
    super.key,
    required this.initials,
    this.radius = 24,
  });

  final String initials;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: HubColors.seed.withValues(alpha: 0.12),
      child: Text(
        initials,
        style: TextStyle(
          color: HubColors.seed,
          fontWeight: FontWeight.w700,
          fontSize: radius * 0.66,
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: HubColors.canvas,
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
            Icon(icon, size: 12, color: HubColors.inkMuted),
            DSSpacing.xxs.x,
            DSCaptionSmallText(
              label,
              color: HubColors.inkMuted,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
