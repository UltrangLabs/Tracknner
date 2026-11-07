import '../../../../../core/domain/errors/custom_error.dart';
import '../../../../../core/domain/types/app_uuid.dart';
import '../../../../../core/infrastructure/database/interfaces/local_db_client.dart';
import '../../domain/datasources/wallet_datasource.dart';
import '../../domain/dtos/in/user_amount_dto.dart';

class WalletLocalDatasource implements WalletDatasource {
  static const String _tableName = 'User';
  static const String _errorPath =
      'modules.game_engine.pet_core.wallet_local_datasource';

  final LocalDbClient _dbClient;

  WalletLocalDatasource({required this._dbClient});

  @override
  Future<int> addCoins(UserAmountDto dto) async {
    final balance = await getCoins(dto.userId);
    final newBalance = balance + dto.amount;

    await _updateCoins(userId: dto.userId, coins: newBalance);

    return newBalance;
  }

  @override
  Future<int> deductCoins(UserAmountDto dto) async {
    final balance = await getCoins(dto.userId);

    _validateSufficientBalance(balance: balance, amount: dto.amount);

    final newBalance = balance - dto.amount;

    await _updateCoins(userId: dto.userId, coins: newBalance);

    return newBalance;
  }

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

  void _validateSufficientBalance({required int balance, required int amount}) {
    if (amount > balance) {
      throw CustomError.conflict(
        message: 'Fondos insuficientes',
        path: _errorPath,
      );
    }
  }

  Future<void> _updateCoins({
    required AppUuid userId,
    required int coins,
  }) async {
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
