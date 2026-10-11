import '../interfaces/database_schema.dart';

class DailyMissionSchema implements DatabaseSchema {
  @override
  String get tableName => 'DailyMission';

  @override
  String get createTableQuery => '''
    CREATE TABLE DailyMission (
      missionId INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      assignedDate DATE NOT NULL,
      targetDurationSeconds INTEGER NOT NULL,
      isCompleted BOOLEAN NOT NULL CHECK (isCompleted IN (0, 1)) DEFAULT 0,
      FOREIGN KEY (userId) REFERENCES User(userId) ON DELETE CASCADE
    );
  ''';
}
