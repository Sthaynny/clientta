import 'dart:async';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:ufersa_hub/core/dependecy/dependency.dart';
import 'package:ufersa_hub/core/theme/hub_colors.dart';
import 'package:ufersa_hub/features/app.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await DSColors.inicialize(
        primaryColor: HubColors.seed,
        secundaryColor: HubColors.schedule,
      );
      setup();
      runApp(const MyApp());
    },
    (error, stackTrace) {
      Logger('main').severe(error, stackTrace);
    },
  );
}
