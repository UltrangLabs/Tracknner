import '../../../../../core/domain/types/app_uuid.dart';
import '../dtos/in/ensure_user_pet_dto.dart';
import '../dtos/in/save_pet_progress_dto.dart';
import '../entities/pet.dart';

abstract class PetDatasource {
  Future<Pet?> findByUser(AppUuid userId);
  Future<Pet> create(EnsureUserPetDto dto);
  Future<void> saveProgress(SavePetProgressDto dto);
}
