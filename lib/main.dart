import 'package:flutter/material.dart';

import 'core/infrastructure/adapters/logger_adapter.dart' as logger_adapter;
import 'core/infrastructure/config/app_envs.dart';
import 'core/infrastructure/database/di/database_di.dart';
import 'core/presentation/routers/app_router.dart';
import 'modules/activity/activity_module.dart';
import 'modules/game_engine/game_engine_module.dart';
import 'modules/profile/di/profile_di.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  AppEnvs.validateRequired();

  WidgetsFlutterBinding.ensureInitialized();

  logger_adapter.logCyanBold('Starting application...');
  await initDatabaseDi();
  initProfileDi();
  initPetCoreDi();
  initMissionsDi();
  initTrackingDi();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tracknner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().theme(),
      routerConfig: appRouter,
    );
  }
}
