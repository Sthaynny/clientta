import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/router/app_router.dart';
import 'package:ufersa_hub/core/strings/app_mission.dart';
import 'package:ufersa_hub/core/theme/hub_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppMission.name,
      theme: HubTheme.light(),
      initialRoute: AppRouters.home.path,
      routes: routes,
    );
  }
}
