import 'package:ufersa_hub/core/strings/daily_strings.dart';
import 'package:ufersa_hub/features/classes/domain/models/class_entry.dart';

/// One card in "Minha grade" — entries sharing [ClassEntry.seriesId], or a lone legacy row.
class ClassScheduleGroup {
  const ClassScheduleGroup({required this.entries});

  final List<ClassEntry> entries;

  ClassEntry get representative => entries.first;

  List<String> get entryIds => entries.map((e) => e.id).toList();

  String get combinedWeekdayLabel => entries
      .map((e) => weekdayShortLabels[e.weekday - 1])
      .join(', ');

  static String groupKeyFor(ClassEntry entry) => entry.seriesId ?? entry.id;

  static List<ClassScheduleGroup> fromEntries(List<ClassEntry> all) {
    final byKey = <String, List<ClassEntry>>{};
    for (final entry in all) {
      final key = groupKeyFor(entry);
      byKey.putIfAbsent(key, () => []).add(entry);
    }

    final groups =
        byKey.values.map((list) {
          final sorted = List<ClassEntry>.from(list)
            ..sort((a, b) {
              final day = a.weekday.compareTo(b.weekday);
              if (day != 0) return day;
              return a.startTime.compareTo(b.startTime);
            });
          return ClassScheduleGroup(entries: sorted);
        }).toList();

    groups.sort((a, b) {
      final ea = a.representative;
      final eb = b.representative;
      final day = ea.weekday.compareTo(eb.weekday);
      if (day != 0) return day;
      return ea.startTime.compareTo(eb.startTime);
    });

    return groups;
  }
}
