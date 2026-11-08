import '../../../../core/infrastructure/database/interfaces/local_db_client.dart';
import '../../domain/datasources/query_user_datasource.dart';
import '../../domain/dtos/in/looking_user_exist_dto.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/mappers/user_mapper.dart';

class QueryUserLocalDatasource implements QueryUserDatasource {
  final LocalDbClient _dbClient;
  final UserMapper _userMapper;
  final _userNameTable = 'User';

  QueryUserLocalDatasource({
    required this._dbClient,
    required this._userMapper,
  });

  @override
  Future<User> queryUser(String userId) async {
    final queryUser = await _dbClient.query(
      _userNameTable,
      conditions: (where: 'id = ?', whereArgs: [userId]),
    );

    return _userMapper.fromDbToEntity(queryUser.first);
  }

  @override
  Future<bool> queryUserIsPremium(String userId) async {
    final queryUser = await _dbClient.query(
      _userNameTable,
      conditions: (where: 'id = ?', whereArgs: [userId]),
    );

    final userFound = _userMapper.fromDbToEntity(queryUser.first);

    return userFound.isPremium;
  }

  @override
  Future<int> queryUserVirtualCoins(String userId) async {
    final queryUser = await _dbClient.query(
      _userNameTable,
      conditions: (where: 'id = ?', whereArgs: [userId]),
    );

    final userFound = _userMapper.fromDbToEntity(queryUser.first);

    return userFound.virtualCoins;
  }

  @override
  Future<User?> lookingForUserExist(LookingUserDto dto) async {
    final String name = dto.name;
    final queryUser = await _dbClient.query(
      _userNameTable,
      conditions: (where: 'name = ?', whereArgs: [name]),
    );

    return queryUser.isEmpty
        ? null
        : _userMapper.fromDbToEntity(queryUser.first);
  }

  @override
  Future<User?> userAlreadyHaveAnAccount() async {
    final queryUser = await _dbClient.query(_userNameTable, limit: 1);

    return queryUser.isEmpty
        ? null
        : _userMapper.fromDbToEntity(queryUser.first);
  }
}
