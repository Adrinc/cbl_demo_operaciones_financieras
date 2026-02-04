import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:facturacion_demo/helpers/globals.dart';
import 'package:facturacion_demo/main.dart';

const kThemeModeKey = '__theme_mode__';

void setDarkModeSetting(BuildContext context, ThemeMode themeMode) =>
    MyApp.of(context).setThemeMode(themeMode);

abstract class AppTheme {
  static ThemeMode get themeMode {
    final darkMode = prefs.getBool(kThemeModeKey);
    return darkMode == null
        ? ThemeMode.light
        : darkMode
            ? ThemeMode.dark
            : ThemeMode.light;
  }

  static LightModeTheme lightTheme = LightModeTheme();
  static DarkModeTheme darkTheme = DarkModeTheme();

  static void saveThemeMode(ThemeMode mode) => mode == ThemeMode.system
      ? prefs.remove(kThemeModeKey)
      : prefs.setBool(kThemeModeKey, mode == ThemeMode.dark);

  static AppTheme of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkTheme : lightTheme;

  abstract Color primaryColor;
  abstract Color secondaryColor;
  abstract Color tertiaryColor;
  abstract Color alternate;
  abstract Color primaryBackground;
  abstract Color secondaryBackground;
  abstract Color tertiaryBackground;
  abstract Color transparentBackground;
  abstract Color primaryText;
  abstract Color secondaryText;
  abstract Color tertiaryText;
  abstract Color hintText;
  abstract Color error;
  abstract Color warning;
  abstract Color success;
  abstract Color formBackground;

  String get title1Family => typography.title1Family;
  TextStyle get title1 => typography.title1;
  String get title2Family => typography.title2Family;
  TextStyle get title2 => typography.title2;
  String get title3Family => typography.title3Family;
  TextStyle get title3 => typography.title3;
  String get subtitle1Family => typography.subtitle1Family;
  TextStyle get subtitle1 => typography.subtitle1;
  String get subtitle2Family => typography.subtitle2Family;
  TextStyle get subtitle2 => typography.subtitle2;
  String get bodyText1Family => typography.bodyText1Family;
  TextStyle get bodyText1 => typography.bodyText1;
  String get bodyText2Family => typography.bodyText2Family;
  TextStyle get bodyText2 => typography.bodyText2;
  String get bodyText3Family => typography.bodyText3Family;
  TextStyle get bodyText3 => typography.bodyText3;
  String get plutoDataTextFamily => typography.plutoDataTextFamily;
  TextStyle get plutoDataText => typography.plutoDataText;
  String get copyRightTextFamily => typography.copyRightTextFamily;
  TextStyle get copyRightText => typography.copyRightText;

  Typography get typography => ThemeTypography(this);
}

class LightModeTheme extends AppTheme {
  @override
  Color primaryColor =
      const Color(0xFF1E3A8A); // Deep corporate blue - estructura/control
  @override
  Color secondaryColor =
      const Color(0xFF10B981); // Emerald green - beneficio/optimización
  @override
  Color tertiaryColor = const Color(0xFF3B82F6); // Bright blue - acento
  @override
  Color alternate = const Color(0xFFF59E0B); // Amber - warnings
  @override
  Color primaryBackground = const Color(0xFFF8FAFC); // Light gray background
  @override
  Color secondaryBackground = const Color(0xFFFFFFFF); // White surface
  @override
  Color tertiaryBackground = const Color(0xFFE5E7EB); // Light border/hover
  @override
  Color transparentBackground = const Color(0xFF64748B).withOpacity(.1);
  @override
  Color primaryText = const Color(0xFF0F172A); // Dark blue-gray text
  @override
  Color secondaryText = const Color(0xFF475569); // Medium gray text
  @override
  Color tertiaryText = const Color(0xFF94A3B8); // Light gray text
  @override
  Color hintText = const Color(0xFF94A3B8); // Text disabled
  @override
  Color error = const Color(0xFFEF4444); // Red - losses/negative
  @override
  Color warning = const Color(0xFFF59E0B); // Amber - attention needed
  @override
  Color success = const Color(0xFF10B981); // Green - savings/positive
  @override
  Color formBackground = const Color(0xFF1E3A8A).withOpacity(.05);
}

