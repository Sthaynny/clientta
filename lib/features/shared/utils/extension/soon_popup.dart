import 'package:university_hub/core/strings/strings.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

extension PopupExt on BuildContext {
  void showComingSoonPopup() {
    final context = this;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: DSHeadlineLargeText(soonString, textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.hourglass_empty, size: 50, color: DSColors.primary),
              DSSpacing.sm.y,
              DSBodyText(prepareAplicationString),
            ],
          ),
          actions: [
            DSGhostButton(
              onPressed: () => Navigator.pop(context),
              label: closeString,
            ),
          ],
        );
      },
    );
  }
}
