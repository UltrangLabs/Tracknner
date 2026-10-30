import '../../domain/datasources/query_user_datasource.dart';
import '../../domain/dtos/in/looking_user_exist_dto.dart';
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

  @override
  Future<User?> lookingForUserExist(LookingUserDto dto) {
    return queryDatasource.lookingForUserExist(dto);
  }
}
