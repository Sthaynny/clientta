import 'package:ufersa_hub/features/classes/domain/models/class_entry.dart';

abstract class ClassRepository {
  Future<List<ClassEntry>> getAll();

  Future<void> save(ClassEntry entry);

  Future<void> delete(String id);
}
