import 'package:flutter/material.dart';
import 'package:clientta/core/dependecy/dependency.dart';
import 'package:clientta/features/shared/hub/hub_loading_skeletons.dart';
import 'package:clientta/core/router/app_navigator.dart';
import 'package:clientta/core/router/app_router.dart';
import 'package:clientta/core/router/hub_route_observer.dart';
import 'package:clientta/core/storage/app_profile_repository.dart';
import 'package:clientta/core/strings/app_mission.dart';
import 'package:clientta/core/theme/hub_theme.dart';
import 'package:clientta/features/onboarding/view/onboarding_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _ready = false;
  bool _onboardingSeen = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final settings = await dependency<AppProfileRepository>().load();
    setState(() {
      _onboardingSeen = settings.onboardingSeen;
      _ready = true;
    });
  }

  Future<void> _finishOnboarding({bool openForm = false}) async {
    final repo = dependency<AppProfileRepository>();
    final settings = await repo.load();
    await repo.save(settings.copyWith(onboardingSeen: true));
    setState(() {
      _onboardingSeen = true;
    });
    if (openForm) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppNavigator.key.currentState?.pushNamed(AppRouters.appointmentForm.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return MaterialApp(
        theme: HubTheme.light(),
        darkTheme: HubTheme.dark(),
        themeMode: ThemeMode.system,
        home: const Scaffold(
          body: HubBootstrapLoadingSkeleton(),
        ),
      );
    }

    if (!_onboardingSeen) {
      return MaterialApp(
        theme: HubTheme.light(),
        darkTheme: HubTheme.dark(),
        themeMode: ThemeMode.system,
        home: OnboardingScreen(
          onSkip: () => _finishOnboarding(),
          onRegister: () => _finishOnboarding(openForm: true),
        ),
      );
    }

    return MaterialApp(
      navigatorKey: AppNavigator.key,
      title: AppMission.name,
      theme: HubTheme.light(),
      darkTheme: HubTheme.dark(),
      themeMode: ThemeMode.system,
      initialRoute: AppRouters.home.path,
      routes: routes,
      navigatorObservers: [hubRouteObserver],
    );
  }
}
