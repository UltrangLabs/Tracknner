import '../../../../../core/domain/types/unknown_type.dart';
import '../dtos/in/ensure_user_pet_dto.dart';
import '../entities/pet.dart';
import '../services/progression_rules.dart';

abstract class PetMapper {
  Pet fromDbToEntity(Unknown dbData);
  Unknown fromEntityToDb(Pet pet);
  Pet fromEnsureDtoToEntity(EnsureUserPetDto dto);
  Unknown fromProgressToDb(PetProgress progress);
}
