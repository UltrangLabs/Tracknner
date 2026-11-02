import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:running/core/di/injection_container.dart';
import 'package:running/core/domain/types/app_uuid.dart';
import 'package:running/main.dart';
import 'package:running/modules/game_engine/game_engine_module.dart';
import 'package:running/modules/profile/domain/entities/user_entity.dart';
import 'package:running/modules/profile/presentation/controllers/profile_controller.dart';
import 'package:running/modules/profile/presentation/screens/my_profile_screen.dart';
import 'package:running/shared/screens/dashboard_screen.dart';
import 'package:running/shared/widgets/bottom_nav.dart';

void main() {
  testWidgets('Dashboard smoke test verifies navigation tabs', (
    WidgetTester tester,
  ) async {
    await sl.reset();
    sl.registerFactory<ProfileController>(
      () => ProfileController(
        getUserAction: (_) async => User(
          id: AppUuid('user-1'),
          name: 'Sofia',
          virtualCoins: 0,
          currentStreak: 0,
          highestStreak: 0,
          isPremium: false,
        ),
        createUserAction: (_) async {},
        ensureUserPetAction: (dto) async => Pet(
          id: AppUuid('pet-1'),
          userId: dto.userId,
          name: dto.name,
          breed: dto.breed,
          imageAssetName: dto.imageAssetName,
          level: 1,
          experience: 0,
        ),
        getDailyMissionAction: (_) async =>
            const DailyMission(targetDurationSeconds: 900),
      ),
    );

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(MyProfileScreen), findsOneWidget);
    expect(find.byType(BottomNav), findsOneWidget);

    expect(find.text('Inicio'), findsWidgets);
    expect(find.text('Carrera'), findsWidgets);
    expect(find.text('Resumen'), findsWidgets);
    expect(find.text('Historia'), findsWidgets);
    expect(find.text('Mascota'), findsWidgets);

    // Tap on Carrera tab
    await tester.tap(find.byIcon(Icons.access_time_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(DashboardScreen), findsOneWidget);
  });
}
