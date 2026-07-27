import 'package:university_hub/core/strings/daily_strings.dart';
import 'package:university_hub/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'utils/waits_fuctions.dart';

void main() {
  patrolWidgetTest('open home screen', ($) async {
    final tester = $.tester;
    app.main();

    await waitFor(
      tester,
      find.text(classesTodayString),
    );

    final icon = find.byKey(const Key('menu_button'));
    expect(icon, findsOneWidget);

    await $.tap(icon);
    await $.pumpAndSettle();

    expect(find.text(myScheduleString), findsOneWidget);
  });
}
