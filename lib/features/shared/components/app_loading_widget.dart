import 'package:flutter/material.dart';
import 'package:clientta/features/shared/hub/hub_loading_skeletons.dart';

/// Loading padrão — skeleton shimmer de lista (não usar CircularProgressIndicator).
class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const HubAppointmentListLoadingSkeleton();
  }
}
