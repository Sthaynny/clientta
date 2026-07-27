import 'package:flutter/material.dart';
import 'package:university_hub/core/strings/strings.dart';
import 'package:university_hub/features/shared/hub/hub_empty_state.dart';

class BodyErrorDefaultWidget extends StatelessWidget {
  const BodyErrorDefaultWidget({
    super.key,
    required this.title,
    this.onPressed,
  });

  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return HubEmptyState(
      icon: Icons.wifi_off_rounded,
      title: title,
      message: 'Verifique o armazenamento do aparelho e tente de novo.',
      actionLabel: tenteNovamenteString,
      onAction: onPressed,
    );
  }
}
