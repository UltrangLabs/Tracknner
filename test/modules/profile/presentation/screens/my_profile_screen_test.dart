import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:running/core/di/injection_container.dart';
import 'package:running/core/domain/types/app_uuid.dart';
import 'package:running/core/domain/types/unknown_type.dart';
import 'package:running/modules/game_engine/game_engine_module.dart';
import 'package:running/modules/profile/domain/entities/user_entity.dart';
import 'package:running/modules/profile/presentation/controllers/profile_controller.dart';
import 'package:running/modules/profile/presentation/screens/my_profile_screen.dart';
import 'package:running/modules/profile/presentation/widgets/user_form.dart';

void main() {
  final existingUser = User(
    id: AppUuid('user-1'),
    name: 'Sofía',
    virtualCoins: 75,
    currentStreak: 0,
    highestStreak: 0,
    isPremium: false,
  );

  Pet petFrom(Unknown rawData) => Pet(
    id: AppUuid('pet-1'),
    userId: AppUuid(rawData['userId'].toString()),
    name: rawData['name'].toString(),
    breed: rawData['breed'].toString(),
    imageAssetName: rawData['imageAssetName'].toString(),
    level: 2,
    experience: 30,
  );

  Future<void> pumpScreen(WidgetTester tester, {User? user}) async {
    await sl.reset();
    sl.registerFactory<ProfileController>(
      () => ProfileController(
        getUserAction: (_) async => user,
        createUserAction: (_) async {},
        ensureUserPetAction: (rawData) async => petFrom(rawData),
        getDailyMissionAction: (_) async =>
            const DailyMission(targetDurationSeconds: 900),
      ),
    );
    tester.view.physicalSize = const Size(1080, 3000);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: MyProfileScreen()));
    await tester.pumpAndSettle();
  }

  testWidgets('shows real user, pet and mission data', (tester) async {
    await pumpScreen(tester, user: existingUser);

    expect(find.text('Tracknner'), findsOneWidget);
    expect(find.text('75'), findsOneWidget);
    expect(find.text('¡Sigue así, Sofía!'), findsOneWidget);
    expect(find.text('LVL 2'), findsOneWidget);
    expect(find.text('30 / 200'), findsOneWidget);
    expect(find.text('Objetivo de hoy: Corre 15 minutos'), findsOneWidget);
    expect(find.text('Empezar Carrera'), findsOneWidget);
    expect(find.byType(UserForm), findsNothing);
  });

  testWidgets('asks for a profile only when there is no account', (
    tester,
  ) async {
    await pumpScreen(tester);

    expect(find.byType(UserForm), findsOneWidget);
  });
}
