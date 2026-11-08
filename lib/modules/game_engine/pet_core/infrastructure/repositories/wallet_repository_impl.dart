import '../../../../../core/domain/types/app_uuid.dart';
import '../../domain/datasources/wallet_datasource.dart';
import '../../domain/dtos/in/user_amount_dto.dart';
import '../../domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletDatasource _walletDatasource;

  WalletRepositoryImpl({required this._walletDatasource});

  @override
  Future<int> addCoins(UserAmountDto dto) {
    return _walletDatasource.addCoins(dto);
  }

  @override
  Future<int> deductCoins(UserAmountDto dto) {
    return _walletDatasource.deductCoins(dto);
  }

  @override
  Future<int> getCoins(AppUuid userId) {
    return _walletDatasource.getCoins(userId);
  }
}
