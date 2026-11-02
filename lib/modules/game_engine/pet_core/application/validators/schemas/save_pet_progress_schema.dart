import 'package:lucid_validation/lucid_validation.dart';

import '../../../domain/dtos/in/save_pet_progress_dto.dart';

class SavePetProgressValidateSchema extends LucidValidator<SavePetProgressDto> {
  static const int _minLevel = 1;
  static const int _minExperience = 0;

  SavePetProgressValidateSchema() {
    ruleFor(
      (dto) => dto.petId.value,
      key: 'petId',
    ).notEmpty(message: 'Parámetro inválido');

    ruleFor(
      (dto) => dto.level,
      key: 'level',
    ).min(_minLevel, message: 'El nivel mínimo es 1');

    ruleFor(
      (dto) => dto.experience,
      key: 'experience',
    ).min(_minExperience, message: 'La experiencia no puede ser negativa');
  }
}
