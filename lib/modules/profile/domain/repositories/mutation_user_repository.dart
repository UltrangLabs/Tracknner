import '../dtos/in/create_user_dto.dart';

abstract class MutationUserRepository {
  Future<void> createUser({required CreateUserDto dto});
}
