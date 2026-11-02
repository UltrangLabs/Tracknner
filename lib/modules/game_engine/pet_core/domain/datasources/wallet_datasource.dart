import '../../../../../core/domain/types/app_uuid.dart';
import '../dtos/in/save_coins_dto.dart';

abstract class WalletDatasource {
  Future<int> getCoins(AppUuid userId);
  Future<void> saveCoins(SaveCoinsDto dto);
}
