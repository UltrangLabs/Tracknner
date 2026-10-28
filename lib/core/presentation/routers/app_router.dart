import 'package:go_router/go_router.dart';

import '../../../shared/screens/dashboard_screen.dart';
import 'constants/routes_path_constant.dart';

final _dashboardScreen = GoRoute(
  path: kRoutesPath.dashboard,
  builder: (context, state) => const DashboardScreen(),
);

final _carreraScreen = GoRoute(
  path: kRoutesPath.carrera,
  builder: (context, state) => const DashboardScreen(),
);

final _resumenScreen = GoRoute(
  path: kRoutesPath.resumen,
  builder: (context, state) => const DashboardScreen(),
);

final _historiaScreen = GoRoute(
  path: kRoutesPath.historia,
  builder: (context, state) => const DashboardScreen(),
);

final _mascotaScreen = GoRoute(
  path: kRoutesPath.mascota,
  builder: (context, state) => const DashboardScreen(),
);

final appRouter = GoRouter(
  initialLocation: kRoutesPath.dashboard,
  routes: [
    _dashboardScreen,
    _carreraScreen,
    _resumenScreen,
    _historiaScreen,
    _mascotaScreen,
  ],
);
