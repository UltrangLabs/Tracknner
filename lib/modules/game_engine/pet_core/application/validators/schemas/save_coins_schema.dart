import 'package:lucid_validation/lucid_validation.dart';

import '../../../domain/dtos/in/save_coins_dto.dart';

class SaveCoinsValidateSchema extends LucidValidator<SaveCoinsDto> {
  static const int _minCoins = 0;

  SaveCoinsValidateSchema() {
    ruleFor(
      (dto) => dto.userId.value,
      key: 'userId',
    ).notEmpty(message: 'Parámetro inválido');

    ruleFor(
      (dto) => dto.coins,
      key: 'coins',
    ).min(_minCoins, message: 'El saldo no puede ser negativo');
  }
}
