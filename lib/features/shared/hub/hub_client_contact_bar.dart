import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/theme/hub_theme.dart';
import 'package:clientta/core/utils/client_contact_launcher.dart';
import 'package:clientta/features/client_care/domain/client_phone_key.dart';

class HubClientContactBar extends StatelessWidget {
  const HubClientContactBar({
    super.key,
    required this.clientPhone,
    this.onLaunchFailed,
  });

  final String clientPhone;
  final VoidCallback? onLaunchFailed;

  bool get _hasPhone => normalizeClientPhone(clientPhone).isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (!_hasPhone) return const SizedBox.shrink();

    return Row(
      children: [
        Expanded(
          child: _ContactButton(
            label: clientCallActionString,
            icon: Icons.phone_outlined,
            color: HubColors.seed,
            onPressed: () => _launch(
              context,
              () => launchClientPhoneCall(clientPhone),
            ),
          ),
        ),
        DSSpacing.sm.x,
        Expanded(
          child: _ContactButton(
            label: clientWhatsAppActionString,
            icon: Icons.chat_outlined,
            color: const Color(0xFF25D366),
            onPressed: () => _launch(
              context,
              () => launchClientWhatsApp(clientPhone),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _launch(
    BuildContext context,
    Future<bool> Function() action,
  ) async {
    final launched = await action();
    if (!launched && context.mounted) {
      onLaunchFailed?.call();
    }
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton({
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
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18, color: color),
        label: Text(
          label,
          style: TextStyle(
            color: HubColors.ink,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, HubTheme.minTouchTarget),
          padding: EdgeInsets.symmetric(
            horizontal: DSSpacing.sm.value,
            vertical: DSSpacing.xs.value,
          ),
          side: BorderSide(color: HubColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DSSpacing.xs.value),
          ),
        ),
      ),
    );
  }
}
