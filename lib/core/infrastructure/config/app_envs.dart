import 'dart:io';

import '../adapters/logger_adapter.dart' as log_adapter;

class AppEnvs {
  AppEnvs._();

  static const String currentEnv = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: '',
  );

  static bool get isDev => currentEnv == 'dev';
  static bool get isTest => currentEnv == 'test';

  static void validateRequired() {
    final missingEnvs = <String>[];

    if (currentEnv.isEmpty) missingEnvs.add('ENVIRONMENT');

    if (missingEnvs.isNotEmpty) {
      String envsList = '';
      for (final env in missingEnvs) {
        envsList += '  - $env \n';
      }

      log_adapter.logRedBold(
        ' 🚨 FATAL ERROR: VARIABLES DE ENTORNO FALTANTES 🚨\n'
        'Detalle: No se inyectaron las siguientes variables obligatorias: \n'
        '$envsList',
      );

      log_adapter.logYellowBold(
        '\nAcción: Revisa tus archivos .env.dev o tu configuración en launch.json / Makefile.',
      );

      exit(1);
    }
  }
}
