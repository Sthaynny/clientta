// Smoke do fluxo inicial (AuthGate → home ou login).
//
// Rodar:
//   flutter test integration_test/app_test.dart
//   flutter test integration_test
//
// Firebase está configurado só para Android/iOS; use emulador ou dispositivo:
//   flutter test integration_test -d <device_id>

import 'package:clientta/core/dependecy/dependency.dart';
import 'package:clientta/core/storage/device_json_store.dart';
import 'package:clientta/core/strings/daily_strings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('fluxo inicial do app', () {
    setUp(() async {
      if (!integrationTestPlatformSupported) return;
      await bootstrapIntegrationTestApp();
    });

    tearDown(() async {
      if (dependency.isRegistered<DeviceJsonStore>()) {
        await dependency.reset();
      }
    });

    testWidgets(
      'após bootstrap exibe home ou tela de login',
      (tester) async {
        if (!integrationTestPlatformSupported) {
          markTestSkipped('Firebase disponível apenas em Android/iOS');
        }

        await pumpAuthGate(tester);

        expectHomeOrLoginShell();
        expect(find.text(onboardingSkipString), findsNothing);
      },
      // Skip em desktop/web: Firebase só em Android/iOS.
      skip: !integrationTestPlatformSupported,
    );
  });
}
