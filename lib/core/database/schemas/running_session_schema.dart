import '../interfaces/database_schema.dart';

class RunningSessionSchema implements DatabaseSchema {
  @override
  String get tableName => 'RunningSession';

  @override
  String get createTableQuery => '''
    CREATE TABLE RunningSession (
      sessionId INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      petId INTEGER, 
      startTime DATETIME NOT NULL,
      endTime DATETIME NOT NULL,
      totalDurationSeconds INTEGER NOT NULL,
      totalDistanceMeters REAL NOT NULL DEFAULT 0.0,
      averagePace REAL NOT NULL DEFAULT 0.0,
      earnedCoins INTEGER NOT NULL DEFAULT 0,
      appliedMultiplier REAL NOT NULL DEFAULT 1.0, -- Multiplier applied at the time of the session
      petEarnedExperience INTEGER NOT NULL DEFAULT 0,
      performanceCost INTEGER NOT NULL DEFAULT 0,
      isAccompaniedByPet BOOLEAN NOT NULL CHECK (isAccompaniedByPet IN (0, 1)) DEFAULT 0,
      isSynced BOOLEAN NOT NULL CHECK (isSynced IN (0, 1)) DEFAULT 0,
      FOREIGN KEY (userId) REFERENCES User(userId) ON DELETE CASCADE,
      FOREIGN KEY (petId) REFERENCES Pet(petId) ON DELETE SET NULL
    )
  ''';
}
