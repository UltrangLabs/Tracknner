import '../../../../../../core/domain/types/app_uuid.dart';
import '../../../../../../core/domain/types/unknown_type.dart';
import '../../../../../../core/infrastructure/adapters/validator_adapter.dart';
import '../../../domain/dtos/in/user_amount_dto.dart';

typedef ValidatorUserAmountDto = ValidatorAdapter<UserAmountDto>;

class UserAmountDtoImpl implements UserAmountDto {
  @override
  final AppUuid userId;
  @override
  final int amount;

  const UserAmountDtoImpl._({required this.userId, required this.amount});

  static UserAmountDto create({
    required Unknown rawData,
    required ValidatorUserAmountDto validator,
  }) {
    final unvalidatedDto = _mapFromRaw(rawData);
    final validatedDto = validator.validate(unvalidatedDto);

    return validatedDto;
  }

  static UserAmountDto _mapFromRaw(Unknown rawData) {
    return UserAmountDtoImpl._(
      userId: AppUuid(rawData['userId']?.toString() ?? ""),
      amount: int.tryParse(rawData['amount']?.toString() ?? "") ?? 0,
    );
  }
}
