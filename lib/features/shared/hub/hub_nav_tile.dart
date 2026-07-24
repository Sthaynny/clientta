import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/router/app_router.dart';
import 'package:ufersa_hub/core/theme/hub_colors.dart';
import 'package:ufersa_hub/core/utils/extension/build_context.dart';

class HubNavTile extends StatelessWidget {
  const HubNavTile({
    super.key,
    required this.icon,
    required this.label,
    required this.route,
    this.isSelected = false,
  });

  final IconData icon;
  final String label;
  final AppRouters route;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final bg = isSelected ? HubColors.successTint : Colors.transparent;
    final fg = isSelected ? HubColors.seed : HubColors.ink;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DSSpacing.sm.value,
        vertical: DSSpacing.xxs.value,
      ),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(DSSpacing.sm.value),
        child: ListTile(
          leading: Icon(icon, color: fg),
          title: Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: fg,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DSSpacing.sm.value),
          ),
          onTap: () {
            Navigator.pop(context);
            context.go(route);
          },
        ),
      ),
    );
  }
}
