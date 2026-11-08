import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/presentation/routers/config/menu_items.dart';
import '../theme/app_theme.dart';

class BottomNav extends StatelessWidget {
  static const BoxDecoration _containerDecoration = BoxDecoration(
    color: navBackgroundColor,
    border: Border(top: BorderSide(color: navBorderColor, width: 1.0)),
  );

  static final NavigationBarThemeData _themeData = NavigationBarThemeData(
    backgroundColor: navBackgroundColor,
    surfaceTintColor: transparentColor,
    indicatorColor: transparentColor,
    elevation: 0,
    iconTheme: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const IconThemeData(color: navActiveColor);
      }
      return const IconThemeData(color: navInactiveColor);
    }),
    labelTextStyle: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: navActiveColor,
        );
      }
      return const TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        color: navInactiveColor,
      );
    }),
  );

  static final List<NavigationDestination> _destinations = appMenuItems
      .map(
        (MenuItem item) =>
            NavigationDestination(icon: Icon(item.icon), label: item.title),
      )
      .toList();

  final StatefulNavigationShell navigationShell;

  const BottomNav({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _containerDecoration,
      child: NavigationBarTheme(
        data: _themeData,
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: _destinations,
        ),
      ),
    );
  }

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
