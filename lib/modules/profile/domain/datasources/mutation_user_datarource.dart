import '../dtos/in/create_user_dto.dart';

abstract class MutationUserDatarource {
  Future<void> createUser({required CreateUserDto dto});
}
