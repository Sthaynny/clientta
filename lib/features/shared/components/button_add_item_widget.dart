import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:university_hub/features/shared/hub/hub_primary_button.dart';

class ButtonAddItemWidget extends StatelessWidget {
  const ButtonAddItemWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.isVisible = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Material(
        color: DSColors.transparent,
        borderRadius: BorderRadius.circular(DSSpacing.xs.value),
        elevation: 3,
        child: IgnorePointer(
          ignoring: !isVisible,
          child: HubPrimaryButton(
            onPressed: onPressed,
            label: label,
            trailingIcon: Icon(
              Icons.add,
              color: DSColors.neutralMediumWave,
              size: DSSpacing.lg.value,
            ),
          ),
        ),
      ),
    );
  }
}
