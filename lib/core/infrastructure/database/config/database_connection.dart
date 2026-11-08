import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_common_ffi.dart';

import '../../adapters/logger_adapter.dart' as log_adapter;
import '../interfaces/database_model.dart';
import '../interfaces/local_db_client.dart';

class DatabaseConnection implements LocalDbClient {
  final List<DatabaseModel> models;
  final String databaseName;
  final int databaseVersion;

  Database? _sqliteInstance;

  DatabaseConnection({
    required this.models,
    this.databaseName = 'tracknner_db.sqlite',
    this.databaseVersion = 1,
  });

  Future<void> initForDesktop() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<void> connect() async {
    log_adapter.logBlueBold('Connecting to the database...');

    try {
      final Directory documentsDirectory =
          await getApplicationDocumentsDirectory();
      final String path = join(documentsDirectory.path, databaseName);

      _sqliteInstance = await openDatabase(
        path,
        version: databaseVersion,
        onCreate: _forceSynchronization,
      );

      log_adapter.logCyanBold('Successful connection to the database');
    } catch (error) {
      log_adapter.logRedBold(
        '[FATAL] Error connecting to the database during startup',
      );
      log_adapter.logRedBold(error.toString());

      rethrow;
    }
  }

  @override
  Future<List<DbValues>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    DbConditionParams? conditions,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) {
    return _db.query(
      table,
      distinct: distinct,
      columns: columns,
      where: conditions?.where,
      whereArgs: conditions?.whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<List<DbValues>> rawQuery(String sql, [List<Object?>? arguments]) {
    return _db.rawQuery(sql, arguments);
  }

  @override
  Future<int> insert(String table, DbValues values) {
    return _db.insert(
      table,
      values,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<int> update(
    String table,
    DbValues values, {
    DbConditionParams? conditions,
  }) {
    return _db.update(
      table,
      values,
      where: conditions?.where,
      whereArgs: conditions?.whereArgs,
    );
  }

  @override
  Future<int> delete(String table, {DbConditionParams? conditions}) {
    return _db.delete(
      table,
      where: conditions?.where,
      whereArgs: conditions?.whereArgs,
    );
  }

  @override
  Future<int> rawInsert(String sql, [List<Object?>? arguments]) {
    return _db.rawInsert(sql, arguments);
  }

  @override
  Future<int> rawUpdate(String sql, [List<Object?>? arguments]) {
    return _db.rawUpdate(sql, arguments);
  }

  @override
  Future<int> rawDelete(String sql, [List<Object?>? arguments]) {
    return _db.rawDelete(sql, arguments);
  }

  Future<void> disconnect() async {
    if (_sqliteInstance != null) {
      await _sqliteInstance!.close();
      _sqliteInstance = null;
    }
  }

  Database get _db {
    if (_sqliteInstance == null) {
      throw Exception('Database not initialized. Call connect() first.');
    }

    return _sqliteInstance!;
  }

  Future<void> _forceSynchronization(Database db, int version) async {
    for (final DatabaseModel model in models) {
      log_adapter.logYellowBold('Syncing table: ${model.tableName}...');
      await db.execute(model.createTableQuery);
    }
  }
}
