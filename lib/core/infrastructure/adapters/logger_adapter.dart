import 'package:logger/logger.dart';

final Logger _logger = Logger(
  printer: PrettyPrinter(methodCount: 0, colors: true),
);

void logCyanBold(String message) {
  _logger.d(message);
}

void logRedBold(String message, [dynamic error, StackTrace? stackTrace]) {
  _logger.e(message, error: error, stackTrace: stackTrace);
}

void logYellowBold(String message) {
  _logger.w(message);
}

void logBlueBold(String message) {
  _logger.i(message);
}
