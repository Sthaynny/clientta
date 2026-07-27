/// Turno noturno em grade de 50 min + intervalo de 10 min entre o 2º e 3º período,
/// padrão comum em universidades públicas brasileiras (ex.: códigos `N1`…`N4`).
///
/// Referência para cadastro manual no app; horários podem variar por campus.
class AcademicNightPeriod {
  const AcademicNightPeriod({
    required this.index,
    required this.startTime,
    required this.endTime,
    required this.shortLabel,
  });

  /// 1 = primeiro período noturno (N1), … 4 = N4.
  final int index;
  final String startTime;
  final String endTime;
  final String shortLabel;
}

class AcademicNightBlock {
  const AcademicNightBlock({
    required this.label,
    required this.startTime,
    required this.endTime,
    required this.periodFrom,
    required this.periodTo,
  });

  final String label;
  final String startTime;
  final String endTime;
  final int periodFrom;
  final int periodTo;
}

/// Períodos noturnos de referência (turno N, quatro blocos de 50 min).
const academicNightPeriods = <AcademicNightPeriod>[
  AcademicNightPeriod(
    index: 1,
    startTime: '18:50',
    endTime: '19:40',
    shortLabel: 'N1',
  ),
  AcademicNightPeriod(
    index: 2,
    startTime: '19:40',
    endTime: '20:30',
    shortLabel: 'N2',
  ),
  AcademicNightPeriod(
    index: 3,
    startTime: '20:40',
    endTime: '21:30',
    shortLabel: 'N3',
  ),
  AcademicNightPeriod(
    index: 4,
    startTime: '21:30',
    endTime: '22:20',
    shortLabel: 'N4',
  ),
];

/// Blocos usados em turmas (ex.: `4N1234` = quarta, noturno, períodos 1–4).
const academicNightBlocks = <AcademicNightBlock>[
  AcademicNightBlock(
    label: 'N1234',
    startTime: '18:50',
    endTime: '22:20',
    periodFrom: 1,
    periodTo: 4,
  ),
  AcademicNightBlock(
    label: 'N123',
    startTime: '18:50',
    endTime: '21:30',
    periodFrom: 1,
    periodTo: 3,
  ),
  AcademicNightBlock(
    label: 'N234',
    startTime: '19:40',
    endTime: '22:20',
    periodFrom: 2,
    periodTo: 4,
  ),
  AcademicNightBlock(
    label: 'N12',
    startTime: '18:50',
    endTime: '20:30',
    periodFrom: 1,
    periodTo: 2,
  ),
];

AcademicNightPeriod? nightPeriodByIndex(int index) {
  for (final p in academicNightPeriods) {
    if (p.index == index) return p;
  }
  return null;
}

/// Intervalo contínuo de [firstPeriod] a [lastPeriod] (inclusive).
({String startTime, String endTime})? nightRangeForPeriods(
  int firstPeriod,
  int lastPeriod,
) {
  if (firstPeriod < 1 || lastPeriod > 4 || firstPeriod > lastPeriod) {
    return null;
  }
  final first = nightPeriodByIndex(firstPeriod);
  final last = nightPeriodByIndex(lastPeriod);
  if (first == null || last == null) return null;
  return (startTime: first.startTime, endTime: last.endTime);
}
