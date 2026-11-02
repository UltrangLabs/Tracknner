import '../../../../../core/domain/errors/custom_error.dart';
import '../../../../../core/domain/use_cases/interfaces/structure_use_case.dart';
import '../../domain/dtos/in/user_amount_dto.dart';
import '../../domain/repositories/wallet_repository.dart';

typedef ExecuteAddCoinsUseCase = Future<int> Function(UserAmountDto dto);

class AddCoinsUseCase implements UseCaseStructure<int, UserAmountDto> {
  final WalletRepository _walletRepository;

  AddCoinsUseCase({required this._walletRepository});

  @override
  Future<int> execute(UserAmountDto dto) async {
    if (dto.amount <= 0) {
      throw CustomError.badRequest(
        payload: [(message: 'Amount must be positive', path: 'amount')],
        path: 'modules.game_engine.pet_core.add_coins',
      );
    }

    final balance = await _walletRepository.getCoins(dto.userId);
    final newBalance = balance + dto.amount;

    await _walletRepository.saveCoins(userId: dto.userId, coins: newBalance);

    return newBalance;
  }
}
