// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get applicationTitle => 'Tracknner';

  @override
  String get startRunningButton => 'Start Running';

  @override
  String get stopRunningButton => 'Stop Running';

  @override
  String distanceTraveledMessage(double distanceInKilometers) {
    return 'You have run $distanceInKilometers kilometers!';
  }

  @override
  String get errorBadRequest => 'Bad request. Please check your data.';

  @override
  String get errorUnauthorized =>
      'You are not authorized to perform this action.';

  @override
  String get errorForbidden => 'Access denied.';

  @override
  String get errorNotFound => 'Resource not found.';

  @override
  String get errorInternalServer => 'Internal server error.';

  @override
  String get errorServiceUnavailable => 'Service temporarily unavailable.';

  @override
  String get errorUnexpected => 'An unexpected error occurred.';
}
