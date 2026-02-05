import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:facturacion_demo/helpers/globals.dart';

const kThemeModeKey = '__theme_mode__';

abstract class AppTheme extends ThemeExtension<AppTheme> {
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

  // Aliases para compatibilidad con widgets
  Color get primary => primaryColor;
  Color get secondary => secondaryColor;
  Color get surface => secondaryBackground;
  Color get border => tertiaryBackground;
  Color get textPrimary => primaryText;
  Color get textSecondary => secondaryText;
  Color get textDisabled => hintText;
  Color get accent => tertiaryColor;

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
  Color primaryColor = const Color(0xFF0F766E); // Teal profesional
  @override
  Color secondaryColor = const Color(0xFFF97316); // Naranja vibrante
  @override
  Color tertiaryColor = const Color(0xFF06B6D4); // Cyan brillante
  @override
  Color alternate = const Color(0xFFEAB308); // Amarillo dorado
  @override
  Color primaryBackground = const Color(0xFFF8FAFC); // Fondo claro
  @override
  Color secondaryBackground = const Color(0xFFFFFFFF); // Surface blanco
  @override
  Color tertiaryBackground = const Color(0xFFE2E8F0); // Bordes suaves
  @override
  Color transparentBackground = const Color(0xFF64748B).withOpacity(.08);
  @override
  Color primaryText = const Color(0xFF0F172A); // Texto oscuro
  @override
  Color secondaryText = const Color(0xFF475569); // Texto secundario
  @override
  Color tertiaryText = const Color(0xFF94A3B8); // Texto terciario
  @override
  Color hintText = const Color(0xFF94A3B8); // Placeholder
  @override
  Color error = const Color(0xFFDC2626); // Rojo error
  @override
  Color warning = const Color(0xFFEAB308); // Amarillo warning
  @override
  Color success = const Color(0xFF16A34A); // Verde success
  @override
  Color formBackground = const Color(0xFF0F766E).withOpacity(.05);

  @override
  ThemeExtension<AppTheme> copyWith() => LightModeTheme();

  @override
  ThemeExtension<AppTheme> lerp(ThemeExtension<AppTheme>? other, double t) {
    if (other is! LightModeTheme) return this;
    return this;
  }
}

class DarkModeTheme extends AppTheme {
  @override
  Color primaryColor =
      const Color(0xFF2DD4BF); // Teal vibrante (como la imagen)
  @override
  Color secondaryColor = const Color(0xFFF97316); // Naranja vibrante
  @override
  Color tertiaryColor = const Color(0xFF22D3EE); // Cyan brillante
  @override
  Color alternate = const Color(0xFFFBBF24); // Amarillo dorado
  @override
  Color primaryBackground = const Color(0xFF0D1117); // Fondo muy oscuro azulado
  @override
  Color secondaryBackground = const Color(0xFF161B22); // Surface oscuro
  @override
  Color tertiaryBackground = const Color(0xFF30363D); // Bordes sutiles
  @override
  Color transparentBackground = const Color(0xFF30363D).withOpacity(.5);
  @override
  Color primaryText = const Color(0xFFF0F6FC); // Texto casi blanco
  @override
  Color secondaryText = const Color(0xFF8B949E); // Texto secundario
  @override
  Color tertiaryText = const Color(0xFF6E7681); // Texto terciario
  @override
  Color hintText = const Color(0xFF484F58); // Placeholder oscuro
  @override
  Color error = const Color(0xFFF87171); // Rojo claro
  @override
  Color warning = const Color(0xFFFBBF24); // Amarillo brillante
  @override
  Color success = const Color(0xFF34D399); // Verde esmeralda

  @override
  ThemeExtension<AppTheme> copyWith() => DarkModeTheme();

  @override
  ThemeExtension<AppTheme> lerp(ThemeExtension<AppTheme>? other, double t) {
    if (other is! DarkModeTheme) return this;
    return this;
  }

  @override
  Color formBackground = const Color(0xFF2DD4BF).withOpacity(.08);
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
