import 'package:flutter/material.dart';

/// Local font helper — drop-in replacement for GoogleFonts.
/// Usage: AppFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)
class AppFonts {
  AppFonts._();

  static TextStyle poppins({
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    Color? color,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
  }) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
    );
  }

  static TextStyle ebGaramond({
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    Color? color,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
  }) {
    return TextStyle(
      fontFamily: 'EBGaramond',
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
    );
  }

  static TextStyle firaSans({
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    Color? color,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
  }) {
    return TextStyle(
      fontFamily: 'FiraSans',
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
    );
  }
}
