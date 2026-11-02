import 'package:flutter_test/flutter_test.dart';
import 'package:running/core/domain/errors/custom_error.dart';
import 'package:running/core/domain/types/app_uuid.dart';
import 'package:running/core/infrastructure/database/models/pet_model.dart';
import 'package:running/core/infrastructure/database/models/user_model.dart';
import 'package:running/modules/game_engine/game_engine_module.dart';
import 'package:running/modules/game_engine/pet_core/infrastructure/repositories/pet_local_repository.dart';
import 'package:running/modules/game_engine/pet_core/infrastructure/repositories/wallet_local_repository.dart';
import 'package:sqflite_common_ffi/sqflite_common_ffi.dart';

import '../../../helpers/sqlite_db_client.dart';

void main() {
  final userId = AppUuid('user-1');
  late Database db;
  late WalletLocalRepository walletRepository;
  late PetLocalRepository petRepository;

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
    walletRepository = WalletLocalRepository(dbClient: client);
    petRepository = PetLocalRepository(dbClient: client);
  });

  tearDown(() => db.close());

  group('wallet', () {
    test('adds coins and persists the balance', () async {
      final useCase = AddCoinsUseCase(walletRepository: walletRepository);

      final balance = await useCase.execute(
        UserAmountDto(userId: userId, amount: 25),
      );

      expect(balance, 75);
      expect(await walletRepository.getCoins(userId), 75);
    });

    test('deducts coins up to the exact balance', () async {
      final useCase = DeductCoinsUseCase(walletRepository: walletRepository);

      final balance = await useCase.execute(
        DeductCoinsDto(userId: userId, amount: 50),
      );

      expect(balance, 0);
    });

    test('denies deduction above balance and keeps the coins', () async {
      final useCase = DeductCoinsUseCase(walletRepository: walletRepository);

      await expectLater(
        useCase.execute(DeductCoinsDto(userId: userId, amount: 51)),
        throwsA(isA<CustomError>()),
      );
      expect(await walletRepository.getCoins(userId), 50);
    });

    test('rejects non positive amounts', () async {
      final useCase = AddCoinsUseCase(walletRepository: walletRepository);

      await expectLater(
        useCase.execute(UserAmountDto(userId: userId, amount: 0)),
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

    EnsureUserPetDto buildDto(String name) => EnsureUserPetDto(
      userId: userId,
      name: name,
      breed: petData.breed,
      imageAssetName: petData.image,
    );

    test('creates the pet once and then returns the same one', () async {
      final useCase = EnsureUserPetUseCase(petRepository: petRepository);

      final created = await useCase.execute(buildDto(petData.name));
      final again = await useCase.execute(buildDto('Otro'));

      expect(created.level, 1);
      expect(again.id, created.id);
      expect(again.name, petData.name);
    });

    test('persists experience and level', () async {
      await EnsureUserPetUseCase(petRepository: petRepository)
          .execute(buildDto(petData.name));
      final useCase = AddExperienceUseCase(petRepository: petRepository);

      await useCase.execute(UserAmountDto(userId: userId, amount: 130));

      final pet = await petRepository.findByUser(userId);
      expect(pet?.level, 2);
      expect(pet?.experience, 30);
    });

    test('fails adding experience without a pet', () async {
      final useCase = AddExperienceUseCase(petRepository: petRepository);

      await expectLater(
        useCase.execute(UserAmountDto(userId: userId, amount: 10)),
        throwsA(isA<CustomError>()),
      );
    });
  });
}
