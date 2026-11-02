import '../../../../../core/domain/types/app_uuid.dart';
import '../dtos/in/ensure_user_pet_dto.dart';
import '../entities/pet.dart';

abstract class PetRepository {
  Future<Pet?> findByUser(AppUuid userId);
  Future<Pet> create(EnsureUserPetDto dto);
  Future<void> saveProgress({
    required AppUuid petId,
    required int level,
    required int experience,
  });
}
