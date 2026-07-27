import 'package:university_hub/features/classes/domain/models/class_entry.dart';

abstract class ClassRepository {
  Future<List<ClassEntry>> getAll();

  Future<List<ClassEntry>> getBySeriesId(String seriesId);

  Future<void> save(ClassEntry entry);

  /// Persists [entries] (merge by id) and removes [deleteIds] in one write.
  Future<void> saveAll(
    List<ClassEntry> entries, {
    List<String> deleteIds = const [],
  });

  Future<void> delete(String id);
}
