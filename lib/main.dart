import 'package:flutter/material.dart';

import 'core/infrastructure/adapters/logger_adapter.dart' as logger_adapter;
import 'core/infrastructure/database/di/database_di.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  logger_adapter.logCyanBold('Starting application...');
  await initDatabaseDi();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tracknner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: 1).theme(),
      home: const Scaffold(body: Center(child: Text('Hello World'))),
    );
  }
}
