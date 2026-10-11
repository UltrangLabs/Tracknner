import '../config/database_connection.dart';
import '../schemas/daily_mission_schema.dart';
import '../schemas/pet_schema.dart';
import '../schemas/running_session_schema.dart';
import '../schemas/user_schema.dart';

Future<void> initDatabaseDi() async {
  final databaseConnection = DatabaseConnection(
    models: [
      UserSchema(),
      PetSchema(),
      DailyMissionSchema(),
      RunningSessionSchema(),
    ],
  );

  await databaseConnection.initForDesktop();
  await databaseConnection.connect();
}
