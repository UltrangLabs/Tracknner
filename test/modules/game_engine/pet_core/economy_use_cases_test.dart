import 'package:flutter_test/flutter_test.dart';
import 'package:running/core/domain/errors/custom_error.dart';
import 'package:running/core/domain/types/app_uuid.dart';
import 'package:running/core/infrastructure/adapters/validator_adapter.dart';
import 'package:running/core/infrastructure/database/models/pet_model.dart';
import 'package:running/core/infrastructure/database/models/user_model.dart';
import 'package:running/modules/game_engine/game_engine_module.dart';
import 'package:running/modules/game_engine/pet_core/application/validators/schemas/ensure_user_pet_schema.dart';
import 'package:running/modules/game_engine/pet_core/application/validators/schemas/save_coins_schema.dart';
import 'package:running/modules/game_engine/pet_core/application/validators/schemas/save_pet_progress_schema.dart';
import 'package:running/modules/game_engine/pet_core/application/validators/schemas/user_amount_schema.dart';
import 'package:running/modules/game_engine/pet_core/domain/repositories/pet_repository.dart';
import 'package:running/modules/game_engine/pet_core/domain/repositories/wallet_repository.dart';
import 'package:running/modules/game_engine/pet_core/infrastructure/datasources/pet_local_datasource.dart';
import 'package:running/modules/game_engine/pet_core/infrastructure/datasources/wallet_local_datasource.dart';
import 'package:running/modules/game_engine/pet_core/infrastructure/repositories/pet_repository_impl.dart';
import 'package:running/modules/game_engine/pet_core/infrastructure/repositories/wallet_repository_impl.dart';
import 'package:sqflite_common_ffi/sqflite_common_ffi.dart';

import '../../../helpers/sqlite_db_client.dart';

void main() {
  final userId = AppUuid('user-1');
  final ensureUserPetValidator = ValidatorAdapter<EnsureUserPetDto>(
    EnsureUserPetValidateSchema(),
  );
  final userAmountValidator = ValidatorAdapter<UserAmountDto>(
    UserAmountValidateSchema(),
  );
  final saveCoinsValidator = ValidatorAdapter<SaveCoinsDto>(
    SaveCoinsValidateSchema(),
  );
  final savePetProgressValidator = ValidatorAdapter<SavePetProgressDto>(
    SavePetProgressValidateSchema(),
  );
  late Database db;
  late WalletRepository walletRepository;
  late PetRepository petRepository;
  late AddCoinsUseCase addCoins;
  late DeductCoinsUseCase deductCoins;
  late AddExperienceUseCase addExperience;
  late EnsureUserPetUseCase ensureUserPet;

  setUpAll(sqfliteFfiInit);

  setUp(() async {
    db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await db.execute(UserModel().createTableQuery);
    await db.execute(PetModel().createTableQuery);
    await db.insert('User', {
      'userId': userId.value,
      'name': 'Alex',
      'virtualCoins': 50,
    });

    final client = SqliteDbClient(db);
    walletRepository = WalletRepositoryImpl(
      walletDatasource: WalletLocalDatasource(dbClient: client),
    );
    petRepository = PetRepositoryImpl(
      petDatasource: PetLocalDatasource(dbClient: client),
    );

    addCoins = AddCoinsUseCase(
      walletRepository: walletRepository,
      userAmountValidator: userAmountValidator,
      saveCoinsValidator: saveCoinsValidator,
    );
    deductCoins = DeductCoinsUseCase(
      walletRepository: walletRepository,
      userAmountValidator: userAmountValidator,
      saveCoinsValidator: saveCoinsValidator,
    );
    addExperience = AddExperienceUseCase(
      petRepository: petRepository,
      userAmountValidator: userAmountValidator,
      savePetProgressValidator: savePetProgressValidator,
    );
    ensureUserPet = EnsureUserPetUseCase(
      petRepository: petRepository,
      ensureUserPetValidator: ensureUserPetValidator,
    );
  });

  tearDown(() => db.close());

  group('wallet', () {
    test('adds coins and persists the balance', () async {
      final balance = await addCoins.execute({
        'userId': userId.value,
        'amount': 25,
      });

      expect(balance, 75);
      expect(await walletRepository.getCoins(userId), 75);
    });

    test('deducts coins up to the exact balance', () async {
      final balance = await deductCoins.execute({
        'userId': userId.value,
        'amount': 50,
      });

      expect(balance, 0);
    });

    test('denies deduction above balance and keeps the coins', () async {
      await expectLater(
        deductCoins.execute({'userId': userId.value, 'amount': 51}),
        throwsA(isA<CustomError>()),
      );
      expect(await walletRepository.getCoins(userId), 50);
    });

    test('rejects non positive amounts', () async {
      await expectLater(
        addCoins.execute({'userId': userId.value, 'amount': 0}),
        throwsA(isA<CustomError>()),
      );
    });

    test('rejects a missing user id', () async {
      await expectLater(
        addCoins.execute({'amount': 10}),
        throwsA(isA<CustomError>()),
      );
    });

    test('fails when the user does not exist', () async {
      await expectLater(
        walletRepository.getCoins(AppUuid('missing')),
        throwsA(isA<CustomError>()),
      );
    });
  });

  group('applyExperience', () {
    test('keeps level below the threshold', () {
      final progress = applyExperience(
        level: 1,
        experience: 0,
        gainedExperience: 99,
      );

      expect(progress, (level: 1, experience: 99));
    });

    test('levels up and keeps the remainder', () {
      final progress = applyExperience(
        level: 1,
        experience: 80,
        gainedExperience: 50,
      );

      expect(progress, (level: 2, experience: 30));
    });

    test('crosses several levels with a big gain', () {
      final progress = applyExperience(
        level: 1,
        experience: 0,
        gainedExperience: 350,
      );

      expect(progress, (level: 3, experience: 50));
    });
  });

  group('pet', () {
    const petData = (name: 'Max', breed: 'Golden', image: 'golden.jpg');

    Map<String, Object?> buildRawData(String name) => {
      'userId': userId.value,
      'name': name,
      'breed': petData.breed,
      'imageAssetName': petData.image,
    };

    test('creates the pet once and then returns the same one', () async {
      final created = await ensureUserPet.execute(buildRawData(petData.name));
      final again = await ensureUserPet.execute(buildRawData('Otro'));

      expect(created.level, 1);
      expect(again.id, created.id);
      expect(again.name, petData.name);
    });

    test('rejects an invalid pet payload', () async {
      await expectLater(
        ensureUserPet.execute({'userId': userId.value, 'name': ''}),
        throwsA(isA<CustomError>()),
      );
    });

    test('persists experience and level', () async {
      await ensureUserPet.execute(buildRawData(petData.name));

      await addExperience.execute({'userId': userId.value, 'amount': 130});

      final pet = await petRepository.findByUser(userId);
      expect(pet?.level, 2);
      expect(pet?.experience, 30);
    });

    test('fails adding experience without a pet', () async {
      await expectLater(
        addExperience.execute({'userId': userId.value, 'amount': 10}),
        throwsA(isA<CustomError>()),
      );
    });
  });
}
