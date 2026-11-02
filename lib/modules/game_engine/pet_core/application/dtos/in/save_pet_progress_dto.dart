import '../../../../../../core/domain/types/app_uuid.dart';
import '../../../../../../core/domain/types/unknown_type.dart';
import '../../../../../../core/infrastructure/adapters/validator_adapter.dart';
import '../../../domain/dtos/in/save_pet_progress_dto.dart';

typedef ValidatorSavePetProgressDto = ValidatorAdapter<SavePetProgressDto>;

class SavePetProgressDtoImpl implements SavePetProgressDto {
  @override
  final AppUuid petId;
  @override
  final int level;
  @override
  final int experience;

  const SavePetProgressDtoImpl._({
    required this.petId,
    required this.level,
    required this.experience,
  });

  static SavePetProgressDto create({
    required Unknown rawData,
    required ValidatorSavePetProgressDto validator,
  }) {
    final unvalidatedDto = _mapFromRaw(rawData);
    final validatedDto = validator.validate(unvalidatedDto);

    return validatedDto;
  }

  static SavePetProgressDto _mapFromRaw(Unknown rawData) {
    return SavePetProgressDtoImpl._(
      petId: AppUuid(rawData['petId']?.toString() ?? ""),
      level: int.tryParse(rawData['level']?.toString() ?? "") ?? 0,
      experience: int.tryParse(rawData['experience']?.toString() ?? "") ?? -1,
    );
  }
}
