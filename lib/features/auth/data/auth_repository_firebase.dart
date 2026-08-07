import 'package:clientta/core/strings/strings.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepositoryFirebase implements AuthRepository {
  AuthRepositoryFirebase({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

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
  Future<Result<void>> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return const Result.ok();
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;
      if (idToken == null && accessToken == null) {
        return Result.error(Exception(errorGoogleSignInUnavailableString));
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );
      await _auth.signInWithCredential(credential);
      return const Result.ok();
    } on FirebaseAuthException catch (error) {
      return Result.error(Exception(_mapAuthError(error)));
    } on PlatformException catch (error) {
      final message = _mapGoogleSignInPlatformError(error);
      if (message == null) {
        return const Result.ok();
      }
      return Result.error(Exception(message));
    } catch (_) {
      return Result.error(Exception(errorGoogleSignInUnavailableString));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      return const Result.ok();
    } catch (_) {
      return Result.error(Exception(errorDefaultString));
    }
  }

  String? _mapGoogleSignInPlatformError(PlatformException error) {
    switch (error.code) {
      case 'sign_in_canceled':
        return null;
      case 'network_error':
        return errorGoogleSignInUnavailableString;
      case 'sign_in_failed':
        return errorGoogleSignInUnavailableString;
      default:
        return errorGoogleSignInUnavailableString;
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
      case 'account-exists-with-different-credential':
        return errorGoogleSignInAccountExistsString;
      case 'operation-not-allowed':
        return errorGoogleSignInUnavailableString;
      default:
        return errorDefaultString;
    }
  }
}
