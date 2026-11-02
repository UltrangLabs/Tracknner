import '../../../../../core/domain/errors/custom_error.dart';
import '../../../../../core/domain/types/app_uuid.dart';
import '../../../../../core/infrastructure/adapters/uuid_adapter.dart';
import '../../../../../core/infrastructure/database/interfaces/local_db_client.dart';
import '../../domain/dtos/in/ensure_user_pet_dto.dart';
import '../../domain/entities/pet.dart';
import '../../domain/repositories/pet_repository.dart';

class PetLocalRepository implements PetRepository {
  static const String _tableName = 'Pet';
  static const int _initialLevel = 1;
  static const int _initialExperience = 0;

  final LocalDbClient _dbClient;
  final GenerateUuIdV4 _generateUuIdV4;

  PetLocalRepository({
    required this._dbClient,
    this._generateUuIdV4 = generateUuidV4,
  });

  @override
  Future<Pet?> findByUser(AppUuid userId) async {
    final rows = await _dbClient.query(
      _tableName,
      conditions: (where: 'userId = ?', whereArgs: [userId.value]),
    );

    return rows.isEmpty ? null : _toEntity(rows.first);
  }

  @override
  Future<Pet> create(EnsureUserPetDto dto) async {
    final pet = Pet(
      id: _generateUuIdV4(),
      userId: dto.userId,
      name: dto.name,
      breed: dto.breed,
      imageAssetName: dto.imageAssetName,
      level: _initialLevel,
      experience: _initialExperience,
    );

    await _dbClient.insert(_tableName, {
      'petId': pet.id.value,
      'userId': pet.userId.value,
      'petName': pet.name,
      'petBreed': pet.breed,
      'imageAssetName': pet.imageAssetName,
      'currentLevel': pet.level,
      'currentExperience': pet.experience,
    });

    return pet;
  }

  @override
  Future<void> saveProgress({
    required AppUuid petId,
    required int level,
    required int experience,
  }) async {
    final updatedRows = await _dbClient.update(
      _tableName,
      {'currentLevel': level, 'currentExperience': experience},
      conditions: (where: 'petId = ?', whereArgs: [petId.value]),
    );

    if (updatedRows == 0) {
      throw CustomError.notFound(
        message: 'Pet not found',
        path: 'modules.game_engine.pet_core.pet_local_repository',
      );
    }
  }

  Pet _toEntity(DbValues row) {
    return Pet(
      id: AppUuid(row['petId'] as String),
      userId: AppUuid(row['userId'] as String),
      name: row['petName'] as String,
      breed: row['petBreed'] as String,
      imageAssetName: row['imageAssetName'] as String,
      level: row['currentLevel'] as int,
      experience: row['currentExperience'] as int,
    );
  }
}
