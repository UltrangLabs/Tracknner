import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/presentation/routers/config/menu_items.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int currentIndex = _calculateSelectedIndex(context);
    final MenuItem currentItem = appMenuItems[currentIndex];

    return Scaffold(
      backgroundColor: surfaceBackgroundColor,
      body: SafeArea(
        child: _DashboardTabPlaceholder(
          title: currentItem.title,
          subTitle: currentItem.subTitle,
          icon: currentItem.icon,
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: currentIndex,
        onTap: (int index) => _onTabSelected(context: context, index: index),
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    try {
      final String location = GoRouterState.of(context).matchedLocation;
      final int index = appMenuItems.indexWhere(
        (MenuItem item) => item.link == location,
      );
      return index < 0 ? 0 : index;
    } catch (_) {
      return 0;
    }
  }

  void _onTabSelected({required BuildContext context, required int index}) {
    if (index >= 0 && index < appMenuItems.length) {
      try {
        context.go(appMenuItems[index].link);
      } catch (_) {
        // Fallback when GoRouter is not available
      }
    }
  }
}

class _DashboardTabPlaceholder extends StatelessWidget {
  static const double _iconSize = 64.0;
  static const double _spacing = 16.0;

  static const TextStyle _titleTextStyle = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static const TextStyle _subtitleTextStyle = TextStyle(
    fontSize: 14.0,
    color: textSecondaryColor,
  );

  final String title;
  final String subTitle;
  final IconData icon;

  const _DashboardTabPlaceholder({
    required this.title,
    required this.subTitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: _iconSize, color: navActiveColor),
          const SizedBox(height: _spacing),
          Text(title, style: _titleTextStyle),
          const SizedBox(height: 8.0),
          Text(subTitle, style: _subtitleTextStyle),
        ],
      ),
    );
  }
}
