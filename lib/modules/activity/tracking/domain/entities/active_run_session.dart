import '../../../../../core/domain/types/app_uuid.dart';

// Sesión iniciada que aún no tiene marca de fin.
class ActiveRunSession {
  final AppUuid id;
  final DateTime startedAt;

  const ActiveRunSession({required this.id, required this.startedAt});
}
