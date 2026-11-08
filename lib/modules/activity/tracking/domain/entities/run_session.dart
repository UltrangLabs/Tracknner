import '../../../../../core/domain/types/app_uuid.dart';

class RunSession {
  final AppUuid id;
  final DateTime startedAt;
  final DateTime endedAt;
  final Duration duration;

  const RunSession({
    required this.id,
    required this.startedAt,
    required this.endedAt,
    required this.duration,
  });

  int get durationInSeconds => duration.inSeconds;

  int get durationInMilliseconds => duration.inMilliseconds;
}
