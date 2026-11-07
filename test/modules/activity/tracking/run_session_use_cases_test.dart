import 'package:flutter_test/flutter_test.dart';
import 'package:running/core/domain/errors/custom_error.dart';
import 'package:running/core/domain/types/app_uuid.dart';
import 'package:running/core/domain/use_cases/interfaces/structure_use_case.dart';
import 'package:running/modules/activity/activity_module.dart';

void main() {
  final startedAt = DateTime.utc(2026, 11, 7, 18);

  group('calculateRunDuration', () {
    test('returns the exact elapsed time in milliseconds', () {
      final duration = calculateRunDuration(
        startedAt: startedAt,
        endedAt: startedAt.add(const Duration(minutes: 15, milliseconds: 250)),
      );

      expect(duration.inMilliseconds, 900250);
    });

    test('counts time spent while the app was suspended', () {
      // Sin ticks intermedios: solo importan las dos marcas de tiempo.
      final duration = calculateRunDuration(
        startedAt: startedAt,
        endedAt: startedAt.add(const Duration(hours: 1, minutes: 5)),
      );

      expect(duration, const Duration(hours: 1, minutes: 5));
    });

    test('compares the same instant across time zones', () {
      final duration = calculateRunDuration(
        startedAt: startedAt.toLocal(),
        endedAt: startedAt,
      );

      expect(duration, Duration.zero);
    });

    test('rejects an end before the start', () {
      expect(
        () => calculateRunDuration(
          startedAt: startedAt,
          endedAt: startedAt.subtract(const Duration(seconds: 1)),
        ),
        throwsA(isA<CustomError>()),
      );
    });
  });

  group('run session use cases', () {
    test('start generates an id and captures a UTC start time', () async {
      final startRunSession = StartRunSessionUseCase(
        generateUuidV4: () => AppUuid('session-1'),
        getCurrentTime: () => startedAt.toLocal(),
      );

      final session = await startRunSession.execute(const NoParams());

      expect(session.id.value, 'session-1');
      expect(session.startedAt, startedAt);
      expect(session.startedAt.isUtc, isTrue);
    });

    test('each new session gets a unique id', () async {
      final startRunSession = StartRunSessionUseCase();

      final first = await startRunSession.execute(const NoParams());
      final second = await startRunSession.execute(const NoParams());

      expect(first.id.value, isNotEmpty);
      expect(first.id.value, isNot(second.id.value));
    });

    test('finish records the end time and the session duration', () async {
      final endedAt = startedAt.add(const Duration(minutes: 20, seconds: 30));
      final finishRunSession = FinishRunSessionUseCase(
        getCurrentTime: () => endedAt,
      );

      final session = await finishRunSession.execute(
        ActiveRunSession(id: AppUuid('session-1'), startedAt: startedAt),
      );

      expect(session.id.value, 'session-1');
      expect(session.startedAt, startedAt);
      expect(session.endedAt, endedAt);
      expect(session.durationInSeconds, 1230);
      expect(session.durationInMilliseconds, 1230000);
    });

    test('finish fails when the clock went backwards', () {
      final finishRunSession = FinishRunSessionUseCase(
        getCurrentTime: () => startedAt.subtract(const Duration(minutes: 1)),
      );

      expect(
        () => finishRunSession.execute(
          ActiveRunSession(id: AppUuid('session-1'), startedAt: startedAt),
        ),
        throwsA(isA<CustomError>()),
      );
    });
  });
}
