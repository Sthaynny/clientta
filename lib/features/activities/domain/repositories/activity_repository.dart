import 'package:university_hub/features/activities/domain/models/activity_entry.dart';

abstract class ActivityRepository {
  Future<List<ActivityEntry>> getAll();

  Future<void> save(ActivityEntry entry);

  Future<void> delete(String id);
}
