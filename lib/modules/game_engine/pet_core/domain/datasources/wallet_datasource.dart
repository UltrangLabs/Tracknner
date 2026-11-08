import '../../../../../core/domain/types/app_uuid.dart';
import '../dtos/in/user_amount_dto.dart';

abstract class WalletDatasource {
  Future<int> addCoins(UserAmountDto dto);
  Future<int> deductCoins(UserAmountDto dto);
  Future<int> getCoins(AppUuid userId);
}
