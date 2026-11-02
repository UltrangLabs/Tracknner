// 🚪 API Pública del módulo Game Engine
export 'missions/application/use_cases/get_daily_mission_use_case.dart';
export 'missions/application/use_cases/validate_mission_use_case.dart';
export 'missions/di/missions_di.dart';
export 'missions/domain/entities/daily_mission.dart';
export 'missions/domain/entities/mission_result.dart';
export 'pet_core/application/use_cases/add_coins_use_case.dart';
export 'pet_core/application/use_cases/add_experience_use_case.dart';
export 'pet_core/application/use_cases/deduct_coins_use_case.dart';
export 'pet_core/application/use_cases/ensure_user_pet_use_case.dart';
export 'pet_core/di/pet_core_di.dart';
export 'pet_core/domain/dtos/in/ensure_user_pet_dto.dart';
export 'pet_core/domain/dtos/in/user_amount_dto.dart';
export 'pet_core/domain/entities/pet.dart';
export 'pet_core/domain/services/progression_rules.dart';

class GameEngineModule {}
