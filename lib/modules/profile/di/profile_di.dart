import '../../../core/di/injection_container.dart';
import '../../../core/infrastructure/adapters/validator_adapter.dart';
import '../../../core/infrastructure/database/interfaces/local_db_client.dart';

import '../../game_engine/game_engine_module.dart';
import '../application/use_cases/create_user_use_case.dart';
import '../application/use_cases/get_user_already_have_an_account_use_case.dart';
import '../application/validators/schemas/looking_user_schema.dart';
import '../application/validators/schemas/user_schema.dart';

import '../domain/dtos/in/create_user_dto.dart';
import '../domain/dtos/in/looking_user_exist_dto.dart';

import '../infrastructure/datasources/mutation_local_datasource.dart';
import '../infrastructure/datasources/query_local_datasource.dart';
import '../infrastructure/mappers/user_mapper.dart';
import '../infrastructure/repositories/mutation_repository.dart';
import '../infrastructure/repositories/query_repository.dart';
import '../presentation/controllers/profile_controller.dart';

void initProfileDi() {
  //* DB
  late final dbClient = sl.get<LocalDbClient>();

  //* Schemas
  late final createUserValidateSchema = CreateUserValidateSchema();
  late final userExistValidateShcema = LookingUserValidateSchema();

  //* Validators
  late final userValidator = ValidatorAdapter<CreateUserDto>(
    createUserValidateSchema,
  );
  late final userExistValidator = ValidatorAdapter<LookingUserDto>(
    userExistValidateShcema,
  );

  //* Mappers
  late final userMapper = UserMapperImpl();

  //* Datasources
  late final queryUserDatasource = QueryUserLocalDatasource(
    dbClient: dbClient,
    userMapper: userMapper,
  );
  late final mutationDatasource = MutationUserLocalDatasource(
    dbClient: dbClient,
    mapperUser: userMapper,
  );

  //* Repositories
  late final queryUserRepository = QueryUserRepositoryImpl(
    queryDatasource: queryUserDatasource,
  );
  late final mutationRepository = MutationUserRepositoryImpl(
    mutationDatasource: mutationDatasource,
  );

  //* Use Cases
  late final getUserAlreadyHaveAnAccount = GetUserAlreadyHaveAnAccountUseCase(
    queryUser: queryUserRepository,
  );
  late final createUser = CreateUserUseCase(
    mutationUserRepository: mutationRepository,
    queryUserRepository: queryUserRepository,
    userValidator: userValidator,
    userExistValidator: userExistValidator,
  );

  //* Actions
  sl.registerLazySingleton<ExecuteGetUserAlreadyHaveAnAccountUseCase>(
    () => getUserAlreadyHaveAnAccount.execute,
  );
  sl.registerLazySingleton<ExecuteCreateUserUseCase>(() => createUser.execute);

  //* Controllers
  sl.registerFactory<ProfileController>(
    () => ProfileController(
      getUserAction: sl<ExecuteGetUserAlreadyHaveAnAccountUseCase>(),
      createUserAction: sl<ExecuteCreateUserUseCase>(),
      ensureUserPetAction: sl<ExecuteEnsureUserPetUseCase>(),
      getDailyMissionAction: sl<ExecuteGetDailyMissionUseCase>(),
    ),
  );
}
