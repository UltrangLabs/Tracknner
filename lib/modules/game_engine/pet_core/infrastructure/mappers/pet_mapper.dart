import '../../../../../core/domain/errors/custom_error.dart';
import '../../../../../core/domain/types/app_uuid.dart';
import '../../../../../core/domain/types/unknown_type.dart';
import '../../../../../core/infrastructure/adapters/uuid_adapter.dart';
import '../../domain/constants/base_pet_values.dart';
import '../../domain/dtos/in/ensure_user_pet_dto.dart';
import '../../domain/entities/pet.dart';
import '../../domain/mappers/pet_mapper.dart';
import '../../domain/services/progression_rules.dart';

class PetMapperImpl implements PetMapper {
  final GenerateUuIdV4 _generateUuIdV4;

  PetMapperImpl({this._generateUuIdV4 = generateUuidV4});

  @override
  Pet fromDbToEntity(Unknown dbData) {
    if (dbData.isEmpty) {
      throw CustomError.badRequest(
        payload: [(message: 'The data is Empty', path: 'Pet mapper')],
        path: 'mapper',
      );
    }

    return Pet(
      id: AppUuid(dbData['petId'] as String),
      userId: AppUuid(dbData['userId'] as String),
      name: dbData['petName'] as String,
      breed: dbData['petBreed'] as String,
      imageAssetName: dbData['imageAssetName'] as String,
      level: dbData['currentLevel'] as int,
      experience: dbData['currentExperience'] as int,
    );
  }

  @override
  Unknown fromEntityToDb(Pet pet) {
    return {
      'petId': pet.id.value,
      'userId': pet.userId.value,
      'petName': pet.name,
      'petBreed': pet.breed,
      'imageAssetName': pet.imageAssetName,
      'currentLevel': pet.level,
      'currentExperience': pet.experience,
    };
  }

  @override
  Pet fromEnsureDtoToEntity(EnsureUserPetDto dto) {
    return Pet(
      id: _generateUuIdV4(),
      userId: dto.userId,
      name: dto.name,
      breed: dto.breed,
      imageAssetName: dto.imageAssetName,
      level: kDefaultPetValues.level,
      experience: kDefaultPetValues.experience,
    );
  }

  @override
  Unknown fromProgressToDb(PetProgress progress) {
    return {
      'currentLevel': progress.level,
      'currentExperience': progress.experience,
    };
  }
}
