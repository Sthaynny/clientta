abstract final class ServiceType {
  static const emprestimoConsignado = 'Empréstimo Consignado';
  static const seguroAuto = 'Seguro Auto';
  static const seguroVida = 'Seguro Vida';
  static const financiamento = 'Financiamento';
  static const consorcio = 'Consórcio';
  static const outros = 'Outros';

  static const List<String> all = [
    emprestimoConsignado,
    seguroAuto,
    seguroVida,
    financiamento,
    consorcio,
    outros,
  ];
}
