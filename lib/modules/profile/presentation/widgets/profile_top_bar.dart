import 'package:flutter/material.dart';

import '../../../../shared/theme/app_theme.dart';
import '../constants/profile_constants.dart';

class ProfileTopBar extends StatelessWidget {
  static final double _logoSize = kProfileTopBarDimensions.logoSize;
  static final double _iconSize = kProfileTopBarDimensions.logoIconSize;
  static final double _coinIconSize = kProfileTopBarDimensions.coinIconSize;

  static final EdgeInsets _coinPadding = EdgeInsets.symmetric(
    horizontal: kProfileTopBarDimensions.coinHorizontalPadding,
    vertical: kProfileTopBarDimensions.coinVerticalPadding,
  );

  static const BorderRadius _logoRadius = BorderRadius.all(
    Radius.circular(10.0),
  );
  static const BorderRadius _coinRadius = BorderRadius.all(
    Radius.circular(20.0),
  );

  static const TextStyle _logoTextStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static const TextStyle _coinTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static const BoxDecoration _logoDecoration = BoxDecoration(
    color: primaryColor,
    borderRadius: _logoRadius,
  );

  static const BoxDecoration _coinDecoration = BoxDecoration(
    color: whiteColor,
    borderRadius: _coinRadius,
    border: Border.fromBorderSide(BorderSide(color: navBorderColor)),
  );

  final int coins;

  const ProfileTopBar({super.key, required this.coins});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: _logoSize,
              height: _logoSize,
              decoration: _logoDecoration,
              child: Center(
                child: ClipRRect(
                  borderRadius: _logoRadius,
                  child: Image.asset(
                    kProfileStrings.appLogoPath,
                    width: _iconSize,
                    height: _iconSize,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(width: kProfileLayoutDimensions.spacingGap),
            Text(kProfileStrings.appName, style: _logoTextStyle),
          ],
        ),
        Container(
          padding: _coinPadding,
          decoration: _coinDecoration,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.monetization_on_rounded,
                color: primaryColor,
                size: _coinIconSize,
              ),
              SizedBox(width: kProfileLayoutDimensions.spacingInline),
              Text('$coins', style: _coinTextStyle),
            ],
          ),
        ),
      ],
    );
  }
}
