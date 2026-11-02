import '../../../../../core/domain/types/app_uuid.dart';

class Pet {
  final AppUuid id;
  final AppUuid userId;
  final String name;
  final String breed;
  final String imageAssetName;
  final int level;
  final int experience;

  const Pet({
    required this.id,
    required this.userId,
    required this.name,
    required this.breed,
    required this.imageAssetName,
    required this.level,
    required this.experience,
  });
}
