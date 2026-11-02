import 'package:lucid_validation/lucid_validation.dart';

import '../../../domain/dtos/in/ensure_user_pet_dto.dart';

class EnsureUserPetValidateSchema extends LucidValidator<EnsureUserPetDto> {
  static const int _minLength = 2;
  static const int _maxLength = 50;
  static const String _safeTextPattern =
      r'^[a-zA-Z0-9\s\-_.,!¡?¿@ñÑáéíóúÁÉÍÓÚ]+$';
  static const String _assetPattern = r'^[a-zA-Z0-9_\-/.]+$';

  EnsureUserPetValidateSchema() {
    ruleFor(
      (dto) => dto.userId.value,
      key: 'userId',
    ).notEmpty(message: 'Parámetro inválido');

    ruleFor((dto) => dto.name, key: 'name')
        .notEmpty(message: 'El nombre de la mascota es requerido')
        .minLength(_minLength, message: 'El nombre de la mascota es muy corto')
        .maxLength(_maxLength, message: 'El nombre de la mascota es muy largo')
        .matchesPattern(
          _safeTextPattern,
          message: 'El nombre de la mascota contiene caracteres inválidos',
        );

    ruleFor((dto) => dto.breed, key: 'breed')
        .notEmpty(message: 'La raza de la mascota es requerida')
        .maxLength(_maxLength, message: 'La raza de la mascota es muy larga')
        .matchesPattern(
          _safeTextPattern,
          message: 'La raza de la mascota contiene caracteres inválidos',
        );

    ruleFor((dto) => dto.imageAssetName, key: 'imageAssetName')
        .notEmpty(message: 'La imagen de la mascota es requerida')
        .matchesPattern(
          _assetPattern,
          message: 'La ruta de la imagen contiene caracteres inválidos',
        );
  }
}
