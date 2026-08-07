import 'package:clientta/core/strings/strings.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryFirebase implements AuthRepository {
  AuthRepositoryFirebase({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  @override
  Future<Result<void>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return const Result.ok();
    } on FirebaseAuthException catch (error) {
      return Result.error(Exception(_mapAuthError(error)));
    } catch (_) {
      return Result.error(Exception(errorDefaultString));
    }
  }

  @override
  Future<Result<void>> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return const Result.ok();
    } on FirebaseAuthException catch (error) {
      return Result.error(Exception(_mapAuthError(error)));
    } catch (_) {
      return Result.error(Exception(errorDefaultString));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _auth.signOut();
      return const Result.ok();
    } catch (_) {
      return Result.error(Exception(errorDefaultString));
    }
  }

  String _mapAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return errorEmailInvalidString;
      case 'user-disabled':
        return errorUserDisabledString;
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return credenciaisInvalidasString;
      case 'email-already-in-use':
        return errorEmailInUseString;
      case 'weak-password':
        return errorWeakPasswordString;
      default:
        return errorDefaultString;
    }
  }
}
