/// Configuração central do aplicativo para uso acadêmico e institucional.
///
/// O perfil [AppProfile.university] desativa recursos de monetização e prioriza
/// dependências gratuitas documentadas em `docs/GUIA_UNIVERSITARIO.md`.
enum AppProfile {
  /// Uso em sala de aula, TCC e extensão — sem anúncios nem compras in-app.
  university,

  /// Perfil legado com monetização (não recomendado para projetos acadêmicos).
  production,
}

abstract final class AppConfig {
  /// Altere para [AppProfile.production] apenas se for reativar monetização.
  static const AppProfile profile = AppProfile.university;

  static bool get isUniversityMode => profile == AppProfile.university;

  static bool get enableAds => !isUniversityMode;

  static bool get enableInAppPurchase => !isUniversityMode;
}
