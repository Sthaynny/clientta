/// Normaliza telefone para agrupar histórico do mesmo cliente.
String normalizeClientPhone(String phone) =>
    phone.replaceAll(RegExp(r'\D'), '');
