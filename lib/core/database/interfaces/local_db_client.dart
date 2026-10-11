typedef DbValues = Map<String, dynamic>;

typedef DbConditionParams = ({String? where, List<Object?>? whereArgs});

abstract class LocalDbClient {
  Future<List<DbValues>> query(String table, {DbConditionParams? conditions});

  Future<int> insert(String table, DbValues values);

  Future<int> update(
    String table,
    DbValues values, {
    DbConditionParams? conditions,
  });

  Future<int> delete(String table, {DbConditionParams? conditions});
}
