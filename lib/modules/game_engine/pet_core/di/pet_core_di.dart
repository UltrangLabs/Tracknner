import '../../../../core/di/injection_container.dart';
import '../../../../core/infrastructure/adapters/validator_adapter.dart';
import '../../../../core/infrastructure/database/interfaces/local_db_client.dart';
import '../application/use_cases/add_coins_use_case.dart';
import '../application/use_cases/add_experience_use_case.dart';
import '../application/use_cases/deduct_coins_use_case.dart';
import '../application/use_cases/ensure_user_pet_use_case.dart';
import '../application/validators/schemas/ensure_user_pet_schema.dart';
import '../application/validators/schemas/user_amount_schema.dart';
import '../domain/dtos/in/ensure_user_pet_dto.dart';
import '../domain/dtos/in/user_amount_dto.dart';
import '../infrastructure/datasources/pet_local_datasource.dart';
import '../infrastructure/datasources/wallet_local_datasource.dart';
import '../infrastructure/mappers/pet_mapper.dart';
import '../infrastructure/repositories/pet_repository_impl.dart';
import '../infrastructure/repositories/wallet_repository_impl.dart';

// Sumar y restar monedas comparten firma (Future<int> Function(Unknown)), por
// lo que GetIt los distingue mediante instanceName.
const String addCoinsActionName = 'addCoinsAction';
const String deductCoinsActionName = 'deductCoinsAction';

void initPetCoreDi() {
  //* DB
  late final dbClient = sl.get<LocalDbClient>();

  //* Schemas
  late final ensureUserPetValidateSchema = EnsureUserPetValidateSchema();
  late final userAmountValidateSchema = UserAmountValidateSchema();

  //* Validators
  late final ensureUserPetValidator = ValidatorAdapter<EnsureUserPetDto>(
    ensureUserPetValidateSchema,
  );
  late final userAmountValidator = ValidatorAdapter<UserAmountDto>(
    userAmountValidateSchema,
  );

  //* Mappers
  late final petMapper = PetMapperImpl();

  //* Datasources
  late final walletDatasource = WalletLocalDatasource(dbClient: dbClient);
  late final petDatasource = PetLocalDatasource(
    dbClient: dbClient,
    petMapper: petMapper,
  );

  //* Repositories
  late final walletRepository = WalletRepositoryImpl(
    walletDatasource: walletDatasource,
  );
  late final petRepository = PetRepositoryImpl(petDatasource: petDatasource);

  //* Use Cases
  late final addCoins = AddCoinsUseCase(
    walletRepository: walletRepository,
    userAmountValidator: userAmountValidator,
  );
  late final deductCoins = DeductCoinsUseCase(
    walletRepository: walletRepository,
    userAmountValidator: userAmountValidator,
  );
  late final addExperience = AddExperienceUseCase(
    petRepository: petRepository,
    userAmountValidator: userAmountValidator,
  );
  late final ensureUserPet = EnsureUserPetUseCase(
    petRepository: petRepository,
    ensureUserPetValidator: ensureUserPetValidator,
  );

  //* Actions
  sl.registerLazySingleton<ExecuteAddCoinsUseCase>(
    () => addCoins.execute,
    instanceName: addCoinsActionName,
  );
  sl.registerLazySingleton<ExecuteDeductCoinsUseCase>(
    () => deductCoins.execute,
    instanceName: deductCoinsActionName,
  );
  sl.registerLazySingleton<ExecuteAddExperienceUseCase>(
    () => addExperience.execute,
  );
  sl.registerLazySingleton<ExecuteEnsureUserPetUseCase>(
    () => ensureUserPet.execute,
  );
}
