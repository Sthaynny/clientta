/// Configuração central do aplicativo comunitário universitário.
///
/// O perfil [AppProfile.university] desativa monetização e, com
/// [requireAuthentication] em `false`, permite uso do dia a dia sem login.
/// Veja `docs/PROPOSITO.md` e `docs/GUIA_UNIVERSITARIO.md`.
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

  /// `false`: app aberto — qualquer estudante usa e contribui sem criar conta.
  /// `true`: apenas usuários autenticados gerenciam conteúdo (modo administrativo).
  static const bool requireAuthentication = false;
}
