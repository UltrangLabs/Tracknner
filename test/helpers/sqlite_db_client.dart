import 'package:running/core/infrastructure/database/interfaces/local_db_client.dart';
import 'package:sqflite_common_ffi/sqflite_common_ffi.dart';

// Ejecuta los repositorios contra las tablas reales en una base en memoria.
class SqliteDbClient implements LocalDbClient {
  final Database _db;

  SqliteDbClient(this._db);

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
      columns: columns,
      where: conditions?.where,
      whereArgs: conditions?.whereArgs,
      limit: limit,
    );
  }

  @override
  Future<int> insert(String table, DbValues values) {
    return _db.insert(table, values);
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
  Never noSuchMethod(Invocation invocation) {
    throw UnimplementedError();
  }
}
