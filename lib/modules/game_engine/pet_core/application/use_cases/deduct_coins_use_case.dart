import '../../../../../core/domain/errors/custom_error.dart';
import '../../../../../core/domain/types/unknown_type.dart';
import '../../../../../core/domain/use_cases/interfaces/structure_use_case.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../dtos/in/save_coins_dto.dart';
import '../dtos/in/user_amount_dto.dart';

typedef ExecuteDeductCoinsUseCase = Future<int> Function(Unknown rawData);

class DeductCoinsUseCase implements UseCaseStructure<int, Unknown> {
  static const String _errorPath = 'modules.game_engine.pet_core.deduct_coins';

  final WalletRepository _walletRepository;
  final ValidatorUserAmountDto _userAmountValidator;
  final ValidatorSaveCoinsDto _saveCoinsValidator;

  DeductCoinsUseCase({
    required this._walletRepository,
    required this._userAmountValidator,
    required this._saveCoinsValidator,
  });

  @override
  Future<int> execute(Unknown rawData) async {
    final userAmountDto = UserAmountDtoImpl.create(
      rawData: rawData,
      validator: _userAmountValidator,
    );

    final balance = await _walletRepository.getCoins(userAmountDto.userId);

    if (userAmountDto.amount > balance) {
      throw CustomError.conflict(
        message: 'Fondos insuficientes',
        path: _errorPath,
      );
    }

    final newBalance = balance - userAmountDto.amount;

    final saveCoinsDto = SaveCoinsDtoImpl.create(
      rawData: {'userId': userAmountDto.userId.value, 'coins': newBalance},
      validator: _saveCoinsValidator,
    );

    await _walletRepository.saveCoins(saveCoinsDto);

    return newBalance;
  }
}
