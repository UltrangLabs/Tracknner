import '../../../../core/domain/types/unknown_type.dart';
import '../../../../core/domain/use_cases/interfaces/structure_use_case.dart';
import '../../../../core/presentation/controllers/base_controller.dart';
import '../../../game_engine/game_engine_module.dart';
import '../../application/use_cases/create_user_use_case.dart';
import '../../application/use_cases/get_user_already_have_an_account_use_case.dart';
import '../../domain/entities/user_entity.dart';
import '../constants/profile_constants.dart';

class ProfileController extends BaseController<User> {
  final ExecuteGetUserAlreadyHaveAnAccountUseCase _getUserAction;
  final ExecuteCreateUserUseCase _createUserAction;
  final ExecuteEnsureUserPetUseCase _ensureUserPetAction;
  final ExecuteGetDailyMissionUseCase _getDailyMissionAction;

  PetOption _chosenPet = kAvailablePets.first;
  bool _hasCheckedAccount = false;
  Pet? _pet;
  DailyMission? _mission;

  ProfileController({
    required this._getUserAction,
    required this._createUserAction,
    required this._ensureUserPetAction,
    required this._getDailyMissionAction,
  });

  bool get hasCheckedAccount => _hasCheckedAccount;
  Pet? get pet => _pet;
  DailyMission? get mission => _mission;

  void choosePet(String imagePath) {
    _chosenPet = kAvailablePets.firstWhere(
      (pet) => pet.imagePath == imagePath,
      orElse: () => kAvailablePets.first,
    );
  }

  Future<void> checkExistingAccount() async {
    return executeUseCase(_loadAccountData);
  }

  Future<void> createUser(Unknown rawData) async {
    return executeUseCase(() async {
      await _createUserAction(rawData);
      await _loadAccountData();
    });
  }

  Future<void> _loadAccountData() async {
    final user = await _getUserAction(const NoParams());
    _hasCheckedAccount = true;
    if (user != null) {
      await _loadCompanionData(user);
      setData(user);
    } else {
      setLoading(isLoading: false);
    }
  }

  Future<void> _loadCompanionData(User user) async {
    _pet = await _ensureUserPetAction({
      'userId': user.id.value,
      'name': _chosenPet.name,
      'breed': _chosenPet.breed,
      'imageAssetName': _chosenPet.imagePath,
    });
    _mission = await _getDailyMissionAction(const NoParams());
  }
}
