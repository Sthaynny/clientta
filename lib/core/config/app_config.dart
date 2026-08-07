/// Perfil fixo para CRM de agendamentos.
enum AppProfile { crm }

abstract final class AppConfig {
  static const AppProfile profile = AppProfile.crm;

  static bool get isCrmMode => profile == AppProfile.crm;
}
