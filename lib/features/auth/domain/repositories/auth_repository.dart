import 'package:clientta/core/utils/result.dart';

abstract class AuthRepository {
  Future<Result<void>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Result<void>> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<Result<void>> signInWithGoogle();

  Future<Result<void>> signOut();
}
