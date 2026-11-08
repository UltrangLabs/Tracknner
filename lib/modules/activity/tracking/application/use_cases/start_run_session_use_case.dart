import '../../../../../core/domain/use_cases/interfaces/structure_use_case.dart';
import '../../../../../core/infrastructure/adapters/clock_adapter.dart';
import '../../../../../core/infrastructure/adapters/uuid_adapter.dart';
import '../../domain/entities/active_run_session.dart';

typedef ExecuteStartRunSessionUseCase = Future<ActiveRunSession> Function(
  NoParams params,
);

class StartRunSessionUseCase
    implements UseCaseStructure<ActiveRunSession, NoParams> {
  final GenerateUuIdV4 _generateUuidV4;
  final GetCurrentTime _getCurrentTime;

  StartRunSessionUseCase({
    this._generateUuidV4 = generateUuidV4,
    this._getCurrentTime = currentUtcTime,
  });

  @override
  Future<ActiveRunSession> execute(NoParams params) async {
    return ActiveRunSession(
      id: _generateUuidV4(),
      startedAt: _getCurrentTime().toUtc(),
    );
  }
}
