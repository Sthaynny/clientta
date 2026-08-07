import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clientta/core/strings/strings.dart';
import 'package:clientta/core/utils/result.dart';
import 'package:clientta/features/auth/domain/repositories/user_repository.dart';

class UserRepositoryRemote implements UserRepository {
  UserRepositoryRemote({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

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

  @override
  Future<Result<void>> touchLastActivity({String? uid}) async {
    final effectiveUid = uid ?? _auth.currentUser?.uid;
    if (effectiveUid == null) {
      return const Result.ok();
    }

    try {
      await _firestore.collection('users').doc(effectiveUid).set(
        {'lastActivityAt': FieldValue.serverTimestamp()},
        SetOptions(merge: true),
      );
      return const Result.ok();
    } catch (_) {
      return Result.error(Exception(errorDefaultString));
    }
  }
}
