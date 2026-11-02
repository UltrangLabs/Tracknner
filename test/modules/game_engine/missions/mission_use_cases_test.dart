import 'package:flutter_test/flutter_test.dart';
import 'package:running/core/domain/errors/custom_error.dart';
import 'package:running/core/domain/use_cases/interfaces/structure_use_case.dart';
import 'package:running/modules/game_engine/game_engine_module.dart';

void main() {
  final getDailyMission = GetDailyMissionUseCase();
  final validateMission = ValidateMissionUseCase(
    getDailyMission: getDailyMission.execute,
  );

  test('daily mission targets 15 minutes', () async {
    final mission = await getDailyMission.execute(const NoParams());

    expect(mission.targetDurationSeconds, 900);
  });

  test('succeeds when duration reaches the target', () async {
    final result = await validateMission.execute(900);

    expect(result.status, MissionStatus.success);
    expect(result.isRewardEligible, isTrue);
  });

  test('fails without reward below the target', () async {
    final result = await validateMission.execute(899);

    expect(result.status, MissionStatus.failed);
    expect(result.isRewardEligible, isFalse);
  });

  test('rejects negative durations', () {
    expect(() => validateMission.execute(-1), throwsA(isA<CustomError>()));
  });
}
