import '../../../../../../core/domain/types/app_uuid.dart';
import '../../../../../../core/domain/types/unknown_type.dart';
import '../../../../../../core/infrastructure/adapters/validator_adapter.dart';
import '../../../domain/dtos/in/ensure_user_pet_dto.dart';

typedef ValidatorEnsureUserPetDto = ValidatorAdapter<EnsureUserPetDto>;

class EnsureUserPetDtoImpl implements EnsureUserPetDto {
  @override
  final AppUuid userId;
  @override
  final String name;
  @override
  final String breed;
  @override
  final String imageAssetName;

  const EnsureUserPetDtoImpl._({
    required this.userId,
    required this.name,
    required this.breed,
    required this.imageAssetName,
  });

  static EnsureUserPetDto create({
    required Unknown rawData,
    required ValidatorEnsureUserPetDto validator,
  }) {
    final unvalidatedDto = _mapFromRaw(rawData);
    final validatedDto = validator.validate(unvalidatedDto);

    return validatedDto;
  }

  static EnsureUserPetDto _mapFromRaw(Unknown rawData) {
    return EnsureUserPetDtoImpl._(
      userId: AppUuid(rawData['userId']?.toString() ?? ""),
      name: rawData['name']?.toString() ?? "",
      breed: rawData['breed']?.toString() ?? "",
      imageAssetName: rawData['imageAssetName']?.toString() ?? "",
    );
  }
}
