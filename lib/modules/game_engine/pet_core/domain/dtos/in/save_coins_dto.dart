import '../../../../../../core/domain/types/app_uuid.dart';

abstract interface class SaveCoinsDto {
  AppUuid get userId;
  int get coins;
}
