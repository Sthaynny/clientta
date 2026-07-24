import 'package:flutter/widgets.dart';
import 'package:ufersa_hub/core/dependecy/dependency.dart';
import 'package:ufersa_hub/features/activities/domain/models/activity_entry.dart';
import 'package:ufersa_hub/features/activities/view/activities_screen.dart';
import 'package:ufersa_hub/features/activities/view/activity_form_screen.dart';
import 'package:ufersa_hub/features/activities/view/activity_form_view_model.dart';
import 'package:ufersa_hub/features/activities/view/activities_view_model.dart';
import 'package:ufersa_hub/features/classes/domain/models/class_entry.dart';
import 'package:ufersa_hub/features/classes/view/class_form_screen.dart';
import 'package:ufersa_hub/features/classes/view/class_form_view_model.dart';
import 'package:ufersa_hub/features/classes/view/classes_screen.dart';
import 'package:ufersa_hub/features/classes/view/classes_view_model.dart';
import 'package:ufersa_hub/features/home/screen/home_screen.dart';
import 'package:ufersa_hub/features/home/screen/home_view_model.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  AppRouters.home.path: (context) => HomeScreen(viewmodel: dependency()),
  AppRouters.classes.path: (context) => ClassesScreen(viewmodel: dependency()),
  AppRouters.classForm.path: (context) {
    final entry = ModalRoute.of(context)?.settings.arguments as ClassEntry?;
    return ClassFormScreen(
      viewmodel: ClassFormViewModel(
        repository: dependency(),
        initial: entry,
      ),
      isEdit: entry != null,
    );
  },
  AppRouters.activities.path:
      (context) => ActivitiesScreen(viewmodel: dependency()),
  AppRouters.activityForm.path: (context) {
    final entry =
        ModalRoute.of(context)?.settings.arguments as ActivityEntry?;
    return ActivityFormScreen(
      viewmodel: ActivityFormViewModel(
        repository: dependency(),
        initial: entry,
      ),
      isEdit: entry != null,
    );
  },
};

enum AppRouters {
  home,
  classes,
  classForm,
  activities,
  activityForm;

  const AppRouters();

  String get path => switch (this) {
    home => '/',
    classes => '/aulas',
    classForm => '/aulas/registrar',
    activities => '/atividades',
    activityForm => '/atividades/registrar',
  };
}
