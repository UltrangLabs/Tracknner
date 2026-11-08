import '../../../../core/domain/errors/custom_error.dart';
import '../../../../core/domain/types/app_uuid.dart';
import '../../../../core/domain/types/unknown_type.dart';
import '../../../../core/infrastructure/adapters/uuid_adapter.dart';
import '../../domain/constants/base_user_values.dart';
import '../../domain/dtos/in/create_user_dto.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/mappers/user_mapper.dart';

class UserMapperImpl implements UserMapper {
  final GenerateUuIdV4 _generateUuIdV4;

  UserMapperImpl({this._generateUuIdV4 = generateUuidV4});

  @override
  User fromDbToEntity(Unknown dbData) {
    if (dbData.isEmpty) {
      throw CustomError.badRequest(
        payload: [(message: "The data is Empty", path: "User mapper")],
        path: 'mapper',
      );
    }

    return User(
      id: AppUuid(dbData['userId'] as String),
      name: dbData['name'] as String,
      virtualCoins: dbData['virtualCoins'] as int,
      currentStreak: dbData['currentStreak'] as int,
      highestStreak: dbData['highestStreak'] as int,
      isPremium: (dbData['isPremium'] as int) == 1,
    );
  }

  @override
  Unknown fromEntityToDb(User user) {
    return {
      'userId': user.id.value,
      'name': user.name,
      'virtualCoins': user.virtualCoins,
      'currentStreak': user.currentStreak,
      'highestStreak': user.highestStreak,
      'isPremium': user.isPremium ? 1 : 0,
    };
  }

  @override
  Unknown fromCreateDtoToDb(CreateUserDto dto) {
    return {
      'userId': _generateUuIdV4().value,
      'name': dto.name,
      'virtualCoins': kDefaultUserValues.virtualCoins,
      'currentStreak': kDefaultUserValues.currentStreak,
      'highestStreak': kDefaultUserValues.highestStreak,
      'isPremium': kDefaultUserValues.isPremium ? 1 : 0,
    };
  }
}
