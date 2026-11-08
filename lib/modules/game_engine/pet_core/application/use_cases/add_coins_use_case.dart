import '../../../../../core/domain/types/unknown_type.dart';
import '../../../../../core/domain/use_cases/interfaces/structure_use_case.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../dtos/in/user_amount_dto.dart';

typedef ExecuteAddCoinsUseCase = Future<int> Function(Unknown rawData);

class AddCoinsUseCase implements UseCaseStructure<int, Unknown> {
  final WalletRepository _walletRepository;
  final ValidatorUserAmountDto _userAmountValidator;

  AddCoinsUseCase({
    required this._walletRepository,
    required this._userAmountValidator,
  });

  @override
  Future<int> execute(Unknown rawData) async {
    final userAmountDto = UserAmountDtoImpl.create(
      rawData: rawData,
      validator: _userAmountValidator,
    );

    return _walletRepository.addCoins(userAmountDto);
  }
}
