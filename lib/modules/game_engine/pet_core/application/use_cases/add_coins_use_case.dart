import '../../../../../core/domain/types/unknown_type.dart';
import '../../../../../core/domain/use_cases/interfaces/structure_use_case.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../dtos/in/save_coins_dto.dart';
import '../dtos/in/user_amount_dto.dart';

typedef ExecuteAddCoinsUseCase = Future<int> Function(Unknown rawData);

class AddCoinsUseCase implements UseCaseStructure<int, Unknown> {
  final WalletRepository _walletRepository;
  final ValidatorUserAmountDto _userAmountValidator;
  final ValidatorSaveCoinsDto _saveCoinsValidator;

  AddCoinsUseCase({
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
    final newBalance = balance + userAmountDto.amount;

    final saveCoinsDto = SaveCoinsDtoImpl.create(
      rawData: {'userId': userAmountDto.userId.value, 'coins': newBalance},
      validator: _saveCoinsValidator,
    );

    await _walletRepository.saveCoins(saveCoinsDto);

    return newBalance;
  }
}
