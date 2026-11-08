import '../../../../../../core/domain/types/app_uuid.dart';

abstract interface class EnsureUserPetDto {
  AppUuid get userId;
  String get name;
  String get breed;
  String get imageAssetName;
}
