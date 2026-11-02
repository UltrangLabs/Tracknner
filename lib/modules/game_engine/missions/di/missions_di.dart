import '../../../../core/di/injection_container.dart';
import '../application/use_cases/get_daily_mission_use_case.dart';
import '../application/use_cases/validate_mission_use_case.dart';

void initMissionsDi() {
  //* Use Cases
  late final getDailyMission = GetDailyMissionUseCase();
  late final validateMission = ValidateMissionUseCase(
    getDailyMission: getDailyMission.execute,
  );

  //* Actions
  sl.registerLazySingleton<ExecuteGetDailyMissionUseCase>(
    () => getDailyMission.execute,
  );
  sl.registerLazySingleton<ExecuteValidateMissionUseCase>(
    () => validateMission.execute,
  );
}
