import '../../../../../core/domain/types/unknown_type.dart';
import '../../../../../core/infrastructure/adapters/validator_adapter.dart';
import '../../../domain/dtos/in/create_user_dto.dart';

typedef ValidatorCreateUserDto = ValidatorAdapter<CreateUserDto>;

class CreateUserDtoImpl implements CreateUserDto {
  @override
  final String name;

  const CreateUserDtoImpl._({required this.name});

  static CreateUserDto create({
    required Unknown rawData,
    required ValidatorCreateUserDto validator,
  }) {
    final unvalidatedDto = _mapFromRaw(rawData);
    final validatedDto = validator.validate(unvalidatedDto);

    return validatedDto;
  }

  static CreateUserDto _mapFromRaw(Unknown rawData) {
    return CreateUserDtoImpl._(name: rawData['name']?.toString() ?? "");
  }
}
