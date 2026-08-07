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
String get emptyAppointmentsHomeTitle => 'Sem atendimentos hoje';
String get emptyAppointmentsHomeMessage =>
    'Registre clientes, horários e serviços na agenda. O que é de hoje aparece aqui automaticamente.';
String get emptyAgendaTitle => 'Sua agenda está vazia';
String get emptyAgendaMessage =>
    'Anote cada atendimento com cliente, telefone e tipo de serviço. Tudo fica salvo neste aparelho, mesmo sem internet.';
String get onboardingSkipString => 'Pular';
String get onboardingOfflineTitle => 'Funciona offline';
String get onboardingOfflineMessage =>
    'Registre atendimentos no estacionamento, entre ligações ou no cliente. Os dados ficam no aparelho e você não depende de internet para consultar.';
String get onboardingFirstAppointmentTitle => 'Registre seu primeiro atendimento';
String get onboardingFirstAppointmentMessage =>
    'Anote quem você atendeu, o serviço e o horário. Em segundos você tem clareza do dia e do próximo passo com cada cliente.';
String get onboardingContinueString => 'Continuar';
String get onboardingRegisterCtaString => 'Registrar atendimento';
String get quickAddAppointmentString => 'Novo agendamento';
String get offlineBannerMessageString =>
    'Você está offline. Seus atendimentos continuam salvos neste aparelho.';
String get syncPendingBannerMessageString =>
    'Sem conexão. A sincronização retoma automaticamente quando a rede voltar.';
String get syncingBannerMessageString => 'Sincronizando sua agenda na nuvem...';
String formatLastSyncLabel(DateTime syncedAt) {
  final time =
      '${syncedAt.hour.toString().padLeft(2, '0')}:'
      '${syncedAt.minute.toString().padLeft(2, '0')}';
  return 'Última sincronização às $time';
}
String get cancelAppointmentActionString => 'Cancelar atendimento';
String get cancelAppointmentTitleString => 'Cancelar este atendimento?';
String get cancelAppointmentMessageString =>
    'O horário será marcado como cancelado. Você pode editar depois na agenda.';
String get markCompleteSuccessString => 'Atendimento concluído.';
String get cancelAppointmentSuccessString => 'Atendimento cancelado.';
String get quickNotesSavedString => 'Observação salva.';

String get clientCareTitleString => 'Atendimento';
String get clientCareTimelineTitleString => 'Histórico de negociação';
String get clientCareEmptyTitleString => 'Nenhuma anotação ainda';
String get clientCareEmptyMessageString =>
    'Registre encontros, ligações e negociações aqui — sem precisar marcar horário na agenda.';
String get clientCareComposerHintString =>
    'Opcional: anote o que aconteceu. Sem texto, registra só o início do atendimento.';
String get clientCareNoteLabelString => 'Nova anotação';
String get clientCareAddNoteString => 'Registrar encontro';
String get clientCareFromAppointmentString => 'Agendamento';
String get clientCareActionString => 'Ver atendimento';
String get clientCareScheduleAppointmentString => 'Agendar na home';
String get clientCareScheduleAppointmentHintString =>
    'Cria um agendamento que aparece no painel do dia.';
String get encounterStartedDefaultBodyString => 'Atendimento iniciado.';
String get clientCallActionString => 'Ligar';
String get clientWhatsAppActionString => 'WhatsApp';
String get clientContactLaunchFailedString =>
    'Não foi possível abrir o aplicativo de contato.';
String get encounterNoteSavedString => 'Encontro registrado.';

String formatEncounterTimestamp(DateTime dateTime) {
  final day = dateTime.day.toString().padLeft(2, '0');
  final month = dateTime.month.toString().padLeft(2, '0');
  final year = dateTime.year;
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$day/$month/$year às $hour:$minute';
}

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

String get deleteSeriesTitleString => 'Excluir atendimentos da série?';
String get deleteSeriesMessageString =>
    'Você pode remover só este dia ou todos os atendimentos vinculados a esta série.';
