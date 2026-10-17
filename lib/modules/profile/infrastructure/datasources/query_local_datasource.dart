import '../../domain/datasources/query_user_datasource.dart';
import '../../domain/entities/user_entity.dart';

class QueryUserLocalDatasource implements QueryUserDatasource {
  @override
  Future<User> queryUser(String userId) {
    throw UnimplementedError();
  }

  @override
  Future<bool> queryUserIsPremium(String userId) {
    throw UnimplementedError();
  }

  @override
  Future<int> queryUserVirtualCoins(String userId) {
    throw UnimplementedError();
  }
}
