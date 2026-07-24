import 'package:ufersa_hub/core/config/app_config.dart';
import 'package:ufersa_hub/features/shared/auth/data/repositories/auth_repository.dart';

/// Regras de acesso para o app comunitário (leitura e contribuição sem login).
abstract final class CommunityAccess {
  static bool get isOpenCommunity =>
      AppConfig.isUniversityMode && !AppConfig.requireAuthentication;

  /// `true` quando o usuário pode criar, editar ou remover conteúdo na interface.
  static Future<bool> resolveEditorAccess(AuthRepository authRepository) async {
    if (isOpenCommunity) return true;
    return authRepository.isAuthenticated;
  }
}
