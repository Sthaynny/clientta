import 'dart:async';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:clientta/core/config/firebase_bootstrap.dart';
import 'package:clientta/core/dependecy/dependency.dart';
import 'package:clientta/core/theme/hub_colors.dart';
import 'package:clientta/features/auth/view/auth_gate.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await DSColors.inicialize(
        primaryColor: HubColors.seed,
        secundaryColor: HubColors.schedule,
      );
      await bootstrapFirebase();
      setup();
      runApp(const AuthGate());
    },
    (error, stackTrace) {
      Logger('main').severe(error, stackTrace);
    },
  );
}
