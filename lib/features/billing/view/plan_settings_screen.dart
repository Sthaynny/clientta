import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/dependecy/dependency.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/utils/extension/build_context.dart';
import 'package:clientta/features/billing/domain/entities/user_subscription.dart';
import 'package:clientta/features/billing/domain/repositories/billing_repository.dart';
import 'package:clientta/features/billing/shared/utils/billing_return_url.dart';
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

  BillingRepository get _billing => dependency<BillingRepository>();

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
    ]);

    if (!mounted) return;
    setState(() {
      _pricing = Map<String, dynamic>.from(results[0] as Map);
      _subscription = results[1] as UserSubscription;
      _loading = false;
    });
  }

  String _statusLabel(UserSubscription subscription) {
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(planCancelTitleString),
            content: Text(planCancelMessageString),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(cancelString),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: HubColors.error),
                child: Text(planCancelButtonString),
              ),
            ],
          ),
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
    final hasPro = _subscription.allowsOperationalAccess;
    final canCancel =
        _subscription.plan == SubscriptionPlan.pro &&
        _subscription.status != SubscriptionStatus.canceled;

    return Scaffold(
      appBar: HubAppBar(
        canPop: true,
        showBrandMark: false,
        title: planSettingsTitleString,
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
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
                          hasPro ? planManageProString : planUpgradeHintString,
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
                        DSHeadlineSmallText(
                          price,
                          color: HubColors.seed,
                        ),
                      ],
                    ),
                  ),
                  DSSpacing.lg.y,
                  if (!hasPro)
                    HubPrimaryButton(
                      label: planSubscribeButtonString,
                      isLoading: _actionLoading,
                      onPressed: _subscribe,
                    ),
                  if (hasPro || _subscription.plan == SubscriptionPlan.pro) ...[
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
