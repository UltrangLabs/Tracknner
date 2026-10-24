import '../interfaces/database_model.dart';

class UserModel implements DatabaseModel {
  @override
  String get tableName => 'User';

  @override
  String get createTableQuery => '''
    CREATE TABLE User (
      userId INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,      
      virtualCoins INTEGER NOT NULL DEFAULT 0,
      currentStreak INTEGER NOT NULL DEFAULT 0,
      highestStreak INTEGER NOT NULL DEFAULT 0,
      isPremium BOOLEAN NOT NULL CHECK (isPremium IN (0, 1)) DEFAULT 0
    )
  ''';
}
