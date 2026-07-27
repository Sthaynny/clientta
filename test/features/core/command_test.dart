import 'package:university_hub/core/utils/commands.dart';
import 'package:university_hub/core/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CommandBase tests', () {
    test('should complete void command', () async {
      // Void action
      final command = CommandBase<void>(() => Future.value(Result.ok(null)));

      // Run void action
      await command.execute();

      // Action completed
      expect(command.completed, true);
    });

    test('should complete bool command', () async {
      // Action that returns bool
      final command = CommandBase<bool>(() => Future.value(Result.ok(true)));

      // Run action with result
      await command.execute();

      // Action completed
      expect(command.completed, true);
      expect(command.result!.asOk.value, true);
    });

    test('running should be true', () async {
      final command = CommandBase<void>(() => Future.value(Result.ok(null)));
      final future = command.execute();

      // Action is running
      expect(command.running, true);

      // Await execution
      await future;

      // Action finished running
      expect(command.running, false);
    });

    test('should only run once', () async {
      var count = 0;
      final command = CommandBase<int>(() => Future.value(Result.ok(count++)));
      final future = command.execute();

      // Run multiple times
      command.execute();
      command.execute();
      command.execute();
      command.execute();

      // Await execution
      await future;

      // Action is called once
      expect(count, 1);
    });

    test('should handle errors', () async {
      final command = CommandBase<int>(
        () => Future.value(Result.error(Exception('ERROR!'))),
      );
      await command.execute();
      expect(command.error, true);
      expect(command.result, isA<Error>());
    });
  });

  group('CommandAction tests', () {
    test('should complete void command, bool argument', () async {
      // Void action with bool argument
      final command = CommandAction<void, bool>((a) {
        expect(a, true);
        return Future.value(Result.ok(null));
      });

      // Run void action, ignore void return
      await command.execute(true);

      expect(command.completed, true);
    });

    test('should complete bool command, bool argument', () async {
      // Action that returns bool argument
      final command = CommandAction<bool, bool>(
        (a) => Future.value(const Result.ok(true)),
      );

      // Run action with result and argument
      await command.execute(true);

      // Argument was passed to onComplete
      expect(command.completed, true);
      expect(command.result!.asOk.value, true);
    });
  });
}

extension ResultCast<T> on Result<T> {
  /// Convenience method to cast to Ok
  Ok<T> get asOk => this as Ok<T>;

  /// Convenience method to cast to Error
  Error get asError => this as Error<T>;
}
