import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  final String title;

  const DashboardScreen({super.key, this.title = 'Dashboard'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.dashboard_outlined,
            size: 64.0,
            color: navActiveColor,
          ),
          const SizedBox(height: 16.0),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
