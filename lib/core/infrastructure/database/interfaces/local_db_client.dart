typedef DbValues = Map<String, dynamic>;

typedef DbConditionParams = ({String? where, List<Object?>? whereArgs});

abstract class LocalDbClient {
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
  });

  Future<List<DbValues>> rawQuery(String sql, [List<Object?>? arguments]);

  Future<int> insert(String table, DbValues values);

  Future<int> update(
    String table,
    DbValues values, {
    DbConditionParams? conditions,
  });

  Future<int> delete(String table, {DbConditionParams? conditions});

  Future<int> rawInsert(String sql, [List<Object?>? arguments]);

  Future<int> rawUpdate(String sql, [List<Object?>? arguments]);

  Future<int> rawDelete(String sql, [List<Object?>? arguments]);
}
