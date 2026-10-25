import '../entities/user_entity.dart';

abstract class QueryUserDatasource {
  Future<User> queryUser(String userId);
  Future<int> queryUserVirtualCoins(String userId);
  Future<bool> queryUserIsPremium(String userId);
}
