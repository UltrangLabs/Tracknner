import '../../../../../../core/domain/types/app_uuid.dart';

class EnsureUserPetDto {
  final AppUuid userId;
  final String name;
  final String breed;
  final String imageAssetName;

  const EnsureUserPetDto({
    required this.userId,
    required this.name,
    required this.breed,
    required this.imageAssetName,
  });
}
