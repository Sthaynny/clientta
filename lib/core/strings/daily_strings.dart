String get homeTodayString => 'Seu dia na universidade';
String homeDayStatClasses(int count) =>
    count == 1 ? '1 aula hoje' : '$count aulas hoje';
String homeDayStatActivities(int count) =>
    count == 1 ? '1 atividade hoje' : '$count atividades hoje';
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
String get classWeekdaysSectionString => 'Dias da semana';
String get classWeekdaysHintString =>
    'Marque cada dia em que você tem esta aula.';
String get classSameTimeSwitchString => 'Mesmo horário em todos os dias';
String get classSameTimeSwitchSubtitleString =>
    'Desligue para definir início e fim em cada dia.';
String get classScheduleSectionString => 'Horário';
String get classPerDayTimesHintString =>
    'Defina início e fim para cada dia selecionado.';
String get classScheduleTimeVariesString => 'Horários variam';
String get classNightShiftPresetsTitleString =>
    'Atalhos de turno noturno';
String get errorClassPerDayTimeMissingString =>
    'Preencha o horário de cada dia selecionado.';
String get startTimeString => 'Início';
String get endTimeString => 'Fim';
String get activityTitleString => 'O que você vai fazer?';
String get activityDateString => 'Data';
String get activityTypeString => 'Tipo';
String get notesOptionalString => 'Observações (opcional)';
String get markDoneString => 'Concluída';
String get deleteString => 'Excluir';
String get editActionString => 'Editar';
String get cancelString => 'Cancelar';
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

String get errorClassSubjectRequiredString => 'Informe a disciplina.';
String get errorClassWeekdayRequiredString =>
    'Selecione pelo menos um dia da semana.';
String get errorClassStartTimeInvalidString =>
    'Horário de início inválido. Use HH:mm (ex.: 08:00).';
String get errorClassEndTimeInvalidString =>
    'Horário de fim inválido. Use HH:mm (ex.: 08:00).';
String get errorClassEndBeforeStartString =>
    'O horário de fim precisa ser depois do início.';

String get deleteClassSingleDayTitleString => 'Excluir esta aula?';
String get deleteClassSingleDayMessageString =>
    'A disciplina sai da grade neste dia da semana. Não dá para desfazer.';
String get deleteClassConfirmSingleDayActionString => 'Excluir este dia';
String get deleteClassKeepActionString => 'Manter na grade';

String get deleteClassChooseTitleString => 'O que deseja excluir?';
String get deleteClassChooseMessageString =>
    'Esta disciplina aparece em mais de um dia na grade.';
String get deleteClassThisDayString => 'Só este dia';
String get deleteClassEntireSeriesString => 'Todos os dias';

String get deleteClassSeriesTitleString => 'Excluir em todos os dias?';
String get deleteClassSeriesMessageString =>
    'Remove a disciplina em todos os dias em que foi cadastrada. Não dá para desfazer.';
String get deleteClassConfirmSeriesActionString => 'Excluir todos os dias';

const weekdayLabels = [
  'Segunda-feira',
  'Terça-feira',
  'Quarta-feira',
  'Quinta-feira',
  'Sexta-feira',
  'Sábado',
  'Domingo',
];

const weekdayShortLabels = [
  'Seg',
  'Ter',
  'Qua',
  'Qui',
  'Sex',
  'Sáb',
  'Dom',
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

String get universityNameMenuString => 'Nome da universidade';
String get universityNameDialogTitleString => 'Sua universidade';
String get universityNameDialogHintString =>
    'Ex.: Universidade Federal do seu estado';
String get universityNameDialogSaveString => 'Salvar';
