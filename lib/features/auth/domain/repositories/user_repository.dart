import 'package:clientta/core/utils/result.dart';

abstract class UserRepository {
  /// Creates `users/{uid}` on first login if missing. Never writes `subscription`.
  Future<Result<void>> ensureUserProfile({
    required String uid,
    required String? email,
  });

  /// Updates `lastActivityAt` for subscription inactivity policy. Never writes `subscription`.
  Future<Result<void>> touchLastActivity({String? uid});
}
