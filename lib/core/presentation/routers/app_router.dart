import 'package:go_router/go_router.dart';

import '../../../modules/profile/presentation/screens/my_profile_screen.dart';
import '../../../shared/layout/main_layout_screen.dart';
import '../../../shared/screens/dashboard_screen.dart';
import 'constants/routes_path_constant.dart';

final _dashboardBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      path: kRoutesPath.dashboard,
      builder: (context, state) => const MyProfileScreen(),
    ),
  ],
);

final _carreraBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      path: kRoutesPath.carrera,
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
);

final _resumenBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      path: kRoutesPath.resumen,
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
);

final _historiaBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      path: kRoutesPath.historia,
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
);

final _mascotaBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      path: kRoutesPath.mascota,
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
);

final _mainShellRoute = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) =>
      MainLayoutScreen(navigationShell: navigationShell),
  branches: [
    _dashboardBranch,
    _carreraBranch,
    _resumenBranch,
    _historiaBranch,
    _mascotaBranch,
  ],
);

final appRouter = GoRouter(
  initialLocation: kRoutesPath.dashboard,
  routes: [_mainShellRoute],
);
