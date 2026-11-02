import '../../../../../core/domain/types/app_uuid.dart';
import '../../domain/datasources/pet_datasource.dart';
import '../../domain/dtos/in/ensure_user_pet_dto.dart';
import '../../domain/dtos/in/save_pet_progress_dto.dart';
import '../../domain/entities/pet.dart';
import '../../domain/repositories/pet_repository.dart';

class PetRepositoryImpl implements PetRepository {
  final PetDatasource _petDatasource;

  PetRepositoryImpl({required this._petDatasource});

  @override
  Future<Pet?> findByUser(AppUuid userId) {
    return _petDatasource.findByUser(userId);
  }

  @override
  Future<Pet> create(EnsureUserPetDto dto) {
    return _petDatasource.create(dto);
  }

  @override
  Future<void> saveProgress(SavePetProgressDto dto) {
    return _petDatasource.saveProgress(dto);
  }
}
