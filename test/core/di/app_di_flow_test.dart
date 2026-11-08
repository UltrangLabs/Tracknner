import 'package:flutter_test/flutter_test.dart';
import 'package:running/core/di/injection_container.dart';
import 'package:running/core/infrastructure/database/interfaces/local_db_client.dart';
import 'package:running/core/infrastructure/database/models/pet_model.dart';
import 'package:running/core/infrastructure/database/models/user_model.dart';
import 'package:running/modules/game_engine/game_engine_module.dart';
import 'package:running/modules/profile/di/profile_di.dart';
import 'package:running/modules/profile/presentation/constants/profile_constants.dart';
import 'package:running/modules/profile/presentation/controllers/profile_controller.dart';
import 'package:sqflite_common_ffi/sqflite_common_ffi.dart';

import '../../helpers/sqlite_db_client.dart';

void main() {
  late Database db;

  setUpAll(sqfliteFfiInit);

  // Mismo orden de registro que main.dart, con una base real en memoria.
  setUp(() async {
    db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await db.execute(UserModel().createTableQuery);
    await db.execute(PetModel().createTableQuery);

    await sl.reset();
    sl.registerSingleton<LocalDbClient>(SqliteDbClient(db));
    initProfileDi();
    initPetCoreDi();
    initMissionsDi();
  });

  tearDown(() => db.close());

  test('new user keeps chosen pet, mission and balance on reopen', () async {
    final chosenPet = kAvailablePets[1];

    final firstRun = sl<ProfileController>();
    await firstRun.checkExistingAccount();
    expect(firstRun.data, isNull);
    expect(firstRun.hasCheckedAccount, isTrue);

    firstRun.choosePet(chosenPet.imagePath);
    await firstRun.createUser({'name': 'Sofia'});

    expect(firstRun.errorMessage, isNull);
    expect(firstRun.data?.name, 'Sofia');
    expect(firstRun.pet?.name, chosenPet.name);
    expect(firstRun.mission?.targetDurationSeconds, 900);

    final userId = firstRun.data!.id;
    await sl<ExecuteAddCoinsUseCase>(instanceName: addCoinsActionName)({
      'userId': userId.value,
      'amount': 40,
    });
    await sl<ExecuteDeductCoinsUseCase>(instanceName: deductCoinsActionName)({
      'userId': userId.value,
      'amount': 15,
    });
    await sl<ExecuteAddExperienceUseCase>()({
      'userId': userId.value,
      'amount': 130,
    });

    final reopened = sl<ProfileController>();
    await reopened.checkExistingAccount();

    expect(reopened.errorMessage, isNull);
    // Saldo inicial (30) + 40 - 15.
    expect(reopened.data?.virtualCoins, 55);
    expect(reopened.pet?.id, firstRun.pet?.id);
    expect(reopened.pet?.name, chosenPet.name);
    expect(reopened.pet?.level, 2);
    expect(reopened.pet?.experience, 30);
  });
}
