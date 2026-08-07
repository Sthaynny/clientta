import 'package:flutter/material.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/core/theme/hub_theme.dart';

/// Diálogos de confirmação com ação destrutiva em hierarquia secundária.
Future<bool?> showHubConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  String? cancelLabel,
  bool destructive = true,
}) {
  final resolvedCancelLabel = cancelLabel ?? cancelString;
  return showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Semantics(header: true, child: Text(title)),
          content: Text(message),
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                minimumSize: const Size(0, HubTheme.minTouchTarget),
              ),
              child: Text(resolvedCancelLabel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: destructive ? HubColors.error : HubColors.seed,
                minimumSize: const Size(0, HubTheme.minTouchTarget),
              ),
              child: Text(confirmLabel),
            ),
          ],
        ),
  );
}

enum HubChoiceResult { first, second, cancelled }

Future<HubChoiceResult> showHubChoiceDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String firstLabel,
  required String secondLabel,
  String? cancelLabel,
  bool secondDestructive = false,
}) async {
  final resolvedCancelLabel = cancelLabel ?? cancelString;
  final result = await showDialog<int>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Semantics(header: true, child: Text(title)),
          content: Text(message),
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(0),
              style: TextButton.styleFrom(
                minimumSize: const Size(0, HubTheme.minTouchTarget),
              ),
              child: Text(resolvedCancelLabel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(1),
              style: TextButton.styleFrom(
                foregroundColor: HubColors.seed,
                minimumSize: const Size(0, HubTheme.minTouchTarget),
              ),
              child: Text(firstLabel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(2),
              style: TextButton.styleFrom(
                foregroundColor:
                    secondDestructive ? HubColors.error : HubColors.seed,
                minimumSize: const Size(0, HubTheme.minTouchTarget),
              ),
              child: Text(secondLabel),
            ),
          ],
        ),
  );

  return switch (result) {
    1 => HubChoiceResult.first,
    2 => HubChoiceResult.second,
    _ => HubChoiceResult.cancelled,
  };
}
