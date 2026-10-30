import '../dtos/in/looking_user_exist_dto.dart';
import '../entities/user_entity.dart';

abstract class QueryUserRepository {
  Future<User> queryUser(String userId);
  Future<int> queryUserVirtualCoins(String userId);
  Future<bool> queryUserIsPremium(String userId);
  Future<User?> lookingForUserExist(LookingUserDto dto);
}
