import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/storage/app_profile_settings.dart';
import 'package:clientta/core/storage/app_profile_repository.dart';
import 'package:clientta/features/appointments/data/appointment_reminder_coordinator.dart';
import 'package:clientta/features/appointments/data/appointment_sync_service.dart';
import 'package:clientta/features/appointments/domain/reminders/appointment_reminder_settings.dart';
import 'package:clientta/core/backup/data_backup_service.dart';
import 'package:clientta/core/dependecy/dependency.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/utils/extension/build_context.dart';
import 'package:clientta/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:clientta/features/billing/domain/entities/plan_pricing_catalog.dart';
import 'package:clientta/features/billing/domain/entities/user_subscription.dart';
import 'package:clientta/features/billing/domain/repositories/billing_repository.dart';
import 'package:clientta/features/billing/shared/utils/billing_return_url.dart';
import 'package:clientta/features/shared/components/app_loading_widget.dart';
import 'package:clientta/features/shared/hub/hub.dart';
import 'package:url_launcher/url_launcher.dart';

class PlanSettingsScreen extends StatefulWidget {
  const PlanSettingsScreen({super.key});

  @override
  State<PlanSettingsScreen> createState() => _PlanSettingsScreenState();
}

class _PlanSettingsScreenState extends State<PlanSettingsScreen> {
  bool _loading = true;
  bool _actionLoading = false;
  Map<String, dynamic> _pricing = {};
  UserSubscription _subscription = UserSubscription.inactive;
  AppointmentReminderSettings _reminderSettings =
      const AppointmentReminderSettings();

  BillingRepository get _billing => dependency<BillingRepository>();
  AppointmentReminderCoordinator get _reminders =>
      dependency<AppointmentReminderCoordinator>();
  AppointmentSyncService get _sync => dependency<AppointmentSyncService>();
  AppProfileRepository get _profile => dependency<AppProfileRepository>();
  AppointmentRepository get _appointments => dependency<AppointmentRepository>();
  DataBackupService get _backup => dependency<DataBackupService>();

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    setState(() {
      _loading = true;
    });

    final results = await Future.wait([
      _billing.getPlanPricing(),
      _billing.getSubscription(),
      _profile.load(),
    ]);

