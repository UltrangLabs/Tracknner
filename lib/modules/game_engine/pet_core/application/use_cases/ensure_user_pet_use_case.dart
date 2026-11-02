import '../../../../../core/domain/use_cases/interfaces/structure_use_case.dart';
import '../../domain/dtos/in/ensure_user_pet_dto.dart';
import '../../domain/entities/pet.dart';
import '../../domain/repositories/pet_repository.dart';

typedef ExecuteEnsureUserPetUseCase = Future<Pet> Function(
  EnsureUserPetDto dto,
);

class EnsureUserPetUseCase implements UseCaseStructure<Pet, EnsureUserPetDto> {
  final PetRepository _petRepository;

  EnsureUserPetUseCase({required this._petRepository});

  @override
  Future<Pet> execute(EnsureUserPetDto dto) async {
    final pet = await _petRepository.findByUser(dto.userId);

    return pet ?? await _petRepository.create(dto);
  }
}
