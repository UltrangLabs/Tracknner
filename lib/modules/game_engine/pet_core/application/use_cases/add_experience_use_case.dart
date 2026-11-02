import '../../../../../core/domain/errors/custom_error.dart';
import '../../../../../core/domain/types/unknown_type.dart';
import '../../../../../core/domain/use_cases/interfaces/structure_use_case.dart';
import '../../domain/repositories/pet_repository.dart';
import '../../domain/services/progression_rules.dart';
import '../dtos/in/save_pet_progress_dto.dart';
import '../dtos/in/user_amount_dto.dart';

typedef ExecuteAddExperienceUseCase = Future<PetProgress> Function(
  Unknown rawData,
);

class AddExperienceUseCase implements UseCaseStructure<PetProgress, Unknown> {
  static const String _errorPath =
      'modules.game_engine.pet_core.add_experience';

  final PetRepository _petRepository;
  final ValidatorUserAmountDto _userAmountValidator;
  final ValidatorSavePetProgressDto _savePetProgressValidator;

  AddExperienceUseCase({
    required this._petRepository,
    required this._userAmountValidator,
    required this._savePetProgressValidator,
  });

  @override
  Future<PetProgress> execute(Unknown rawData) async {
    final userAmountDto = UserAmountDtoImpl.create(
      rawData: rawData,
      validator: _userAmountValidator,
    );

    final pet = await _petRepository.findByUser(userAmountDto.userId);

    if (pet == null) {
      throw CustomError.notFound(message: 'Pet not found', path: _errorPath);
    }

    final progress = applyExperience(
      level: pet.level,
      experience: pet.experience,
      gainedExperience: userAmountDto.amount,
    );

    final savePetProgressDto = SavePetProgressDtoImpl.create(
      rawData: {
        'petId': pet.id.value,
        'level': progress.level,
        'experience': progress.experience,
      },
      validator: _savePetProgressValidator,
    );

    await _petRepository.saveProgress(savePetProgressDto);

    return progress;
  }
}
