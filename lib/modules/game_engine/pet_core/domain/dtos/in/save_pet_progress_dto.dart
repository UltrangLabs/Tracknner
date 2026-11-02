import '../../../../../../core/domain/types/app_uuid.dart';

abstract interface class SavePetProgressDto {
  AppUuid get petId;
  int get level;
  int get experience;
}
