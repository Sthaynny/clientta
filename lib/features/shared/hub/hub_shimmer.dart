import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:clientta/core/theme/hub_colors.dart';

/// Shimmer Hub — respeita `disableAnimations` e paleta Clientta.
class HubShimmer extends StatelessWidget {
  const HubShimmer({
    super.key,
    required this.child,
    this.enabled = true,
  });

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled || MediaQuery.disableAnimationsOf(context)) {
      return child;
    }

    return Shimmer.fromColors(
      baseColor: HubColors.border,
      highlightColor: HubColors.canvas,
      period: const Duration(milliseconds: 1100),
      child: child,
    );
  }
}

/// Placeholder retangular para skeletons — usar dentro de [HubShimmer].
class HubShimmerBox extends StatelessWidget {
  const HubShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.radius,
    this.color = HubColors.border,
  });

  final double? width;
  final double height;
  final double? radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          radius ?? DSSpacing.xs.value,
        ),
      ),
    );
  }
}
