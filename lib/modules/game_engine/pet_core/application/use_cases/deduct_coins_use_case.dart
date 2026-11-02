import '../../../../../core/domain/errors/custom_error.dart';
import '../../../../../core/domain/use_cases/interfaces/structure_use_case.dart';
import '../../domain/dtos/in/user_amount_dto.dart';
import '../../domain/repositories/wallet_repository.dart';

typedef ExecuteDeductCoinsUseCase = Future<int> Function(DeductCoinsDto dto);

class DeductCoinsUseCase implements UseCaseStructure<int, DeductCoinsDto> {
  static const String _errorPath = 'modules.game_engine.pet_core.deduct_coins';

  final WalletRepository _walletRepository;

  DeductCoinsUseCase({required this._walletRepository});

  @override
  Future<int> execute(DeductCoinsDto dto) async {
    if (dto.amount <= 0) {
      throw CustomError.badRequest(
        payload: [(message: 'Amount must be positive', path: 'amount')],
        path: _errorPath,
      );
    }

    final balance = await _walletRepository.getCoins(dto.userId);

    if (dto.amount > balance) {
      throw CustomError.conflict(
        message: 'Fondos insuficientes',
        path: _errorPath,
      );
    }

    final newBalance = balance - dto.amount;

    await _walletRepository.saveCoins(userId: dto.userId, coins: newBalance);

    return newBalance;
  }
}
