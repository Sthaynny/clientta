import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/features/shared/hub/hub_shimmer.dart';
import 'package:clientta/features/shared/hub/hub_surface.dart';

/// Skeleton genérico — lista de cards de atendimento (agenda, fallback).
class HubAppointmentListLoadingSkeleton extends StatelessWidget {
  const HubAppointmentListLoadingSkeleton({
    super.key,
    this.itemCount = 4,
    this.showIntro = false,
    this.showFilter = false,
  });

  final int itemCount;
  final bool showIntro;
  final bool showFilter;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: loadingContentString,
      child: HubShimmer(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(DSSpacing.md.value),
          children: [
            if (showIntro) ...[
              _IntroStripSkeleton(),
              DSSpacing.md.y,
            ],
            HubShimmerBox(height: 24, width: 160),
            DSSpacing.sm.y,
            if (showFilter) ...[
              HubShimmerBox(height: 14, width: 120),
              DSSpacing.sm.y,
              Row(
                children: [
                  HubShimmerBox(height: 32, width: 72, radius: DSSpacing.xs.value),
                  DSSpacing.xs.x,
                  HubShimmerBox(height: 32, width: 96, radius: DSSpacing.xs.value),
                  DSSpacing.xs.x,
                  HubShimmerBox(height: 32, width: 88, radius: DSSpacing.xs.value),
                ],
              ),
              DSSpacing.md.y,
            ],
            for (var i = 0; i < itemCount; i++) ...[
              const HubAppointmentCardSkeleton(),
              if (i < itemCount - 1) DSSpacing.sm.y,
            ],
          ],
        ),
      ),
    );
  }
}

/// Skeleton do painel do dia (`/`).
class HubHomeLoadingSkeleton extends StatelessWidget {
  const HubHomeLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: loadingContentString,
      child: HubShimmer(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(DSSpacing.md.value),
          children: [
            _IntroStripSkeleton(),
            DSSpacing.md.y,
            HubShimmerBox(height: 128, radius: DSSpacing.md.value),
            DSSpacing.md.y,
            HubShimmerBox(height: 56, radius: DSSpacing.md.value),
            DSSpacing.lg.y,
            HubShimmerBox(height: 22, width: 180),
            DSSpacing.sm.y,
            const HubAppointmentCardSkeleton(),
            DSSpacing.sm.y,
            const HubAppointmentCardSkeleton(),
          ],
        ),
      ),
    );
  }
}

/// Skeleton da lista de clientes (`/clientes`).
class HubClientListLoadingSkeleton extends StatelessWidget {
  const HubClientListLoadingSkeleton({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: loadingContentString,
      child: HubShimmer(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(DSSpacing.md.value),
          children: [
            _IntroStripSkeleton(),
            DSSpacing.md.y,
            HubShimmerBox(height: 22, width: 140),
            DSSpacing.sm.y,
            HubShimmerBox(height: 52, radius: DSSpacing.sm.value),
            DSSpacing.md.y,
            for (var i = 0; i < itemCount; i++) ...[
              const HubClientCardSkeleton(),
              if (i < itemCount - 1) DSSpacing.sm.y,
            ],
          ],
        ),
      ),
    );
  }
}

/// Skeleton da tela de atendimento (`/atendimentos`).
class HubClientCareLoadingSkeleton extends StatelessWidget {
  const HubClientCareLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: loadingContentString,
      child: HubShimmer(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(DSSpacing.md.value),
          children: [
            HubSurface(
              padding: EdgeInsets.all(DSSpacing.md.value),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      HubShimmerBox(
                        width: 56,
                        height: 56,
                        radius: 28,
                      ),
                      DSSpacing.md.x,
                      Expanded(
                        child: Column(
                          children: [
                            HubShimmerBox(height: 20),
                            DSSpacing.xs.y,
                            HubShimmerBox(height: 14, width: 120),
                          ],
                        ),
                      ),
                    ],
                  ),
                  DSSpacing.md.y,
                  Row(
                    children: [
                      Expanded(child: HubShimmerBox(height: 44)),
                      DSSpacing.sm.x,
                      Expanded(child: HubShimmerBox(height: 44)),
                    ],
                  ),
                ],
              ),
            ),
            DSSpacing.lg.y,
            _IntroStripSkeleton(),
            DSSpacing.md.y,
            const HubTimelineEntrySkeleton(),
            DSSpacing.sm.y,
            const HubTimelineEntrySkeleton(),
          ],
        ),
      ),
    );
  }
}

