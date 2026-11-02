import 'package:lucid_validation/lucid_validation.dart';

import '../../../domain/dtos/in/user_amount_dto.dart';

class UserAmountValidateSchema extends LucidValidator<UserAmountDto> {
  static const int _minAmount = 0;

  UserAmountValidateSchema() {
    ruleFor(
      (dto) => dto.userId.value,
      key: 'userId',
    ).notEmpty(message: 'Parámetro inválido');

    ruleFor(
      (dto) => dto.amount,
      key: 'amount',
    ).greaterThan(_minAmount, message: 'La cantidad debe ser positiva');
  }
}
