import 'package:logging/logging.dart';
import 'package:university_hub/core/strings/strings.dart';
import 'package:university_hub/core/utils/result.dart';

mixin RequestMixin {
  Future<Result<T>> request<T>(Future<T> Function() function) async {
    final logger = Logger('Request');
    try {
      final result = await function();
      return Result.ok(result);
    } on Exception catch (e) {
      logger.severe(e);
      return Result.error(e);
    } catch (e) {
      logger.severe(e);
      return Result.errorDefault(errorDefaultString);
    }
  }
}
