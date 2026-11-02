import '../../../../../../core/domain/types/app_uuid.dart';
import '../../../../../../core/domain/types/unknown_type.dart';
import '../../../../../../core/infrastructure/adapters/validator_adapter.dart';
import '../../../domain/dtos/in/save_coins_dto.dart';

typedef ValidatorSaveCoinsDto = ValidatorAdapter<SaveCoinsDto>;

class SaveCoinsDtoImpl implements SaveCoinsDto {
  @override
  final AppUuid userId;
  @override
  final int coins;

  const SaveCoinsDtoImpl._({required this.userId, required this.coins});

  static SaveCoinsDto create({
    required Unknown rawData,
    required ValidatorSaveCoinsDto validator,
  }) {
    final unvalidatedDto = _mapFromRaw(rawData);
    final validatedDto = validator.validate(unvalidatedDto);

    return validatedDto;
  }

  static SaveCoinsDto _mapFromRaw(Unknown rawData) {
    return SaveCoinsDtoImpl._(
      userId: AppUuid(rawData['userId']?.toString() ?? ""),
      coins: int.tryParse(rawData['coins']?.toString() ?? "") ?? -1,
    );
  }
}
