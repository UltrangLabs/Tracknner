import '../../../../../core/domain/errors/custom_error.dart';
import '../../../../../core/domain/types/app_uuid.dart';
import '../../../../../core/infrastructure/database/interfaces/local_db_client.dart';
import '../../domain/datasources/wallet_datasource.dart';
import '../../domain/dtos/in/save_coins_dto.dart';

class WalletLocalDatasource implements WalletDatasource {
  static const String _tableName = 'User';
  static const String _errorPath =
      'modules.game_engine.pet_core.wallet_local_datasource';

  final LocalDbClient _dbClient;

  WalletLocalDatasource({required this._dbClient});

  @override
  Future<int> getCoins(AppUuid userId) async {
    final rows = await _dbClient.query(
      _tableName,
      columns: ['virtualCoins'],
      conditions: (where: 'userId = ?', whereArgs: [userId.value]),
      limit: 1,
    );

    if (rows.isEmpty) {
      throw CustomError.notFound(message: 'User not found', path: _errorPath);
    }

    return rows.first['virtualCoins'] as int;
  }

  @override
  Future<void> saveCoins(SaveCoinsDto dto) async {
    final updatedRows = await _dbClient.update(
      _tableName,
      {'virtualCoins': dto.coins},
      conditions: (where: 'userId = ?', whereArgs: [dto.userId.value]),
    );

    if (updatedRows == 0) {
      throw CustomError.notFound(message: 'User not found', path: _errorPath);
    }
  }
}
