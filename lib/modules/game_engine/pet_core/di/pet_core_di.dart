import '../../../../core/di/injection_container.dart';
import '../../../../core/infrastructure/database/interfaces/local_db_client.dart';
import '../application/use_cases/add_coins_use_case.dart';
import '../application/use_cases/add_experience_use_case.dart';
import '../application/use_cases/deduct_coins_use_case.dart';
import '../application/use_cases/ensure_user_pet_use_case.dart';
import '../infrastructure/repositories/pet_local_repository.dart';
import '../infrastructure/repositories/wallet_local_repository.dart';

void initPetCoreDi() {
  //* DB
  late final dbClient = sl.get<LocalDbClient>();

  //* Repositories
  late final walletRepository = WalletLocalRepository(dbClient: dbClient);
  late final petRepository = PetLocalRepository(dbClient: dbClient);

  //* Use Cases
  late final addCoins = AddCoinsUseCase(walletRepository: walletRepository);
  late final deductCoins = DeductCoinsUseCase(
    walletRepository: walletRepository,
  );
  late final addExperience = AddExperienceUseCase(petRepository: petRepository);
  late final ensureUserPet = EnsureUserPetUseCase(petRepository: petRepository);

  //* Actions
  sl.registerLazySingleton<ExecuteAddCoinsUseCase>(() => addCoins.execute);
  sl.registerLazySingleton<ExecuteDeductCoinsUseCase>(
    () => deductCoins.execute,
  );
  sl.registerLazySingleton<ExecuteAddExperienceUseCase>(
    () => addExperience.execute,
  );
  sl.registerLazySingleton<ExecuteEnsureUserPetUseCase>(
    () => ensureUserPet.execute,
  );
}
