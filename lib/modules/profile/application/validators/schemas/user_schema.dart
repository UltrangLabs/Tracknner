import 'package:lucid_validation/lucid_validation.dart';

import '../../../domain/dtos/in/create_user_dto.dart';

class CreateUserValidateSchema extends LucidValidator<CreateUserDto> {
  static const int _minLength = 3;
  static const int _maxLength = 50;
  static const String _safeTextPattern =
      r'^[a-zA-Z0-9\s\-_.,!¡?¿@ñÑáéíóúÁÉÍÓÚ]+$';

  CreateUserValidateSchema() {
    ruleFor((dto) => dto.name, key: 'name')
        .notEmpty(message: 'El nombre es requerido')
        .minLength(_minLength, message: 'El nombre es muy corto')
        .maxLength(_maxLength, message: 'El nombre es muy largo')
        .matchesPattern(
          _safeTextPattern,
          message: 'El nombre contiene caracteres inválidos',
        );
  }
}