String get deleteSeriesOneLabelString => 'Só este dia';
String get deleteSeriesAllLabelString => 'Toda a série';

String get editSeriesTitleString => 'Como aplicar as alterações?';
String get editSeriesMessageString =>
    'Este atendimento faz parte de uma série recorrente. Escolha o que deseja atualizar.';
String get editSeriesOneLabelString => 'Só este dia';
String get editSeriesAllLabelString => 'Toda a série';

String get filterAllServiceTypesString => 'Todos os tipos';
String get filterServiceTypeLabelString => 'Filtrar por serviço';
String get filterEmptyTitleString => 'Nenhum atendimento neste filtro';
String get filterEmptyMessageString =>
    'Tente outro tipo de serviço ou limpe o filtro para ver tudo.';

String get recurringSeriesLabelString => 'Repetir nos dias';
String get recurringSeriesHintString =>
    'Opcional. Cria atendimentos nas próximas 4 semanas nos dias selecionados.';

String get recurringSeriesGroupTitleString => 'Série recorrente';
String recurringSeriesGroupSubtitle({
  required String clientName,
  required String serviceType,
}) => '$clientName · $serviceType';

String get quickNotesDialogTitleString => 'Observação rápida';
String get quickNotesDialogHintString => 'Anote algo sobre o atendimento';

String get loginWelcomeString => 'Bem-vindo ao Clientta';
String get loginSubtitleString =>
    'Entre com seu e-mail para sincronizar sua agenda e gerenciar o plano Pro.';

String get registerWelcomeString => 'Crie sua conta';
String get registerSubtitleString =>
    'Cadastre-se para salvar sua agenda na nuvem e assinar o Clientta Pro.';
String get registerString => 'Criar conta';
String get createAccountString => 'Ainda não tem conta? Cadastre-se';
String get alreadyHaveAccountString => 'Já tem conta? Entrar';
String get authDividerOrString => 'ou';

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
String get planPricingErrorString =>
    'Não foi possível carregar o preço do plano. Tente novamente.';
String get planStatusFreeString => 'Plano gratuito';
String get planStatusProActiveString => 'Clientta Pro ativo';
String get planStatusProPendingString => 'Assinatura em processamento';
String get planStatusProPastDueString => 'Pagamento pendente';
String get planStatusProCanceledString => 'Assinatura cancelada';
String get planCurrentStatusLabelString => 'Status atual';
String get planSyncStatusButtonString => 'Atualizar status';
String get planSyncSuccessString => 'Status da assinatura atualizado.';
String get planSyncErrorString =>
    'Não foi possível atualizar o status. Tente novamente.';
String get planCancelButtonString => 'Cancelar assinatura';
String get planCancelTitleString => 'Cancelar assinatura Pro?';
String get planCancelMessageString =>
    'Você mantém o acesso até o fim do período já pago. Depois disso, volta ao plano gratuito.';
String get planCancelSuccessString =>
    'Assinatura cancelada. O acesso Pro continua até o fim do período.';
String get planCancelErrorString =>
    'Não foi possível cancelar a assinatura. Tente novamente.';
String get planManageProString =>
    'Sua assinatura Pro está ativa. Use as ações abaixo para sincronizar ou cancelar.';
String get planInactivityPolicyString =>
    'Assinaturas Pro sem uso por 2 meses são canceladas automaticamente ao fim do período já pago. O uso inclui criar, editar ou sincronizar atendimentos.';
String get planUpgradeHintString =>
    'Assine o Pro para agenda ilimitada e sincronização na nuvem.';
String planFreeLimitAppointmentsMessage(int limit) =>
    'O plano gratuito permite até $limit atendimentos ativos. Assine o Pro para continuar.';
String planFreeLimitSeriesMessage(int limit) =>
    'O plano gratuito permite até $limit séries recorrentes ativas. Assine o Pro para continuar.';
String get planFreeSyncBlockedMessageString =>
    'A sincronização na nuvem está disponível apenas no plano Pro.';

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
