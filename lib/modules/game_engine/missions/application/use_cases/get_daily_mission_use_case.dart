import '../../../../../core/domain/use_cases/interfaces/structure_use_case.dart';
import '../../domain/entities/daily_mission.dart';

typedef ExecuteGetDailyMissionUseCase = Future<DailyMission> Function(
  NoParams params,
);

class GetDailyMissionUseCase
    implements UseCaseStructure<DailyMission, NoParams> {
  // Meta estática del MVP: 15 minutos.
  static const int _targetDurationSeconds = 900;

  @override
  Future<DailyMission> execute(NoParams params) async {
    return const DailyMission(targetDurationSeconds: _targetDurationSeconds);
  }
}
