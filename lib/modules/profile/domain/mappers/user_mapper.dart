import '../../../../core/domain/types/unknown_type.dart';
import '../../domain/entities/user_entity.dart';
import '../dtos/in/create_user_dto.dart';

abstract class UserMapper {
  User fromDbToEntity(Unknown dbData);
  Unknown fromEntityToDb(User user);
  Unknown fromCreateDtoToDb(CreateUserDto dto);
}
