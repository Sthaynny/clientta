/// Áreas de curso genéricas (legado de hubs institucionais; reservado para filtros futuros).
enum CourseHub {
  computerScience,
  engineering,
  health,
  humanities,
  business,
  other;

  const CourseHub();

  String get labelCourseHub {
    switch (this) {
      case CourseHub.computerScience:
        return 'Ciências da Computação / TI';
      case CourseHub.engineering:
        return 'Engenharias';
      case CourseHub.health:
        return 'Saúde';
      case CourseHub.humanities:
        return 'Humanas e sociais';
      case CourseHub.business:
        return 'Administração e negócios';
      case CourseHub.other:
        return 'Outro curso';
    }
  }
}
