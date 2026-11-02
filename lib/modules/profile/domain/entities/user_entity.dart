import '../../../../core/domain/types/app_uuid.dart';

class User {
  final AppUuid id;
  final String name;
  final int virtualCoins;
  final int currentStreak;
  final int highestStreak;
  final bool isPremium;

  const User({
    required this.id,
    required this.name,
    required this.virtualCoins,
    required this.currentStreak,
    required this.highestStreak,
    required this.isPremium,
  });
}
