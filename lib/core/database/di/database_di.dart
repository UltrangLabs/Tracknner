import '../../di/injection_container.dart';
import '../config/database_connection.dart';
import '../interfaces/local_db_client.dart';
import '../models/daily_mission_model.dart';
import '../models/pet_model.dart';
import '../models/running_session_model.dart';
import '../models/user_model.dart';

Future<void> initDatabaseDi() async {
  final databaseConnection = DatabaseConnection(
    models: [
      UserModel(),
      PetModel(),
      DailyMissionModel(),
      RunningSessionModel(),
    ],
  );

  await databaseConnection.initForDesktop();
  await databaseConnection.connect();

  sl.registerSingleton<LocalDbClient>(databaseConnection);
}