    if (!mounted) return;
    setState(() {
      _pricing = Map<String, dynamic>.from(results[0] as Map);
      _subscription = results[1] as UserSubscription;
      _reminderSettings =
          (results[2] as AppProfileSettings).appointmentReminders;
      _loading = false;
    });
  }

  Future<void> _persistReminderSettings(AppointmentReminderSettings settings) async {
    final appointments = await _appointments.getAll();
    await _reminders.persistSettingsAndSync(
      settings: settings,
      appointments: appointments,
    );
    if (!mounted) return;
    setState(() => _reminderSettings = settings);
    context.showSnackBarSuccess(reminderSettingsSavedString);
  }

  Future<void> _exportBackup() async {
    if (!_subscription.allowsOperationalAccess) {
      context.showSnackBarWarning(planBackupProRequiredString);
      return;
    }

    await _runAction(() async {
      final result = await _backup.shareBackup();
      if (!mounted) return;
      switch (result) {
        case Ok():
          context.showSnackBarSuccess(planBackupExportSuccessString);
        case Error(:final error):
          final message = error.toString();
          if (message.contains('pro_required')) {
            context.showSnackBarWarning(planBackupProRequiredString);
          } else {
            context.showSnackBarError(planBackupExportErrorString);
          }
      }
    });
  }

  Future<void> _importBackup() async {
    if (!_subscription.allowsOperationalAccess) {
      context.showSnackBarWarning(planBackupProRequiredString);
      return;
    }

    final confirmed = await showHubConfirmDialog(
      context: context,
      title: planBackupImportTitleString,
      message: planBackupImportMessageString,
      confirmLabel: planBackupImportConfirmButtonString,
    );
    if (confirmed != true || !mounted) return;

    await _runAction(() async {
      final result = await _backup.importBackup();
      if (!mounted) return;
      switch (result) {
        case Ok(:final value):
          final appointments = await _appointments.getAll();
          await _reminders.syncForAppointments(appointments);
          if (await _sync.canSync()) {
            _sync.scheduleSync();
          }
          if (!mounted) return;
          final summary = value!;
          context.showSnackBarSuccess(
            planBackupImportSuccessString(
              appointments: summary.appointmentCount,
              notes: summary.encounterNoteCount,
            ),
          );
        case Error(:final error):
          final message = error.toString();
          if (message.contains('pro_required')) {
            context.showSnackBarWarning(planBackupProRequiredString);
          } else if (message.contains('cancelled')) {
            return;
          } else if (message.contains('invalid_format')) {
            context.showSnackBarError(planBackupImportInvalidString);
          } else {
            context.showSnackBarError(planBackupImportErrorString);
          }
      }
    });
  }

  String _statusLabel(UserSubscription subscription) {
    if (subscription.isComplimentaryAccess &&
        subscription.allowsOperationalAccess) {
      return planStatusProComplimentaryString;
    }

    if (subscription.allowsOperationalAccess &&
        subscription.plan == SubscriptionPlan.pro) {
      return planStatusProActiveString;
    }

    return switch (subscription.status) {
      SubscriptionStatus.pastDue => planStatusProPastDueString,
      SubscriptionStatus.canceled => planStatusProCanceledString,
      SubscriptionStatus.inactive when subscription.plan == SubscriptionPlan.pro =>
        planStatusProPendingString,
      _ => planStatusFreeString,
    };
  }

  Future<void> _runAction(Future<void> Function() action) async {
    if (_actionLoading) return;
    setState(() => _actionLoading = true);
    try {
      await action();
    } finally {
      if (mounted) {
        setState(() => _actionLoading = false);
      }
    }
  }

  Future<void> _subscribe() async {
    await _runAction(() async {
      try {
        final checkout = await _billing.createSubscription(
          planId: 'pro',
          returnUrl: buildBillingReturnUrl(),
        );

        if (checkout.isFreeAccess) {
          final subscription = await _billing.getSubscription();
          if (!mounted) return;
          setState(() => _subscription = subscription);
          context.showSnackBarSuccess(planSubscribeSuccessString);
          return;
        }

        if (checkout.isSandboxCheckout) {
          final subscription = await _billing.completeSandboxSubscription();
          if (!mounted) return;
          setState(() => _subscription = subscription);
          context.showSnackBarSuccess(
            subscription.allowsOperationalAccess
                ? planSubscribeSuccessString
                : planSubscribePendingString,
          );
          return;
        }

        if (checkout.checkoutUrl.isNotEmpty) {
          final uri = Uri.parse(checkout.checkoutUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }

        if (!mounted) return;
        context.showSnackBarSuccess(planSubscribePendingString);
      } catch (_) {
        if (!mounted) return;
        context.showSnackBarError(planSubscribeErrorString);
      }
    });
  }

  Future<void> _syncStatus() async {
    await _runAction(() async {
      try {
        final subscription = await _billing.syncSubscriptionStatus();
        if (!mounted) return;
        setState(() => _subscription = subscription);
        context.showSnackBarSuccess(planSyncSuccessString);
      } catch (_) {
        if (!mounted) return;
        context.showSnackBarError(planSyncErrorString);
      }
    });
  }

  Future<void> _cancelSubscription() async {
    final confirmed = await showHubConfirmDialog(
      context: context,
      title: planCancelTitleString,
      message: planCancelMessageString,
      confirmLabel: planCancelButtonString,
      destructive: true,
    );

    if (confirmed != true || !mounted) return;

    await _runAction(() async {
      try {
        final subscription = await _billing.cancelSubscription();
        if (!mounted) return;
        setState(() => _subscription = subscription);
        context.showSnackBarSuccess(planCancelSuccessString);
      } catch (_) {
        if (!mounted) return;
        context.showSnackBarError(planCancelErrorString);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pro = _pricing['pro'] as Map<String, dynamic>?;
    final price = pro?['price'] as String? ?? 'R\$ 29,90/mês';
    final basePrice = pro?['baseMonthlyPriceCents'] as int?;
    final percentOff = pro?['percentOff'] as int?;
    final hasDiscount = percentOff != null && percentOff > 0;
    final hasPro = _subscription.allowsOperationalAccess;
    final isComplimentary = _subscription.isComplimentaryAccess;
    final canCancel =
        _subscription.plan == SubscriptionPlan.pro &&
        _subscription.status != SubscriptionStatus.canceled &&
        !isComplimentary;

    return Scaffold(
      appBar: HubAppBar(
        canPop: true,
        showBrandMark: false,
        title: planSettingsTitleString,
      ),
      body:
          _loading
              ? const AppLoadingWidget()
              : ListView(
                padding: EdgeInsets.all(DSSpacing.md.value),
                children: [
                  HubSurface(
                    padding: EdgeInsets.all(DSSpacing.lg.value),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DSCaptionText(
                          planCurrentStatusLabelString,
                          color: HubColors.inkMuted,
                        ),
                        DSSpacing.xs.y,
                        DSHeadlineSmallText(
                          _statusLabel(_subscription),
                          color: hasPro ? HubColors.seed : HubColors.ink,
                        ),
                        DSSpacing.md.y,
                        DSBodyText(
                          hasPro
                              ? (isComplimentary
                                  ? planComplimentaryAccessString
                                  : planManageProString)
                              : planUpgradeHintString,
                          color: HubColors.inkMuted,
                        ),
                        DSSpacing.sm.y,
                        DSBodyText(
                          planInactivityPolicyString,
                          color: HubColors.inkMuted,
                        ),
                      ],
                    ),
                  ),
                  DSSpacing.lg.y,
                  HubSurface(
                    padding: EdgeInsets.all(DSSpacing.lg.value),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DSHeadlineSmallText(
                          planProTitleString,
                          color: HubColors.ink,
                        ),
                        DSSpacing.sm.y,
                        DSBodyText(
                          planProDescriptionString,
                          color: HubColors.inkMuted,
                        ),
                        DSSpacing.md.y,
                        HubProBenefitsList(benefits: planProBenefits),
                        DSSpacing.md.y,
                        if (hasDiscount && !hasPro) ...[
                          DSBodyText(
                            planDiscountAppliedString(percentOff),
                            color: HubColors.seed,
                          ),
                          DSSpacing.xs.y,
                        ],
                        DSHeadlineSmallText(
                          price,
                          color: HubColors.seed,
                        ),
                        if (hasDiscount && basePrice != null && !hasPro) ...[
                          DSSpacing.xs.y,
                          DSBodyText(
                            '$planBasePriceLabelString: ${PlanPricingCatalog.formatBrlMonthly(basePrice)}',
                            color: HubColors.inkMuted,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (hasPro) ...[
                    DSSpacing.lg.y,
                    HubSurface(
                      padding: EdgeInsets.all(DSSpacing.lg.value),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DSHeadlineSmallText(
                            planReminderSectionTitleString,
                            color: HubColors.ink,
                          ),
                          DSSpacing.sm.y,
                          HubSwitchFormField(
                            label: planReminderEnableLabelString,
                            subtitle: planReminderEnableSubtitleString,
                            value: _reminderSettings.enabled,
                            onChanged: (enabled) {
                              _persistReminderSettings(
                                _reminderSettings.copyWith(enabled: enabled),
                              );
                            },
                          ),
                          if (_reminderSettings.enabled) ...[
                            DSSpacing.md.y,
                            DSCaptionText(
                              planReminderLeadLabelString,
                              color: HubColors.inkMuted,
                              fontWeight: FontWeight.w600,
                            ),
                            DSSpacing.sm.y,
                            HubReminderLeadChips(
                              selectedMinutes: _reminderSettings.leadMinutes,
                              onChanged: (minutes) {
                                _persistReminderSettings(
                                  _reminderSettings.copyWith(
                                    leadMinutes: minutes,
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                    DSSpacing.lg.y,
                    HubSurface(
                      padding: EdgeInsets.all(DSSpacing.lg.value),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DSHeadlineSmallText(
                            planBackupSectionTitleString,
                            color: HubColors.ink,
                          ),
                          DSSpacing.sm.y,
                          DSBodyText(
                            planBackupDescriptionString,
                            color: HubColors.inkMuted,
                          ),
                          DSSpacing.md.y,
                          HubPrimaryButton(
                            label: planBackupExportButtonString,
                            isLoading: _actionLoading,
                            onPressed: _exportBackup,
                          ),
                          DSSpacing.sm.y,
                          Center(
                            child: TextButton(
                              onPressed: _actionLoading ? null : _importBackup,
                              child: Text(
                                planBackupImportButtonString,
                                style: const TextStyle(color: HubColors.seed),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  DSSpacing.lg.y,
                  if (!hasPro)
                    HubPrimaryButton(
                      label: planSubscribeButtonString,
                      isLoading: _actionLoading,
                      onPressed: _subscribe,
                    ),
                  if ((hasPro || _subscription.plan == SubscriptionPlan.pro) &&
                      !isComplimentary) ...[
                    HubPrimaryButton(
                      label: planSyncStatusButtonString,
                      isLoading: _actionLoading,
                      onPressed: _syncStatus,
                    ),
                    if (canCancel) ...[
                      DSSpacing.sm.y,
                      Center(
                        child: TextButton(
                          onPressed: _actionLoading ? null : _cancelSubscription,
                          child: Text(
                            planCancelButtonString,
                            style: const TextStyle(color: HubColors.error),
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
    );
  }
}