class DarkModeTheme extends AppTheme {
  @override
  Color primaryColor = const Color(0xFF3B82F6); // Bright blue - primary actions
  @override
  Color secondaryColor = const Color(0xFF34D399); // Light emerald - beneficios
  @override
  Color tertiaryColor = const Color(0xFF60A5FA); // Light blue - acento
  @override
  Color alternate = const Color(0xFFFBBF24); // Bright amber - warnings
  @override
  Color primaryBackground =
      const Color(0xFF0F172A); // Deep dark blue background
  @override
  Color secondaryBackground = const Color(0xFF1E293B); // Slate surface
  @override
  Color tertiaryBackground = const Color(0xFF334155); // Dark border/hover
  @override
  Color transparentBackground = const Color(0xFF64748B).withOpacity(.2);
  @override
  Color primaryText = const Color(0xFFF1F5F9); // Off-white text
  @override
  Color secondaryText = const Color(0xFF94A3B8); // Light gray text
  @override
  Color tertiaryText = const Color(0xFF64748B); // Muted gray text
  @override
  Color hintText = const Color(0xFF64748B); // Text disabled
  @override
  Color error = const Color(0xFFF87171); // Light red - losses/negative
  @override
  Color warning = const Color(0xFFFBBF24); // Bright amber - attention needed
  @override
  Color success = const Color(0xFF34D399); // Light green - savings/positive
  @override
  Color formBackground = const Color(0xFF3B82F6).withOpacity(.1);
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    required String fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    bool useGoogleFonts = true,
    TextDecoration? decoration,
    TextDecorationStyle? decorationStyle,
    double? lineHeight,
  }) =>
      useGoogleFonts
          ? GoogleFonts.getFont(
              fontFamily,
              color: color ?? this.color,
              fontSize: fontSize ?? this.fontSize,
              fontWeight: fontWeight ?? this.fontWeight,
              fontStyle: fontStyle ?? this.fontStyle,
              letterSpacing: letterSpacing ?? this.letterSpacing,
              decoration: decoration,
              decorationStyle: decorationStyle,
              height: lineHeight,
            )
          : copyWith(
              fontFamily: fontFamily,
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
              letterSpacing: letterSpacing,
              fontStyle: fontStyle,
              decoration: decoration,
              decorationStyle: decorationStyle,
              height: lineHeight,
            );
}

abstract class Typography {
  String get title1Family;
  TextStyle get title1;
  String get title2Family;
  TextStyle get title2;
  String get title3Family;
  TextStyle get title3;
  String get subtitle1Family;
  TextStyle get subtitle1;
  String get subtitle2Family;
  TextStyle get subtitle2;
  String get bodyText1Family;
  TextStyle get bodyText1;
  String get bodyText2Family;
  TextStyle get bodyText2;
  String get bodyText3Family;
  TextStyle get bodyText3;
  String get plutoDataTextFamily;
  TextStyle get plutoDataText;
  String get copyRightTextFamily;
  TextStyle get copyRightText;
}

class ThemeTypography extends Typography {
  ThemeTypography(this.theme);

  final AppTheme theme;

  @override
  String get title1Family => 'Poppins';
  @override
  TextStyle get title1 => GoogleFonts.poppins(
        fontSize: 70,
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
      );
  @override
  String get title2Family => 'Poppins';
  @override
  TextStyle get title2 => GoogleFonts.poppins(
        fontSize: 65,
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
      );
  @override
  String get title3Family => 'Poppins';
  @override
  TextStyle get title3 => GoogleFonts.poppins(
        fontSize: 48,
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
      );

  @override
  String get subtitle1Family => 'Poppins';
  @override
  TextStyle get subtitle1 => GoogleFonts.poppins(
        fontSize: 28,
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
      );
  @override
  String get subtitle2Family => 'Poppins';
  @override
  TextStyle get subtitle2 => GoogleFonts.poppins(
        fontSize: 24,
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
      );

  @override
  String get bodyText1Family => 'Poppins';
  @override
  TextStyle get bodyText1 => GoogleFonts.poppins(
        fontSize: 20,
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
      );
  @override
  String get bodyText2Family => 'Poppins';
  @override
  TextStyle get bodyText2 => GoogleFonts.poppins(
        fontSize: 18,
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
      );
  @override
  String get bodyText3Family => 'Poppins';
  @override
  TextStyle get bodyText3 => GoogleFonts.poppins(
        fontSize: 14,
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
      );
  @override
  String get plutoDataTextFamily => 'Poppins';
  @override
  TextStyle get plutoDataText => GoogleFonts.poppins(
        fontSize: 12,
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
      );
  @override
  String get copyRightTextFamily => 'Poppins';
  @override
  TextStyle get copyRightText => GoogleFonts.poppins(
        fontSize: 12,
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
      );
}
