import '../../../../../core/domain/errors/custom_error.dart';
import '../../../../../core/domain/use_cases/interfaces/structure_use_case.dart';
import '../../domain/entities/mission_result.dart';
import 'get_daily_mission_use_case.dart';

typedef ExecuteValidateMissionUseCase = Future<MissionResult> Function(
  int completedDurationSeconds,
);

class ValidateMissionUseCase implements UseCaseStructure<MissionResult, int> {
  final ExecuteGetDailyMissionUseCase _getDailyMission;

  ValidateMissionUseCase({required this._getDailyMission});

  @override
  Future<MissionResult> execute(int completedDurationSeconds) async {
    if (completedDurationSeconds < 0) {
      throw CustomError.badRequest(
        payload: [
          (
            message: 'Duration cannot be negative',
            path: 'completedDurationSeconds',
          ),
        ],
        path: 'modules.game_engine.missions.validate_mission',
      );
    }

    final mission = await _getDailyMission(const NoParams());

    return MissionResult(
      status: completedDurationSeconds >= mission.targetDurationSeconds
          ? MissionStatus.success
          : MissionStatus.failed,
      targetDurationSeconds: mission.targetDurationSeconds,
      completedDurationSeconds: completedDurationSeconds,
    );
  }
}
