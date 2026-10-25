import '../../domain/datasources/query_user_datasource.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/query_user_repository.dart';

class QueryLocalRepository implements QueryUserRepository {
  final QueryUserDatasource queryDatasource;

  QueryLocalRepository({required this.queryDatasource});

  @override
  Future<User> queryUser(String userId) {
    return queryDatasource.queryUser(userId);
  }

  @override
  Future<int> queryUserVirtualCoins(String userId) {
    return queryDatasource.queryUserVirtualCoins(userId);
  }

  @override
  Future<bool> queryUserIsPremium(String userId) {
    return queryDatasource.queryUserIsPremium(userId);
  }
}
