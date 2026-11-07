import '../../../../../core/domain/types/app_uuid.dart';
import '../../domain/datasources/pet_datasource.dart';
import '../../domain/dtos/in/ensure_user_pet_dto.dart';
import '../../domain/dtos/in/user_amount_dto.dart';
import '../../domain/entities/pet.dart';
import '../../domain/repositories/pet_repository.dart';
import '../../domain/services/progression_rules.dart';

class PetRepositoryImpl implements PetRepository {
  final PetDatasource _petDatasource;

  PetRepositoryImpl({required this._petDatasource});

  @override
  Future<Pet> ensurePet(EnsureUserPetDto dto) {
    return _petDatasource.ensurePet(dto);
  }

  @override
  Future<PetProgress> addExperience(UserAmountDto dto) {
    return _petDatasource.addExperience(dto);
  }

  @override
  Future<Pet?> findByUser(AppUuid userId) {
    return _petDatasource.findByUser(userId);
  }
}
