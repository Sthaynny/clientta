import 'package:flutter/material.dart';
import 'package:clientta/features/shared/hub/hub_section_header.dart';

/// Bloco da home com título e lista de conteúdo (cards individuais, sem container).
class HubHomeSection extends StatelessWidget {
  const HubHomeSection({
    super.key,
    required this.title,
    this.count,
    this.actionLabel,
    this.onAction,
    required this.child,
  });

  final String title;
  final int? count;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HubSectionHeader(
          title: title,
          count: count,
          actionLabel: actionLabel,
          onAction: onAction,
        ),
        child,
      ],
    );
  }
}
