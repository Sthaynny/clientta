String get homeTodayString => 'Seu dia de atendimentos';
String homeDayStatAppointments(int count) =>
    count == 1 ? '1 agendamento hoje' : '$count agendamentos hoje';
String get appointmentsTodayString => 'Agendamentos de hoje';
String get noAppointmentsTodayString => 'Nenhum agendamento para hoje.';
String get myAgendaString => 'Minha Agenda';
String get addAppointmentString => 'Registrar agendamento';
String get editAppointmentString => 'Editar agendamento';
String get clientNameString => 'Nome do cliente';
String get clientPhoneString => 'Telefone do cliente';
String get serviceTypeString => 'Tipo de serviço';
String get appointmentDateString => 'Data do atendimento';
String get appointmentStatusString => 'Status';
String get startTimeString => 'Início';
String get endTimeString => 'Fim';
String get notesOptionalString => 'Observações (opcional)';
String get markCompleteString => 'Concluir atendimento';
String get quickNotesString => 'Adicionar observação';
String get deleteString => 'Excluir';
String get editActionString => 'Editar';
String get cancelString => 'Cancelar';
String get errorLoadDailyString => 'Não foi possível carregar seus registros.';
String get errorSaveString => 'Não foi possível salvar. Tente novamente.';
String get emptyAppointmentsHomeTitle => 'Nenhum agendamento hoje';
String get emptyAppointmentsHomeMessage =>
    'Cadastre atendimentos em Minha Agenda para ver automaticamente o que você tem hoje.';
String get emptyAgendaTitle => 'Agenda vazia';
String get emptyAgendaMessage =>
    'Comece registrando seus atendimentos com cliente, serviço e horário. Tudo fica salvo só neste aparelho.';
String get quickAddAppointmentString => 'Novo agendamento';

String get errorClientNameRequiredString => 'Informe o nome do cliente.';
String get errorClientPhoneRequiredString => 'Informe o telefone do cliente.';
String get errorServiceTypeRequiredString => 'Selecione o tipo de serviço.';
String get errorAppointmentStartTimeInvalidString =>
    'Horário de início inválido. Use HH:mm (ex.: 09:00).';
String get errorAppointmentEndTimeInvalidString =>
    'Horário de fim inválido. Use HH:mm (ex.: 10:00).';
String get errorAppointmentEndBeforeStartString =>
    'O horário de fim precisa ser depois do início.';

String get deleteAppointmentTitleString => 'Excluir este agendamento?';
String get deleteAppointmentMessageString =>
    'O atendimento será removido da agenda. Não dá para desfazer.';

String get quickNotesDialogTitleString => 'Observação rápida';
String get quickNotesDialogHintString => 'Anote algo sobre o atendimento';

String get loginWelcomeString => 'Bem-vindo ao Clientta';
String get loginSubtitleString =>
    'Entre com seu e-mail para sincronizar sua agenda.';

String get planSettingsTitleString => 'Plano e assinatura';
String get planProTitleString => 'Clientta Pro';
String get planProDescriptionString =>
    'Agenda ilimitada, sincronização na nuvem e suporte prioritário.';
String get planSubscribeButtonString => 'Assinar plano Pro';
String get planSubscribeSuccessString => 'Assinatura ativada com sucesso!';
String get planSubscribePendingString =>
    'Assinatura em processamento. Aguarde a confirmação.';
String get planSubscribeErrorString =>
    'Não foi possível iniciar a assinatura. Tente novamente.';

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
