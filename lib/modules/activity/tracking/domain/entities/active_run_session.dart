import '../../../../../core/domain/types/app_uuid.dart';

class ActiveRunSession {
  final AppUuid id;
  final DateTime startedAt;

  const ActiveRunSession({required this.id, required this.startedAt});
}
