import '../../../../../../core/domain/types/app_uuid.dart';

class UserAmountDto {
  final AppUuid userId;
  final int amount;

  const UserAmountDto({required this.userId, required this.amount});
}

// GetIt registra por tipo: sin esta clase, sumar y restar monedas tendrían la
// misma firma y chocarían al registrarse.
class DeductCoinsDto extends UserAmountDto {
  const DeductCoinsDto({required super.userId, required super.amount});
}
