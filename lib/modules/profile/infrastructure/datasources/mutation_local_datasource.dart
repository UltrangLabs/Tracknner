import '../../../../core/domain/errors/custom_error.dart';
import '../../../../core/infrastructure/database/interfaces/local_db_client.dart';
import '../../domain/datasources/mutation_user_datarource.dart';
import '../../domain/dtos/in/create_user_dto.dart';
import '../../domain/mappers/user_mapper.dart';

class MutationUserLocalDatasource implements MutationUserDatarource {
  final LocalDbClient _dbClient;
  final UserMapper _mapperUser;
  final String _userTableName = 'User';

  MutationUserLocalDatasource({
    required this._dbClient,
    required this._mapperUser,
  });

  @override
  Future<void> createUser({required CreateUserDto dto}) async {
    final DbValues valuesToInsert = _mapperUser.fromCreateDtoToDb(dto);
    final int insertedId = await _dbClient.insert(
      _userTableName,
      valuesToInsert,
    );

    if (insertedId == 0) {
      throw CustomError.internalServer(message: "Error al crear el usuario");
    }
  }
}
