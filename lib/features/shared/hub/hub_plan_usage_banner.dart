import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/plan/plan_access_policy.dart';
import 'package:clientta/core/router/app_router.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/utils/extension/build_context.dart';
import 'package:clientta/features/shared/hub/hub_surface.dart';

class HubPlanUsageBanner extends StatelessWidget {
  const HubPlanUsageBanner({
    super.key,
    required this.activeAppointments,
    required this.activeSeries,
  });

  final int activeAppointments;
  final int activeSeries;

  @override
  Widget build(BuildContext context) {
    final atAppointmentLimit =
        activeAppointments >= PlanAccessPolicy.freeMaxActiveAppointments;
    final atSeriesLimit =
        activeSeries >= PlanAccessPolicy.freeMaxActiveSeries;

    return HubSurface(
      padding: EdgeInsets.all(DSSpacing.md.value),
      tint: HubColors.warningTint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.workspace_premium_outlined,
                color: HubColors.warning,
                size: 20,
              ),
              DSSpacing.sm.x,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DSCaptionText(
                      planFreeUsageAppointmentsLabel(
                        activeAppointments,
                        PlanAccessPolicy.freeMaxActiveAppointments,
                      ),
                      color: HubColors.ink,
                      fontWeight: FontWeight.w600,
                    ),
                    DSSpacing.xxs.y,
                    DSCaptionText(
                      planFreeUsageSeriesLabel(
                        activeSeries,
                        PlanAccessPolicy.freeMaxActiveSeries,
                      ),
                      color: HubColors.inkMuted,
                    ),
                    if (atAppointmentLimit || atSeriesLimit) ...[
                      DSSpacing.xs.y,
                      DSCaptionText(
                        planUpgradeHintString,
                        color: HubColors.inkMuted,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          DSSpacing.sm.y,
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => context.go(AppRouters.planSettings),
              child: Text(planFreeUsageUpgradeActionString),
            ),
          ),
        ],
      ),
    );
  }
}
