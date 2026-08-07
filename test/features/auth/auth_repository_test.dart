import 'package:clientta/core/strings/strings.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/auth/data/auth_repository_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFirebaseAuth extends Mock implements FirebaseAuth {}

class _MockUserCredential extends Mock implements UserCredential {}

void main() {
  late _MockFirebaseAuth auth;
  late AuthRepositoryFirebase repository;

  setUp(() {
    auth = _MockFirebaseAuth();
    repository = AuthRepositoryFirebase(auth: auth);
  });

  group('AuthRepositoryFirebase', () {
    test('signInWithEmail succeeds', () async {
      when(
        () => auth.signInWithEmailAndPassword(
          email: 'user@clientta.com',
          password: 'secret123',
        ),
      ).thenAnswer((_) async => _MockUserCredential());

      final result = await repository.signInWithEmail(
        email: 'user@clientta.com',
        password: 'secret123',
      );

      expect(result.isOk, true);
    });

    test('signInWithEmail maps invalid credential', () async {
      when(
        () => auth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(
        FirebaseAuthException(code: 'invalid-credential'),
      );

      final result = await repository.signInWithEmail(
        email: 'user@clientta.com',
        password: 'wrong',
      );

      expect(result.isError, true);
      expect(result.error.toString(), contains(credenciaisInvalidasString));
    });

    test('signUpWithEmail maps email already in use', () async {
      when(
        () => auth.createUserWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(
        FirebaseAuthException(code: 'email-already-in-use'),
      );

      final result = await repository.signUpWithEmail(
        email: 'user@clientta.com',
        password: 'secret123',
      );

      expect(result.isError, true);
      expect(result.error.toString(), contains(errorEmailInUseString));
    });

    test('signOut succeeds', () async {
      when(() => auth.signOut()).thenAnswer((_) async {});

      final result = await repository.signOut();

      expect(result.isOk, true);
    });
  });
}
