// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get applicationTitle => 'Tracknner';

  @override
  String get startRunningButton => 'Comenzar a Correr';

  @override
  String get stopRunningButton => 'Detener Carrera';

  @override
  String distanceTraveledMessage(double distanceInKilometers) {
    return '¡Has corrido $distanceInKilometers kilómetros!';
  }

  @override
  String get errorBadRequest => 'Petición incorrecta. Revisa tus datos.';

  @override
  String get errorUnauthorized =>
      'No estás autorizado para realizar esta acción.';

  @override
  String get errorForbidden => 'Acceso denegado.';

  @override
  String get errorNotFound => 'El recurso no fue encontrado.';

  @override
  String get errorInternalServer => 'Error interno del servidor.';

  @override
  String get errorServiceUnavailable => 'Servicio no disponible temporalmente.';

  @override
  String get errorUnexpected => 'Ocurrió un error inesperado.';
}
