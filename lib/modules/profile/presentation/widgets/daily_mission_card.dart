import 'package:flutter/material.dart';

import '../../../../shared/theme/app_theme.dart';
import '../constants/profile_constants.dart';

class DailyMissionCard extends StatelessWidget {
  static final EdgeInsets _cardPadding = EdgeInsets.all(
    kDailyMissionCardDimensions.cardPadding,
  );
  static final EdgeInsets _iconPadding = EdgeInsets.all(
    kDailyMissionCardDimensions.iconPadding,
  );

  static const BorderRadius _cardRadius = BorderRadius.all(
    Radius.circular(16.0),
  );
  static const BorderRadius _iconRadius = BorderRadius.all(
    Radius.circular(12.0),
  );

  static final List<BoxShadow> _cardShadow = [
    BoxShadow(
      color: cardShadowColor,
      blurRadius: kDailyMissionCardDimensions.shadowBlurRadius,
      offset: Offset(0, kDailyMissionCardDimensions.shadowOffsetY),
    ),
  ];

  static final BoxDecoration _cardDecoration = BoxDecoration(
    color: cardBackgroundColor,
    borderRadius: _cardRadius,
    boxShadow: _cardShadow,
    border: const Border.fromBorderSide(BorderSide(color: navBorderColor)),
  );

  static const BoxDecoration _iconDecoration = BoxDecoration(
    color: secondaryColor,
    borderRadius: _iconRadius,
  );

  static const TextStyle _tagStyle = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    color: textSecondaryColor,
  );

  static const TextStyle _titleStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
  );

  final int targetDurationSeconds;

  const DailyMissionCard({super.key, required this.targetDurationSeconds});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _cardPadding,
      decoration: _cardDecoration,
      child: Row(
        children: [
          Container(
            padding: _iconPadding,
            decoration: _iconDecoration,
            child: Icon(
              Icons.directions_run_rounded,
              size: kDailyMissionCardDimensions.iconSize,
              color: primaryColor,
            ),
          ),
          SizedBox(width: kProfileLayoutDimensions.spacingWideGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(kProfileStrings.dailyMissionTag, style: _tagStyle),
                SizedBox(height: kProfileLayoutDimensions.spacingMicro),
                Text(
                  missionTitleFor(targetDurationSeconds),
                  style: _titleStyle,
                ),
              ],
            ),
          ),
          Icon(
            Icons.flag_rounded,
            color: primaryColor,
            size: kDailyMissionCardDimensions.checkIconSize,
          ),
        ],
      ),
    );
  }
}
