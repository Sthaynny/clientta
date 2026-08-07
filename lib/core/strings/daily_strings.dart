String get homeTodayString => 'Seu dia de atendimentos';
String homeDayStatAppointments(int count) =>
    count == 1 ? '1 agendamento hoje' : '$count agendamentos hoje';
String get appointmentsTodayString => 'Agendamentos de hoje';
String get noAppointmentsTodayString => 'Nenhum agendamento para hoje.';
String get myAgendaString => 'Minha Agenda';
String get myClientsString => 'Meus Clientes';
String get clientsSearchHintString => 'Buscar por nome ou telefone';
String get clientsEmptyTitleString => 'Nenhum cliente ainda';
String get clientsEmptyMessageString =>
    'Registre atendimentos na agenda para ver seus clientes reunidos aqui.';
String get clientsSearchEmptyTitleString => 'Nenhum cliente encontrado';
String get clientsSearchEmptyMessageString =>
    'Tente outro nome ou telefone, ou limpe a busca.';
String clientProfileAppointmentsLabel(int count) =>
    count == 1 ? '1 agendamento' : '$count agendamentos';
String clientProfileEncountersLabel(int count) =>
    count == 1 ? '1 encontro' : '$count encontros';
String clientProfileLastActivityLabel(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(date.year, date.month, date.day);
  if (day == today) return 'Ativo hoje';
  final yesterday = today.subtract(const Duration(days: 1));
  if (day == yesterday) return 'Ativo ontem';
  final dayLabel = date.day.toString().padLeft(2, '0');
  final monthLabel = date.month.toString().padLeft(2, '0');
  return 'Ativo em $dayLabel/$monthLabel';
}
String clientProfileNextAppointmentLabel({
  required DateTime date,
  required String startTime,
}) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final appointmentDay = DateTime(date.year, date.month, date.day);
  if (appointmentDay == today) {
    return 'Próximo: hoje às $startTime';
  }
  final tomorrow = today.add(const Duration(days: 1));
  if (appointmentDay == tomorrow) {
    return 'Próximo: amanhã às $startTime';
  }
  final dayLabel = date.day.toString().padLeft(2, '0');
  final monthLabel = date.month.toString().padLeft(2, '0');
  return 'Próximo: $dayLabel/$monthLabel às $startTime';
}
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
String get appointmentReminderNotesLabelString =>
    'Lembrete do agendamento (opcional)';
String get appointmentReminderNotesHintString =>
    'Ex.: fechar seguro com o cliente, retornar sobre a apólice';
String get scheduleClientReminderTitleString => 'Agendar lembrete';
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
    'Anote cliente, serviço e horário. Em poucos segundos você sabe o que fazer em seguida.';
String get onboardingContinueString => 'Continuar';
String get onboardingRegisterCtaString => 'Registrar atendimento';
String get quickAddAppointmentString => 'Novo agendamento';
String get offlineBannerMessageString =>
    'Você está offline. Seus atendimentos continuam salvos neste aparelho.';
String get syncPendingBannerMessageString =>
    'Sem internet. Quando a rede voltar, a agenda atualiza sozinha.';
String get syncingBannerMessageString => 'Atualizando sua agenda...';
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
    'Anote ligações, reuniões e o que combinou com o cliente, sem marcar horário na agenda.';
String get clientCareComposerHintString =>
    'Deixe em branco para marcar que começou o atendimento hoje. Escreva algo para guardar um detalhe.';
String get clientCareNoteLabelString => 'Nova anotação';
String get clientCareAddNoteString => 'Registrar encontro';
String get clientCareFromAppointmentString => 'Agendamento';
String get careTimelineEncounterLabelString => 'Registro de encontro';
String get clientCareActionString => 'Ver atendimento';
String get clientCareScheduleAppointmentString => 'Agendar lembrete';
String get clientCareScheduleAppointmentHintString =>
    'Cria um agendamento com data e horário. Use as observações para o que precisa fazer com o cliente.';
String get encounterStartedDefaultBodyString => 'Atendimento iniciado.';
String get encounterAlreadyRegisteredTodayString =>
    'Atendimento de hoje já registrado para este cliente.';
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
String get errorServiceTypeRequiredString => 'Informe o tipo de serviço.';
String get serviceTypeHintString =>
    'Digite ou selecione um serviço já cadastrado';
String get clientPhoneMatchTitleString => 'Cliente já cadastrado';
String clientPhoneMatchMessageString(String clientName) =>
    'Este telefone já está na base como "$clientName". Deseja vincular ao primeiro atendimento ou registrar como cliente novo?';
String get clientPhoneMatchMergeLabelString => 'Vincular ao existente';
String get clientPhoneMatchCreateNewLabelString => 'Criar novo cliente';
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
    'Opcional. Cria os próximos 4 encontros nos dias que você marcar.';

String get recurringSeriesGroupTitleString => 'Repetição semanal';
String recurringSeriesGroupSubtitle({
  required String clientName,
  required String serviceType,
}) => '$clientName · $serviceType';

String get quickNotesDialogTitleString => 'Observação rápida';
String get quickNotesDialogHintString => 'Anote algo sobre o atendimento';

