import 'package:clientta/core/config/firebase_bootstrap.dart';
import 'package:clientta/core/dependecy/dependency.dart';
import 'package:clientta/core/storage/app_profile_repository.dart';
import 'package:clientta/core/storage/device_json_store.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/features/auth/view/auth_gate.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Platforms where [firebase_options.dart] is configured.
bool get integrationTestPlatformSupported =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS);

/// Mirrors [main] bootstrap without [runApp].
Future<void> bootstrapIntegrationTestApp() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await DSColors.inicialize(
    primaryColor: HubColors.seed,
    secundaryColor: HubColors.schedule,
  );
  await bootstrapFirebase();
  await resetDependencyInjection();
  setup();
  await markOnboardingSeen();
}

Future<void> resetDependencyInjection() async {
  if (dependency.isRegistered<DeviceJsonStore>()) {
    await dependency.reset();
  }
}

/// Marks onboarding as seen so [MyApp] skips [OnboardingScreen].
Future<void> markOnboardingSeen() async {
  final repo = dependency<AppProfileRepository>();
  final settings = await repo.load();
  await repo.save(settings.copyWith(onboardingSeen: true));
}

Future<void> pumpAuthGate(WidgetTester tester) async {
  await tester.pumpWidget(const AuthGate());
  await tester.pumpAndSettle(const Duration(seconds: 30));
}

/// Authenticated users land on home; guests see the login shell.
void expectHomeOrLoginShell() {
  final onHome = find.text(homeTodayString);
  final onLogin = find.text(loginWelcomeString);

  expect(
    onHome.evaluate().isNotEmpty || onLogin.evaluate().isNotEmpty,
    isTrue,
    reason:
        'Esperado painel do dia ("$homeTodayString") ou login ("$loginWelcomeString")',
  );
}
