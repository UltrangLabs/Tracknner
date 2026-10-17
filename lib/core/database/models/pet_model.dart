import '../interfaces/database_model.dart';

class PetModel implements DatabaseModel {
  @override
  String get tableName => 'Pet';

  @override
  String get createTableQuery => '''
    CREATE TABLE Pet (
      petId INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL UNIQUE,
      petName TEXT NOT NULL,
      petBreed TEXT NOT NULL,
      imageAssetName TEXT NOT NULL,
      currentLevel INTEGER NOT NULL DEFAULT 1,
      currentExperience INTEGER NOT NULL DEFAULT 0,
      performanceLevel INTEGER NOT NULL DEFAULT 100,
      FOREIGN KEY (userId) REFERENCES User(userId) ON DELETE CASCADE
    );
  ''';
}
