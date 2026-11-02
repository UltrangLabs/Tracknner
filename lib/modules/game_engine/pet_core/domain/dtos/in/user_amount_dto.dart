import '../../../../../../core/domain/types/app_uuid.dart';

abstract interface class UserAmountDto {
  AppUuid get userId;
  int get amount;
}
