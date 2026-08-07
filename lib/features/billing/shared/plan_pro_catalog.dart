import 'package:flutter/material.dart';
import 'package:clientta/core/strings/daily_strings.dart';

class PlanProBenefitItem {
  const PlanProBenefitItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

List<PlanProBenefitItem> buildPlanProBenefitCatalog() => [
  PlanProBenefitItem(
    icon: Icons.event_available_outlined,
    title: planProBenefitLimitsTitleString,
    description: planProBenefitLimitsDescString,
  ),
  PlanProBenefitItem(
    icon: Icons.devices_outlined,
    title: planProBenefitSyncTitleString,
    description: planProBenefitSyncDescString,
  ),
  PlanProBenefitItem(
    icon: Icons.notifications_active_outlined,
    title: planProBenefitRemindersTitleString,
    description: planProBenefitRemindersDescString,
  ),
  PlanProBenefitItem(
    icon: Icons.cloud_download_outlined,
    title: planProBenefitBackupTitleString,
    description: planProBenefitBackupDescString,
  ),
];
