import 'package:flutter/material.dart';

import '../../../../shared/theme/app_theme.dart';
import '../constants/profile_constants.dart';

class PetProgressSection extends StatelessWidget {
  final int level;
  final int experience;
  final int requiredExperience;

  const PetProgressSection({
    super.key,
    required this.level,
    required this.experience,
    required this.requiredExperience,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LevelBadge(level: level),
        SizedBox(height: kProfileLayoutDimensions.spacingCompact),
        _XpProgressBar(
          experience: experience,
          requiredExperience: requiredExperience,
        ),
        SizedBox(height: kProfileLayoutDimensions.spacingDefault),
        const _FeedActionButton(),
      ],
    );
  }
}

class _LevelBadge extends StatelessWidget {
  static final EdgeInsets _badgePadding = EdgeInsets.symmetric(
    horizontal: kPetProgressDimensions.levelBadgeHorizontalPadding,
    vertical: kPetProgressDimensions.levelBadgeVerticalPadding,
  );

  static const BorderRadius _badgeRadius = BorderRadius.all(
    Radius.circular(16.0),
  );

  static const BoxDecoration _badgeDecoration = BoxDecoration(
    color: primaryColor,
    borderRadius: _badgeRadius,
  );

  static const TextStyle _levelTextStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w700,
    color: whiteColor,
  );

  static const TextStyle _labelTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
  );

  final int level;

  const _LevelBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: _badgePadding,
          decoration: _badgeDecoration,
          child: Text(levelLabelFor(level), style: _levelTextStyle),
        ),
        SizedBox(width: kProfileLayoutDimensions.spacingTiny),
        Flexible(
          child: Text(kProfileStrings.levelTitle, style: _labelTextStyle),
        ),
      ],
    );
  }
}

class _XpProgressBar extends StatelessWidget {
  static final double _barHeight = kPetProgressDimensions.progressBarHeight;

  static const BorderRadius _barRadius = BorderRadius.all(Radius.circular(6.0));

  static const TextStyle _xpTitleStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
    color: textSecondaryColor,
  );

  static const TextStyle _xpValueStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    color: textSecondaryColor,
  );

  final int experience;
  final int requiredExperience;

  const _XpProgressBar({
    required this.experience,
    required this.requiredExperience,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(kProfileStrings.xpTitle, style: _xpTitleStyle),
            Text(
              experienceLabel(experience: experience, goal: requiredExperience),
              style: _xpValueStyle,
            ),
          ],
        ),
        SizedBox(height: kProfileLayoutDimensions.spacingTiny),
        ClipRRect(
          borderRadius: _barRadius,
          child: LinearProgressIndicator(
            value: experience / requiredExperience,
            minHeight: _barHeight,
            backgroundColor: progressBarBackgroundColor,
            valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
          ),
        ),
      ],
    );
  }
}

class _FeedActionButton extends StatelessWidget {
  static final EdgeInsets _buttonPadding = EdgeInsets.symmetric(
    horizontal: kPetProgressDimensions.feedButtonHorizontalPadding,
    vertical: kPetProgressDimensions.feedButtonVerticalPadding,
  );

  static const BorderRadius _buttonRadius = BorderRadius.all(
    Radius.circular(24.0),
  );

  static final BoxDecoration _buttonDecoration = BoxDecoration(
    color: whiteColor,
    borderRadius: _buttonRadius,
    border: Border.fromBorderSide(
      BorderSide(
        color: petHaloBorderColor,
        width: kPetProgressDimensions.feedButtonBorderWidth,
      ),
    ),
  );

  static const TextStyle _actionTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
  );

  static const TextStyle _costTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  const _FeedActionButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _buttonPadding,
      decoration: _buttonDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.restaurant_outlined,
            color: tertiaryColor,
            size: kPetProgressDimensions.feedActionIconSize,
          ),
          SizedBox(width: kProfileLayoutDimensions.spacingTiny),
          Text(kProfileStrings.feedButtonTitle, style: _actionTextStyle),
          SizedBox(width: kProfileLayoutDimensions.spacingTiny),
          Text(
            kProfileStrings.bulletSeparator,
            style: const TextStyle(color: textSecondaryColor),
          ),
          SizedBox(width: kProfileLayoutDimensions.spacingTiny),
          Icon(
            Icons.monetization_on_rounded,
            color: primaryColor,
            size: kPetProgressDimensions.feedCoinIconSize,
          ),
          SizedBox(width: kProfileLayoutDimensions.spacingMicro),
          Text(kProfileStrings.feedCost, style: _costTextStyle),
        ],
      ),
    );
  }
}
