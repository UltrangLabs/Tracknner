import '../../../../../core/domain/types/unknown_type.dart';
import '../../../../../core/infrastructure/adapters/validator_adapter.dart';
import '../../../domain/dtos/in/looking_user_exist_dto.dart';

typedef ValidatorLookingUserDto = ValidatorAdapter<LookingUserDto>;

class LookingUserExistsDto implements LookingUserDto {
  @override
  final String name;

  const LookingUserExistsDto._({required this.name});

  static LookingUserDto create({
    required Unknown rawData,
    required ValidatorLookingUserDto validator,
  }) {
    final unvalidatedDto = _mapFromRaw(rawData);
    final validatedDto = validator.validate(unvalidatedDto);

    return validatedDto;
  }

  static LookingUserDto _mapFromRaw(Unknown rawData) {
    return LookingUserExistsDto._(name: rawData['name']?.toString() ?? "");
  }
}
