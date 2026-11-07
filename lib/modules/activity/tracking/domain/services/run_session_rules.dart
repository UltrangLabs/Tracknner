import '../../../../../core/domain/errors/custom_error.dart';

const String _errorPath = 'modules.activity.tracking.run_session_rules';

// Duración exacta entre dos marcas de tiempo. Se calcula a partir de los
// timestamps y no contando ticks, así el tiempo que la app pasó suspendida
// por el SO también se contabiliza.
Duration calculateRunDuration({
  required DateTime startedAt,
  required DateTime endedAt,
}) {
  _validateChronologicalOrder(startedAt: startedAt, endedAt: endedAt);

  return endedAt.toUtc().difference(startedAt.toUtc());
}

// Un fin anterior al inicio indica que el reloj del sistema retrocedió.
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
