String get homeTodayString => 'Seu dia na faculdade';
String get classesTodayString => 'Aulas de hoje';
String get activitiesTodayString => 'Atividades de hoje';
String get noClassesTodayString => 'Nenhuma aula cadastrada para hoje.';
String get noActivitiesTodayString => 'Nenhuma atividade para hoje.';
String get myScheduleString => 'Minha grade';
String get myActivitiesString => 'Minhas atividades';
String get addClassString => 'Registrar aula';
String get editClassString => 'Editar aula';
String get addActivityString => 'Registrar atividade';
String get editActivityString => 'Editar atividade';
String get subjectString => 'Disciplina';
String get roomString => 'Sala';
String get weekdayString => 'Dia da semana';
String get startTimeString => 'Início';
String get endTimeString => 'Fim';
String get activityTitleString => 'O que você vai fazer?';
String get activityDateString => 'Data';
String get activityTypeString => 'Tipo';
String get notesOptionalString => 'Observações (opcional)';
String get markDoneString => 'Concluída';
String get deleteString => 'Excluir';
String get errorLoadDailyString => 'Não foi possível carregar seus registros.';
String get errorSaveString => 'Não foi possível salvar. Tente novamente.';
String get emptyClassesHomeTitle => 'Nenhuma aula hoje';
String get emptyClassesHomeMessage =>
    'Cadastre disciplinas em Minha grade para ver automaticamente o que você tem neste dia da semana.';
String get emptyActivitiesHomeTitle => 'Nada pendente hoje';
String get emptyActivitiesHomeMessage =>
    'Registre trabalhos, provas e estudos em Minhas atividades — eles aparecem aqui na data certa.';
String get emptyScheduleTitle => 'Grade vazia';
String get emptyScheduleMessage =>
    'Comece registrando suas aulas com dia, horário e sala. Tudo fica salvo só neste aparelho.';
String get emptyActivitiesListTitle => 'Nenhuma atividade';
String get emptyActivitiesListMessage =>
    'Anote entregas e provas em um lugar só, em vez de prints no chat.';

const weekdayLabels = [
  'Segunda-feira',
  'Terça-feira',
  'Quarta-feira',
  'Quinta-feira',
  'Sexta-feira',
  'Sábado',
  'Domingo',
];

const monthLabels = [
  'janeiro',
  'fevereiro',
  'março',
  'abril',
  'maio',
  'junho',
  'julho',
  'agosto',
  'setembro',
  'outubro',
  'novembro',
  'dezembro',
];

String formatHubDayHeader(DateTime date) =>
    '${date.day} de ${monthLabels[date.month - 1]}';
