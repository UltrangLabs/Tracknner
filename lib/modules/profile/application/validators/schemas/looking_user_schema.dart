import 'package:lucid_validation/lucid_validation.dart';

import '../../../domain/dtos/in/looking_user_exist_dto.dart';

class LookingUserValidateSchema extends LucidValidator<LookingUserDto> {
  static const int _minLength = 3;
  static const int _maxLength = 50;
  static const String _safeTextPattern =
      r'^[a-zA-Z0-9\s\-_.,!¡?¿@ñÑáéíóúÁÉÍÓÚ]+$';

  static const String _name = 'name';

  LookingUserValidateSchema() {
    ruleFor((dto) => dto.name, key: _name)
        .notEmpty(message: 'El nombre es requerido')
        .minLength(_minLength, message: 'El nombre es muy corto')
        .maxLength(_maxLength, message: 'El nombre es muy largo')
        .matchesPattern(
          _safeTextPattern,
          message: 'El nombre contiene caracteres inválidos',
        );
  }
}
