import '../../../../../core/domain/use_cases/interfaces/structure_use_case.dart';
import '../../../../../core/infrastructure/adapters/clock_adapter.dart';
import '../../domain/entities/active_run_session.dart';
import '../../domain/entities/run_session.dart';
import '../../domain/services/run_session_rules.dart';

typedef ExecuteFinishRunSessionUseCase = Future<RunSession> Function(
  ActiveRunSession activeSession,
);

class FinishRunSessionUseCase
    implements UseCaseStructure<RunSession, ActiveRunSession> {
  final GetCurrentTime _getCurrentTime;

  FinishRunSessionUseCase({this._getCurrentTime = currentUtcTime});

  @override
  Future<RunSession> execute(ActiveRunSession activeSession) async {
    final endedAt = _getCurrentTime().toUtc();

    return RunSession(
      id: activeSession.id,
      startedAt: activeSession.startedAt,
      endedAt: endedAt,
      duration: calculateRunDuration(
        startedAt: activeSession.startedAt,
        endedAt: endedAt,
      ),
    );
  }
}
