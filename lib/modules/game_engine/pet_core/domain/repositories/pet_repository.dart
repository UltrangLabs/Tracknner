import '../../../../../core/domain/types/app_uuid.dart';
import '../dtos/in/ensure_user_pet_dto.dart';
import '../dtos/in/user_amount_dto.dart';
import '../entities/pet.dart';
import '../services/progression_rules.dart';

abstract class PetRepository {
  Future<Pet> ensurePet(EnsureUserPetDto dto);
  Future<PetProgress> addExperience(UserAmountDto dto);
  Future<Pet?> findByUser(AppUuid userId);
}
