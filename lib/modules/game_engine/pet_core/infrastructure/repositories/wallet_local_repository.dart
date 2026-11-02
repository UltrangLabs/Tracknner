import '../../../../../core/domain/errors/custom_error.dart';
import '../../../../../core/domain/types/app_uuid.dart';
import '../../../../../core/infrastructure/database/interfaces/local_db_client.dart';
import '../../domain/repositories/wallet_repository.dart';

class WalletLocalRepository implements WalletRepository {
  static const String _tableName = 'User';
  static const String _errorPath =
      'modules.game_engine.pet_core.wallet_local_repository';

  final LocalDbClient _dbClient;

  WalletLocalRepository({required this._dbClient});

  @override
  Future<int> getCoins(AppUuid userId) async {
    final rows = await _dbClient.query(
      _tableName,
      columns: ['virtualCoins'],
      conditions: (where: 'userId = ?', whereArgs: [userId.value]),
    );

    if (rows.isEmpty) {
      throw CustomError.notFound(message: 'User not found', path: _errorPath);
    }

    return rows.first['virtualCoins'] as int;
  }

  @override
  Future<void> saveCoins({required AppUuid userId, required int coins}) async {
    final updatedRows = await _dbClient.update(
      _tableName,
      {'virtualCoins': coins},
      conditions: (where: 'userId = ?', whereArgs: [userId.value]),
    );

    if (updatedRows == 0) {
      throw CustomError.notFound(message: 'User not found', path: _errorPath);
    }
  }
}
