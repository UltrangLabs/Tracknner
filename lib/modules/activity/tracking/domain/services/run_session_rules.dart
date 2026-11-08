import '../../../../../core/domain/errors/custom_error.dart';

const String _errorPath = 'modules.activity.tracking.run_session_rules';

Duration calculateRunDuration({
  required DateTime startedAt,
  required DateTime endedAt,
}) {
  _validateChronologicalOrder(startedAt: startedAt, endedAt: endedAt);

  return endedAt.toUtc().difference(startedAt.toUtc());
}

void _validateChronologicalOrder({
  required DateTime startedAt,
  required DateTime endedAt,
}) {
  if (endedAt.isBefore(startedAt)) {
    throw CustomError.badRequest(
      payload: [
        (
          message: 'La hora de fin no puede ser anterior a la de inicio',
          path: 'endedAt',
        ),
      ],
      path: _errorPath,
    );
  }
}
