import '../../../../../core/domain/types/app_uuid.dart';

abstract class WalletRepository {
  Future<int> getCoins(AppUuid userId);
  Future<void> saveCoins({required AppUuid userId, required int coins});
}
