import '../../../../../core/domain/errors/custom_error.dart';
import '../../../../../core/domain/use_cases/interfaces/structure_use_case.dart';
import '../../domain/dtos/in/user_amount_dto.dart';
import '../../domain/repositories/pet_repository.dart';
import '../../domain/services/progression_rules.dart';

typedef ExecuteAddExperienceUseCase = Future<PetProgress> Function(
  UserAmountDto dto,
);

class AddExperienceUseCase
    implements UseCaseStructure<PetProgress, UserAmountDto> {
  static const String _errorPath =
      'modules.game_engine.pet_core.add_experience';

  final PetRepository _petRepository;

  AddExperienceUseCase({required this._petRepository});

  @override
  Future<PetProgress> execute(UserAmountDto dto) async {
    if (dto.amount <= 0) {
      throw CustomError.badRequest(
        payload: [(message: 'Amount must be positive', path: 'amount')],
        path: _errorPath,
      );
    }

    final pet = await _petRepository.findByUser(dto.userId);

    if (pet == null) {
      throw CustomError.notFound(message: 'Pet not found', path: _errorPath);
    }

    final progress = applyExperience(
      level: pet.level,
      experience: pet.experience,
      gainedExperience: dto.amount,
    );

    await _petRepository.saveProgress(
      petId: pet.id,
      level: progress.level,
      experience: progress.experience,
    );

    return progress;
  }
}
