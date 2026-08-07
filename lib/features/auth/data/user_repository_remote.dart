import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clientta/core/strings/strings.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/auth/domain/repositories/user_repository.dart';

class UserRepositoryRemote implements UserRepository {
  UserRepositoryRemote({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<Result<void>> ensureUserProfile({
    required String uid,
    required String? email,
  }) async {
    try {
      final ref = _firestore.collection('users').doc(uid);
      final snapshot = await ref.get();
      if (snapshot.exists) {
        return const Result.ok();
      }

      await ref.set({
        'email': email?.trim() ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return const Result.ok();
    } catch (_) {
      return Result.error(Exception(errorDefaultString));
    }
  }
}
