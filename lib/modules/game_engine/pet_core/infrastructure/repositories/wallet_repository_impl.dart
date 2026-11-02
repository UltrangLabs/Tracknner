import '../../../../../core/domain/types/app_uuid.dart';
import '../../domain/datasources/wallet_datasource.dart';
import '../../domain/dtos/in/save_coins_dto.dart';
import '../../domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletDatasource _walletDatasource;

  WalletRepositoryImpl({required this._walletDatasource});

  @override
  Future<int> getCoins(AppUuid userId) {
    return _walletDatasource.getCoins(userId);
  }

  @override
  Future<void> saveCoins(SaveCoinsDto dto) {
    return _walletDatasource.saveCoins(dto);
  }
}
