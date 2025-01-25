import 'package:flutter/material.dart';

class Constants {
  static const baseImageUrl = 'http://10.0.2.2:8080/';
  static const baseUrl = 'http://10.0.2.2:8080/api/';

  static final primaryRadius = BorderRadius.circular(6.0);
  static const primaryRadiusValue = 6.0;
  static const double primaryPadding = 16.0;
  static const double productItemHeight = 300;
  static const double primaryButtonHeight = 52;
  static List<BoxShadow> primaryBoxShadow(BuildContext context,
      {Color? shadowColor = null,
      double blurRadius = 9,
      double colorOpacity = 0.125}) {
    final themeData = Theme.of(context).colorScheme;
    return [
      BoxShadow(
        color: shadowColor ?? themeData.onSurface.withOpacity(colorOpacity),
        blurRadius: blurRadius,
      ),
    ];
  }
}
