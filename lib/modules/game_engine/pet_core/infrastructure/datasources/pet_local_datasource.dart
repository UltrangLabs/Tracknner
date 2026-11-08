import '../../../../../core/domain/errors/custom_error.dart';
import '../../../../../core/domain/types/app_uuid.dart';
import '../../../../../core/infrastructure/database/interfaces/local_db_client.dart';

import '../../domain/datasources/pet_datasource.dart';
import '../../domain/dtos/in/ensure_user_pet_dto.dart';
import '../../domain/dtos/in/user_amount_dto.dart';
import '../../domain/entities/pet.dart';
import '../../domain/mappers/pet_mapper.dart';
import '../../domain/services/progression_rules.dart';

class PetLocalDatasource implements PetDatasource {
  static const String _tableName = 'Pet';
  static const String _errorPath = 'Error en la mascota';

  final LocalDbClient _dbClient;
  final PetMapper _petMapper;

  PetLocalDatasource({required this._dbClient, required this._petMapper});

  @override
  Future<Pet> ensurePet(EnsureUserPetDto dto) async {
    final existingPet = await findByUser(dto.userId);
    if (existingPet != null) {
      return existingPet;
    }

    return _insertPet(dto);
  }

  @override
  Future<PetProgress> addExperience(UserAmountDto dto) async {
    final currentPet = await _getExistingPet(dto.userId);

    final progress = applyExperience(
      level: currentPet.level,
      experience: currentPet.experience,
      gainedExperience: dto.amount,
    );

    await _updatePetProgress(petId: currentPet.id, progress: progress);

    return progress;
  }

  @override
  Future<Pet?> findByUser(AppUuid userId) async {
    final rows = await _dbClient.query(
      _tableName,
      conditions: (where: 'userId = ?', whereArgs: [userId.value]),
      limit: 1,
    );

    return rows.isEmpty ? null : _petMapper.fromDbToEntity(rows.first);
  }

  Future<Pet> _insertPet(EnsureUserPetDto dto) async {
    final pet = _petMapper.fromEnsureDtoToEntity(dto);

    final insertedId = await _dbClient.insert(
      _tableName,
      _petMapper.fromEntityToDb(pet),
    );

    if (insertedId == 0) {
      throw CustomError.internalServer(
        message: 'Error al registrar la mascota',
        path: _errorPath,
      );
    }

    return pet;
  }

  Future<Pet> _getExistingPet(AppUuid userId) async {
    final pet = await findByUser(userId);
    if (pet == null) {
      throw CustomError.notFound(message: 'Pet not found', path: _errorPath);
    }

    return pet;
  }

  Future<void> _updatePetProgress({
    required AppUuid petId,
    required PetProgress progress,
  }) async {
    final updatedRows = await _dbClient.update(
      _tableName,
      _petMapper.fromProgressToDb(progress),
      conditions: (where: 'petId = ?', whereArgs: [petId.value]),
    );

    if (updatedRows == 0) {
      throw CustomError.notFound(message: 'Pet not found', path: _errorPath);
    }
  }
}
