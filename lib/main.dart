import 'package:flutter/material.dart';

import 'core/adapters/logger_adapter.dart' as logger_adapter;
import 'core/database/di/database_di.dart';

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
      theme: ThemeData(useMaterial3: true),
      home: const Scaffold(body: Center(child: Text('Hello World'))),
    );
  }
}
