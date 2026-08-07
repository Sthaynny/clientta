import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/dependecy/dependency.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/utils/extension/build_context.dart';
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
  Map<String, dynamic> _pricing = {};

  BillingRepository get _billing => dependency<BillingRepository>();

  @override
  void initState() {
    super.initState();
    _loadPricing();
  }

  Future<void> _loadPricing() async {
    try {
      final pricing = await _billing.getPlanPricing();
      if (!mounted) return;
      setState(() {
        _pricing = pricing;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _subscribe() async {
    try {
      final checkout = await _billing.createSubscription(
        planId: 'pro',
        returnUrl: buildBillingReturnUrl(),
      );

      if (checkout.isSandboxCheckout) {
        final subscription = await _billing.completeSandboxSubscription();
        if (!mounted) return;
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
  }

  @override
  Widget build(BuildContext context) {
    final pro = _pricing['pro'] as Map<String, dynamic>?;
    final price = pro?['price'] as String? ?? 'R\$ 29,90/mês';

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
                  HubPrimaryButton(
                    label: planSubscribeButtonString,
                    onPressed: _subscribe,
                  ),
                ],
              ),
    );
  }
}
