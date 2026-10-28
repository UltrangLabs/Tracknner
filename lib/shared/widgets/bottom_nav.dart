import 'package:flutter/material.dart';

import '../constants/bottom_nav_constants.dart';
import '../theme/app_theme.dart';

export '../constants/bottom_nav_constants.dart';

class BottomNav extends StatelessWidget {
  static const List<BottomNavItem> defaultItems = defaultBottomNavItems;

  static const Border _topBorder = Border(
    top: BorderSide(color: navBorderColor, width: 1.0),
  );

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItem> items;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items = defaultBottomNavItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: navBackgroundColor,
        border: _topBorder,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60.0,
          child: Row(
            children: [
              for (int i = 0; i < items.length; i++)
                _BottomNavItemWidget(
                  item: items[i],
                  isSelected: currentIndex == i,
                  onTap: () => onTap(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItemWidget extends StatelessWidget {
  static const double _iconSize = 24.0;
  static const double _spacing = 4.0;

  static const TextStyle _activeTextStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    color: navActiveColor,
  );

  static const TextStyle _inactiveTextStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: navInactiveColor,
  );

  final BottomNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomNavItemWidget({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color currentColor = isSelected ? navActiveColor : navInactiveColor;
    final TextStyle currentTextStyle = isSelected
        ? _activeTextStyle
        : _inactiveTextStyle;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: _iconSize, color: currentColor),
            const SizedBox(height: _spacing),
            Text(
              item.label,
              style: currentTextStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