String get loginWelcomeString => 'Bem-vindo ao Clientta';
String get loginSubtitleString =>
    'Entre com seu e-mail para usar a mesma agenda em outro celular.';
String get registerWelcomeString => 'Crie sua conta';
String get registerSubtitleString =>
    'Cadastre-se para guardar a agenda online e assinar o Clientta Pro.';
String get registerString => 'Criar conta';
String get createAccountString => 'Ainda não tem conta? Cadastre-se';
String get alreadyHaveAccountString => 'Já tem conta? Entrar';
String get authDividerOrString => 'ou';

String get planSettingsTitleString => 'Plano e assinatura';
String get planProTitleString => 'Clientta Pro';
String get planProDescriptionString =>
    'Mais atendimentos na agenda, mesma conta em outro celular, aviso antes do horário e cópia dos seus dados.';
const planProBenefits = [
  'Mais atendimentos e repetições na agenda',
  'Mesma agenda em outro celular',
  'Aviso antes do horário do atendimento',
  'Exportar e importar seus dados',
];
String get formSectionClientString => 'Cliente';
String get formSectionAppointmentString => 'Horário e status';
String get formSectionNotesString => 'Observações';
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
String get planStatusProComplimentaryString => 'Clientta Pro (acesso cortesia)';
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
    'Assinatura ativa. Aqui você confere o status ou cancela.';
String get planInactivityPolicyString =>
    'Se ficar 2 meses sem abrir o app ou mexer na agenda, o Pro é encerrado ao fim do mês já pago.';
String get planUpgradeHintString =>
    'No Pro você coloca mais atendimentos na agenda e usa o mesmo login em outro celular.';
String get planComplimentaryAccessString =>
    'Seu e-mail tem acesso Pro liberado sem assinatura paga.';
String planDiscountAppliedString(int percentOff) =>
    'Desconto de $percentOff% aplicado ao seu e-mail.';
String get planDiscountPriceLabelString => 'Seu preço com desconto';
String get planBasePriceLabelString => 'Preço padrão';
String planFreeLimitAppointmentsMessage(int limit) =>
    'No plano gratuito cabem até $limit atendimentos ativos. Assine o Pro para continuar.';
String planFreeLimitSeriesMessage(int limit) =>
    'No plano gratuito cabem até $limit repetições semanais ativas. Assine o Pro para continuar.';
String get planFreeSyncBlockedMessageString =>
    'Usar a mesma agenda em mais de um aparelho é recurso do plano Pro.';
String planFreeUsageAppointmentsLabel(int current, int max) =>
    '$current de $max atendimentos ativos';
String planFreeUsageSeriesLabel(int current, int max) =>
    '$current de $max repetições semanais ativas';
String get planFreeUsageUpgradeActionString => 'Ver plano Pro';
String get appointmentReminderTitleString => 'Atendimento em breve';
String appointmentReminderBody({
  required String clientName,
  required String serviceType,
  required String startTime,
}) => '$clientName · $serviceType às $startTime';
String get planReminderProRequiredString =>
    'Aviso antes do horário é do plano Pro.';
String get planReminderSectionTitleString => 'Lembretes';
String get planReminderEnableLabelString => 'Avisar antes do horário';
String get planReminderEnableSubtitleString =>
    'O celular avisa antes do compromisso. Funciona sem internet.';
String get planReminderLeadLabelString => 'Antecedência';
String reminderLeadMinutesLabel(int minutes) => '$minutes min antes';
String get appointmentFormReminderLabelString =>
    'Lembrar antes do atendimento';
String appointmentFormReminderSubtitle(int leadMinutes) =>
    'Aviso $leadMinutes min antes do horário.';
String get appointmentFormReminderFreeSubtitleString =>
    'Disponível no plano Pro.';
String get reminderSettingsSavedString => 'Lembretes atualizados.';
String get planBackupSectionTitleString => 'Cópia dos seus dados';
String get planBackupDescriptionString =>
    'Gere um arquivo com agenda, clientes e anotações deste celular. Você escolhe onde guardar.';
String get planBackupExportButtonString => 'Salvar cópia';
String get planBackupExportSuccessString =>
    'Arquivo pronto para guardar ou enviar.';
String get planBackupExportErrorString =>
    'Não deu para salvar a cópia. Tente de novo.';
String get planBackupProRequiredString =>
    'Salvar ou restaurar dados é recurso do plano Pro.';
String get planBackupImportButtonString => 'Restaurar de um arquivo';
String get planBackupImportTitleString => 'Trocar tudo pelo arquivo?';
String get planBackupImportMessageString =>
    'Agenda e anotações deste celular saem e entram as do arquivo. Não dá para desfazer.';
String get planBackupImportConfirmButtonString => 'Substituir tudo';
String planBackupImportSuccessString({
  required int appointments,
  required int notes,
}) =>
    'Pronto: $appointments atendimentos e $notes anotações restaurados.';
String get planBackupImportErrorString =>
    'Não deu para restaurar. Confira o arquivo e tente de novo.';
String get planBackupImportInvalidString =>
    'Não reconhecemos o arquivo. Use uma cópia salva pelo Clientta.';

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
