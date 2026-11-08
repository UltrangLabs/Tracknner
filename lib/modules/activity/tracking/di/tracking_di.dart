import '../../../../core/di/injection_container.dart';
import '../application/use_cases/finish_run_session_use_case.dart';
import '../application/use_cases/start_run_session_use_case.dart';

void initTrackingDi() {
  //* Use Cases
  late final startRunSession = StartRunSessionUseCase();
  late final finishRunSession = FinishRunSessionUseCase();

  //* Actions
  sl.registerLazySingleton<ExecuteStartRunSessionUseCase>(
    () => startRunSession.execute,
  );
  sl.registerLazySingleton<ExecuteFinishRunSessionUseCase>(
    () => finishRunSession.execute,
  );
}
