import '../../../../../core/domain/types/unknown_type.dart';
import '../../../../../core/domain/use_cases/interfaces/structure_use_case.dart';
import '../../domain/repositories/pet_repository.dart';
import '../../domain/services/progression_rules.dart';
import '../dtos/in/user_amount_dto.dart';

typedef ExecuteAddExperienceUseCase = Future<PetProgress> Function(
  Unknown rawData,
);

class AddExperienceUseCase implements UseCaseStructure<PetProgress, Unknown> {
  final PetRepository _petRepository;
  final ValidatorUserAmountDto _userAmountValidator;

  AddExperienceUseCase({
    required this._petRepository,
    required this._userAmountValidator,
  });

  @override
  Future<PetProgress> execute(Unknown rawData) async {
    final userAmountDto = UserAmountDtoImpl.create(
      rawData: rawData,
      validator: _userAmountValidator,
    );

    return _petRepository.addExperience(userAmountDto);
  }
}
