import 'package:design_system/design_system.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/legal/legal_url_launcher.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/utils/extension/build_context.dart';

/// Links legais: privacidade, assinatura Pro e exclusão de conta.
class HubLegalLinks extends StatelessWidget {
  const HubLegalLinks({
    super.key,
    this.alignment = WrapAlignment.center,
  });

  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: alignment,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: DSSpacing.xs.value,
      runSpacing: DSSpacing.xxs.value,
      children: [
        TextButton(
          onPressed: () => _openPrivacy(context),
          child: Text(
            privacyPolicyString,
            style: const TextStyle(
              color: HubColors.seed,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          '·',
          style: TextStyle(color: HubColors.inkMuted.withValues(alpha: 0.6)),
        ),
        TextButton(
          onPressed: () => _openSubscription(context),
          child: Text(
            subscriptionPolicyString,
            style: const TextStyle(
              color: HubColors.seed,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          '·',
          style: TextStyle(color: HubColors.inkMuted.withValues(alpha: 0.6)),
        ),
        TextButton(
          onPressed: () => _openAccountDeletion(context),
          child: Text(
            accountDeletionPolicyString,
            style: const TextStyle(
              color: HubColors.seed,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openPrivacy(BuildContext context) async {
    if (!await openPrivacyPolicy() && context.mounted) {
      context.showSnackBarError(legalUrlOpenErrorString);
    }
  }

  Future<void> _openSubscription(BuildContext context) async {
    if (!await openSubscriptionPolicy() && context.mounted) {
      context.showSnackBarError(legalUrlOpenErrorString);
    }
  }

  Future<void> _openAccountDeletion(BuildContext context) async {
    if (!await openAccountDeletion() && context.mounted) {
      context.showSnackBarError(legalUrlOpenErrorString);
    }
  }
}

/// Aviso de consentimento exibido no cadastro.
class HubLegalConsentNotice extends StatelessWidget {
  const HubLegalConsentNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final baseStyle = TextStyle(
      fontSize: 13,
      height: 1.45,
      color: HubColors.inkMuted.withValues(alpha: 0.95),
    );
    final linkStyle = baseStyle.copyWith(
      color: HubColors.seed,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
      decorationColor: HubColors.seed,
    );

    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: registerPrivacyNoticePrefixString),
          TextSpan(
            text: privacyPolicyString,
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                if (!await openPrivacyPolicy() && context.mounted) {
                  context.showSnackBarError(legalUrlOpenErrorString);
                }
              },
          ),
          TextSpan(text: registerPrivacyNoticeSuffixString),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
