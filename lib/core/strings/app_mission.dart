/// Mensagens de propósito e posicionamento do ConectaFERSA.
abstract final class AppMission {
  static const String name = 'ConectaFERSA';

  static const String tagline =
      'O que importa no campus, em um só lugar — sem login.';

  static const String stripMessage =
      'Avisos, eventos e documentos da turma. Abra e use.';

  static const String drawerSubtitle =
      'Comunidade universitária • uso livre';

  /// Resumo para README e documentação.
  static const String purposeSummary =
      'Hub comunitário para estudantes que cansaram de perder aviso em grupo '
      'de mensagem, prazo de evento e PDF de edital no fim do feed.';

  static const List<String> studentPainPoints = [
    'Informação espalhada entre WhatsApp, Instagram e mural físico',
    'Eventos e inscrições que passam despercebidos',
    'Documentos difíceis de achar na hora da entrega ou da matrícula',
    'Calouros sem um ponto único de referência do campus',
    'Barreira de login ou conta institucional só para ler um aviso',
  ];
}