/// Skeleton da tela de plano (`/plano`).
class HubPlanLoadingSkeleton extends StatelessWidget {
  const HubPlanLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: loadingContentString,
      child: HubShimmer(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(DSSpacing.md.value),
          children: [
            HubShimmerBox(height: 72, radius: DSSpacing.md.value),
            DSSpacing.md.y,
            HubShimmerBox(height: 200, radius: DSSpacing.md.value),
            DSSpacing.lg.y,
            HubShimmerBox(height: 22, width: 140),
            DSSpacing.sm.y,
            Row(
              children: [
                Expanded(child: HubShimmerBox(height: 120, radius: DSSpacing.md.value)),
                DSSpacing.sm.x,
                Expanded(child: HubShimmerBox(height: 120, radius: DSSpacing.md.value)),
              ],
            ),
            DSSpacing.sm.y,
            Row(
              children: [
                Expanded(child: HubShimmerBox(height: 120, radius: DSSpacing.md.value)),
                DSSpacing.sm.x,
                Expanded(child: HubShimmerBox(height: 120, radius: DSSpacing.md.value)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton de bootstrap (app / auth gate).
class HubBootstrapLoadingSkeleton extends StatelessWidget {
  const HubBootstrapLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: loadingContentString,
      child: HubShimmer(
        child: Padding(
          padding: EdgeInsets.all(DSSpacing.xl.value),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HubShimmerBox(width: 64, height: 64, radius: 32),
              DSSpacing.lg.y,
              HubShimmerBox(height: 28, width: 220),
              DSSpacing.sm.y,
              HubShimmerBox(height: 16, width: 280),
              DSSpacing.xl.y,
              HubSurface(
                padding: EdgeInsets.all(DSSpacing.lg.value),
                child: Column(
                  children: [
                    HubShimmerBox(height: 48, radius: DSSpacing.sm.value),
                    DSSpacing.md.y,
                    HubShimmerBox(height: 48, radius: DSSpacing.sm.value),
                    DSSpacing.md.y,
                    HubShimmerBox(height: 48, radius: DSSpacing.sm.value),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HubAppointmentCardSkeleton extends StatelessWidget {
  const HubAppointmentCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return HubSurface(
      padding: EdgeInsets.all(DSSpacing.md.value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HubShimmerBox(width: 56, height: 52),
          DSSpacing.md.x,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HubShimmerBox(height: 18),
                DSSpacing.xs.y,
                HubShimmerBox(height: 14, width: 140),
                DSSpacing.xs.y,
                HubShimmerBox(height: 14, width: 96),
                DSSpacing.xs.y,
                HubShimmerBox(height: 22, width: 88, radius: DSSpacing.xs.value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HubClientCardSkeleton extends StatelessWidget {
  const HubClientCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return HubSurface(
      padding: EdgeInsets.all(DSSpacing.md.value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HubShimmerBox(width: 48, height: 48, radius: 24),
          DSSpacing.md.x,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HubShimmerBox(height: 18),
                DSSpacing.xs.y,
                HubShimmerBox(height: 14, width: 160),
                DSSpacing.xs.y,
                HubShimmerBox(height: 22, width: 100, radius: DSSpacing.xs.value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HubTimelineEntrySkeleton extends StatelessWidget {
  const HubTimelineEntrySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return HubSurface(
      padding: EdgeInsets.all(DSSpacing.md.value),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              HubShimmerBox(height: 22, width: 120, radius: DSSpacing.xs.value),
              const Spacer(),
              HubShimmerBox(height: 14, width: 80),
            ],
          ),
          DSSpacing.sm.y,
          HubShimmerBox(height: 14),
          DSSpacing.xxs.y,
          HubShimmerBox(height: 14, width: 200),
        ],
      ),
    );
  }
}

class _IntroStripSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HubSurface(
      tint: HubColors.canvas,
      padding: EdgeInsets.all(DSSpacing.md.value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HubShimmerBox(width: 28, height: 28, radius: DSSpacing.xs.value),
          DSSpacing.sm.x,
          Expanded(
            child: Column(
              children: [
                HubShimmerBox(height: 14),
                DSSpacing.xxs.y,
                HubShimmerBox(height: 14, width: 180),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
