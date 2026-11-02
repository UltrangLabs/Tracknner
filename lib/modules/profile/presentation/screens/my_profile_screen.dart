import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/presentation/routers/constants/routes_path_constant.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/window_modal.dart';
import '../../../game_engine/game_engine_module.dart';
import '../../domain/entities/user_entity.dart';
import '../constants/profile_constants.dart';
import '../controllers/profile_controller.dart';
import '../widgets/daily_mission_card.dart';
import '../widgets/pet_avatar.dart';
import '../widgets/pet_progress_section.dart';
import '../widgets/profile_top_bar.dart';
import '../widgets/user_form.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileController>(
      create: _createController,
      child: const Scaffold(
        backgroundColor: surfaceBackgroundColor,
        body: SafeArea(child: _ProfileBody()),
      ),
    );
  }

  ProfileController _createController(BuildContext context) {
    final controller = sl<ProfileController>();
    // Se difiere para no notificar listeners durante la fase de build.
    Future<void>.microtask(controller.checkExistingAccount);
    return controller;
  }
}

class _ProfileBody extends StatefulWidget {
  const _ProfileBody();

  @override
  State<_ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<_ProfileBody> {
  static const double _modalWidth = 360.0;
  static const double _modalHeight = 640.0;

  // Evita abrir modales duplicados en cada redibujado.
  bool _isModalOpen = false;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();

    // Evita abrir el formulario antes de saber si la cuenta ya existe.
    if (controller.isLoading || !controller.hasCheckedAccount) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }

    if (controller.errorMessage != null) {
      return _ProfileError(message: controller.errorMessage!);
    }

    final user = controller.data;
    final pet = controller.pet;
    final mission = controller.mission;

    if (user == null || pet == null || mission == null) {
      _scheduleUserFormModal(controller);
      return const SizedBox.expand();
    }

    return _ProfileContent(user: user, pet: pet, mission: mission);
  }

  void _scheduleUserFormModal(ProfileController controller) {
    if (_isModalOpen) {
      return;
    }
    _isModalOpen = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      WindowModal.show<void>(
        context: context,
        width: _modalWidth,
        height: _modalHeight,
        barrierDismissible: false,
        child: SingleChildScrollView(
          child: UserForm(
            onPetChosen: controller.choosePet,
            onUserCreated: (String userName) =>
                _onUserCreated(controller: controller, userName: userName),
          ),
        ),
      ).whenComplete(() => _isModalOpen = false);
    });
  }

  Future<void> _onUserCreated({
    required ProfileController controller,
    required String userName,
  }) async {
    // showDialog usa el navigator raíz por defecto (fuera del ShellRoute).
    Navigator.of(context, rootNavigator: true).pop();
    await controller.createUser({'name': userName});
  }
}

class _ProfileError extends StatelessWidget {
  static const TextStyle _errorStyle = TextStyle(color: inputErrorColor);

  final String message;

  const _ProfileError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Error: $message',
        style: _errorStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  static final EdgeInsets _screenPadding = EdgeInsets.symmetric(
    horizontal: kProfileLayoutDimensions.screenHorizontalPadding,
    vertical: kProfileLayoutDimensions.screenVerticalPadding,
  );

  final User user;
  final Pet pet;
  final DailyMission mission;

  const _ProfileContent({
    required this.user,
    required this.pet,
    required this.mission,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: _screenPadding,
      child: Column(
        children: [
          ProfileTopBar(coins: user.virtualCoins),
          SizedBox(height: kProfileLayoutDimensions.spacingMedium),
          _ProfileHeader(userName: user.name),
          SizedBox(height: kProfileLayoutDimensions.spacingDefault),
          PetAvatar(imagePath: pet.imageAssetName),
          SizedBox(height: kProfileLayoutDimensions.spacingSmall),
          PetProgressSection(
            level: pet.level,
            experience: pet.experience,
            requiredExperience: requiredExperienceFor(pet.level),
          ),
          SizedBox(height: kProfileLayoutDimensions.spacingLarge),
          DailyMissionCard(
            targetDurationSeconds: mission.targetDurationSeconds,
          ),
          SizedBox(height: kProfileLayoutDimensions.spacingCompact),
          const _StartRunButton(),
          SizedBox(height: kProfileLayoutDimensions.spacingCompact),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  static const TextStyle _subtitleStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: tertiaryColor,
  );

  static const TextStyle _titleStyle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  final String userName;

  const _ProfileHeader({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          kProfileStrings.companionSubtitle,
          style: _subtitleStyle,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: kProfileLayoutDimensions.spacingTiny),
        Text(
          greetingFor(userName),
          style: _titleStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _StartRunButton extends StatelessWidget {
  static const TextStyle _labelStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );

  const _StartRunButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textPrimaryColor,
          padding: EdgeInsets.symmetric(
            vertical: kProfileLayoutDimensions.spacingCompact,
          ),
        ),
        icon: const Icon(Icons.directions_run_rounded),
        label: Text(kProfileStrings.startRunLabel, style: _labelStyle),
        onPressed: () => context.go(kRoutesPath.carrera),
      ),
    );
  }
}
