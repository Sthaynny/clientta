import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/features/shared/components/app_icon.dart';

/// Layout compartilhado para telas de autenticação — limpo, focado e acessível.
class HubAuthScaffold extends StatelessWidget {
  const HubAuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.footer,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HubColors.canvas,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: DSSpacing.lg.value,
              vertical: DSSpacing.xl.value,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Semantics(
                    header: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppIcon.hub(size: 52),
                        DSSpacing.lg.y,
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: HubColors.ink,
                            letterSpacing: -0.03,
                            height: 1.15,
                          ),
                        ),
                        DSSpacing.sm.y,
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 16,
                            color: HubColors.inkMuted,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DSSpacing.xl.y,
                  child,
                  if (footer != null) ...[
                    DSSpacing.lg.y,
                    footer!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
