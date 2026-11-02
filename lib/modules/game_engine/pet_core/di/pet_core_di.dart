import '../../../../core/di/injection_container.dart';
import '../../../../core/infrastructure/adapters/validator_adapter.dart';
import '../../../../core/infrastructure/database/interfaces/local_db_client.dart';
import '../application/use_cases/add_coins_use_case.dart';
import '../application/use_cases/add_experience_use_case.dart';
import '../application/use_cases/deduct_coins_use_case.dart';
import '../application/use_cases/ensure_user_pet_use_case.dart';
import '../application/validators/schemas/ensure_user_pet_schema.dart';
import '../application/validators/schemas/save_coins_schema.dart';
import '../application/validators/schemas/save_pet_progress_schema.dart';
import '../application/validators/schemas/user_amount_schema.dart';
import '../domain/dtos/in/ensure_user_pet_dto.dart';
import '../domain/dtos/in/save_coins_dto.dart';
import '../domain/dtos/in/save_pet_progress_dto.dart';
import '../domain/dtos/in/user_amount_dto.dart';
import '../infrastructure/datasources/pet_local_datasource.dart';
import '../infrastructure/datasources/wallet_local_datasource.dart';
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
  late final saveCoinsValidateSchema = SaveCoinsValidateSchema();
  late final savePetProgressValidateSchema = SavePetProgressValidateSchema();

  //* Validators
  late final ensureUserPetValidator = ValidatorAdapter<EnsureUserPetDto>(
    ensureUserPetValidateSchema,
  );
  late final userAmountValidator = ValidatorAdapter<UserAmountDto>(
    userAmountValidateSchema,
  );
  late final saveCoinsValidator = ValidatorAdapter<SaveCoinsDto>(
    saveCoinsValidateSchema,
  );
  late final savePetProgressValidator = ValidatorAdapter<SavePetProgressDto>(
    savePetProgressValidateSchema,
  );

  //* Datasources
  late final walletDatasource = WalletLocalDatasource(dbClient: dbClient);
  late final petDatasource = PetLocalDatasource(dbClient: dbClient);

  //* Repositories
  late final walletRepository = WalletRepositoryImpl(
    walletDatasource: walletDatasource,
  );
  late final petRepository = PetRepositoryImpl(petDatasource: petDatasource);

  //* Use Cases
  late final addCoins = AddCoinsUseCase(
    walletRepository: walletRepository,
    userAmountValidator: userAmountValidator,
    saveCoinsValidator: saveCoinsValidator,
  );
  late final deductCoins = DeductCoinsUseCase(
    walletRepository: walletRepository,
    userAmountValidator: userAmountValidator,
    saveCoinsValidator: saveCoinsValidator,
  );
  late final addExperience = AddExperienceUseCase(
    petRepository: petRepository,
    userAmountValidator: userAmountValidator,
    savePetProgressValidator: savePetProgressValidator,
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
