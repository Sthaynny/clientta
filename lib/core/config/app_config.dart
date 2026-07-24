/// Perfil fixo para uso estudantil local (sem serviços em nuvem).
enum AppProfile { university }

abstract final class AppConfig {
  static const AppProfile profile = AppProfile.university;

  static bool get isUniversityMode => true;
}
