import '../interfaces/database_model.dart';

class DailyMissionModel implements DatabaseModel {
  @override
  String get tableName => 'DailyMission';

  @override
  String get createTableQuery => '''
    CREATE TABLE DailyMission (
      missionId TEXT PRIMARY KEY,
      userId TEXT NOT NULL,
      assignedDate DATE NOT NULL,
      targetDurationSeconds INTEGER NOT NULL,
      isCompleted BOOLEAN NOT NULL CHECK (isCompleted IN (0, 1)) DEFAULT 0,
      FOREIGN KEY (userId) REFERENCES User(userId) ON DELETE CASCADE
    );
  ''';
}
