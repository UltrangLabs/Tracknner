import '../../../../../core/domain/types/unknown_type.dart';
import '../../../../../core/domain/use_cases/interfaces/structure_use_case.dart';
import '../../domain/entities/pet.dart';
import '../../domain/repositories/pet_repository.dart';
import '../dtos/in/ensure_user_pet_dto.dart';

typedef ExecuteEnsureUserPetUseCase = Future<Pet> Function(Unknown rawData);

class EnsureUserPetUseCase implements UseCaseStructure<Pet, Unknown> {
  final PetRepository _petRepository;
  final ValidatorEnsureUserPetDto _ensureUserPetValidator;

  EnsureUserPetUseCase({
    required this._petRepository,
    required this._ensureUserPetValidator,
  });

  @override
  Future<Pet> execute(Unknown rawData) async {
    final ensureUserPetDto = EnsureUserPetDtoImpl.create(
      rawData: rawData,
      validator: _ensureUserPetValidator,
    );

    return _petRepository.ensurePet(ensureUserPetDto);
  }
}
