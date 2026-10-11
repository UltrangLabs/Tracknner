import '../interfaces/database_schema.dart';

class UserSchema implements DatabaseSchema {
  @override
  String get tableName => 'User';

  @override
  String get createTableQuery => '''
    CREATE TABLE User (
      userId INTEGER PRIMARY KEY AUTOINCREMENT,
      virtualCoins INTEGER NOT NULL DEFAULT 0,
      currentStreak INTEGER NOT NULL DEFAULT 0,
      highestStreak INTEGER NOT NULL DEFAULT 0,
      isPremium BOOLEAN NOT NULL CHECK (isPremium IN (0, 1)) DEFAULT 0
    )
  ''';
}
