import 'package:flutter/material.dart';

const Color primaryColor = Color.fromRGBO(241, 146, 2, 1);
const Color secondaryColor = Color.fromRGBO(255, 247, 200, 1);
const Color tertiaryColor = Color.fromRGBO(218, 154, 60, 1);
const Color quaternaryColor = Color.fromRGBO(253, 254, 247, 1);
const Color quinaryColor = Color.fromRGBO(254, 223, 165, 1);
const Color sextarianColor = Color.fromRGBO(241, 190, 116, 1);
const Color septarianColor = Color.fromRGBO(226, 148, 31, 1);
const Color octarineColor = Color.fromRGBO(255, 252, 227, 1);

const List<Color> _colorThemes = [
  primaryColor,
  secondaryColor,
  tertiaryColor,
  quaternaryColor,
  quinaryColor,
  sextarianColor,
  septarianColor,
  octarineColor,
];

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0})
    : assert(selectedColor >= 0 && selectedColor < _colorThemes.length);

  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colorThemes[selectedColor],
    );
  }
}

// Navigation and UI colors
const Color navActiveColor = primaryColor;
const Color navInactiveColor = Color.fromRGBO(142, 142, 147, 1);
const Color navBackgroundColor = Color.fromRGBO(255, 255, 255, 1);
const Color navBorderColor = Color.fromRGBO(230, 232, 236, 1);
const Color transparentColor = Color.fromRGBO(0, 0, 0, 0);
const Color surfaceBackgroundColor = Color.fromRGBO(248, 249, 250, 1);
const Color textPrimaryColor = Color.fromRGBO(33, 33, 33, 1);
const Color textSecondaryColor = Color.fromRGBO(117, 117, 117, 1);
