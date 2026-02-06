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

  /// ========================================================================
  /// SISTEMA DE SOMBRAS PREMIUM
  /// ========================================================================
  /// Sombras adaptativas que crean profundidad real en light y dark mode
  /// Inspirado en Bloomberg Terminal y diseños de alto contraste
  /// ========================================================================

  // Sombra sutil - Para elementos secundarios
  List<BoxShadow> get shadowSubtle;

  // Sombra media - Para cards y contenedores principales
  List<BoxShadow> get shadowMedium;

  // Sombra fuerte - Para modales y elementos flotantes
  List<BoxShadow> get shadowStrong;

  // Sombra premium - Para elementos destacados (KPI cards, hero sections)
  List<BoxShadow> get shadowPremium;

  // Sombra para hover - Efecto al pasar el mouse
  List<BoxShadow> get shadowHover;

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
      const Color(0xFF1E3A8A); // Deep Navy Blue - Premium Authority
  @override
  Color secondaryColor =
      const Color(0xFF10B981); // Emerald Green - Success & Optimization
  @override
  Color tertiaryColor =
      const Color(0xFF8B5CF6); // Premium Purple - Accent & Innovation
  @override
  Color alternate =
      const Color(0xFFF59E0B); // Amber Gold - Warnings & Attention
  @override
  Color primaryBackground =
      const Color(0xFFF8FAFC); // Ultra Light Gray - Clean Background
  @override
  Color secondaryBackground =
      const Color(0xFFFFFFFF); // Pure White - Premium Surfaces
  @override
  Color tertiaryBackground =
      const Color(0xFFE5E7EB); // Light Border - Elegant Separation
  @override
  Color transparentBackground = const Color(0xFF64748B).withOpacity(.08);
  @override
  Color primaryText = const Color(0xFF0F172A); // Deep Navy - Maximum Contrast
  @override
  Color secondaryText = const Color(0xFF475569); // Slate Gray - Secondary Info
  @override
  Color tertiaryText = const Color(0xFF94A3B8); // Light Slate - Tertiary Info
  @override
  Color hintText = const Color(0xFF94A3B8); // Placeholder Text
  @override
  Color error = const Color(0xFFDC2626); // Red - Errors & Losses
  @override
  Color warning = const Color(0xFFF59E0B); // Amber - Attention Required
  @override
  Color success = const Color(0xFF10B981); // Emerald - Success & Savings
  @override
  Color formBackground = const Color(0xFF1E3A8A).withOpacity(.05);

  /// ========================================================================
  /// SOMBRAS LIGHT MODE - Sutiles y elegantes
  /// ========================================================================
  @override
  List<BoxShadow> get shadowSubtle => [
        BoxShadow(
          color: const Color(0xFF0F172A).withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  @override
  List<BoxShadow> get shadowMedium => [
        BoxShadow(
          color: const Color(0xFF0F172A).withOpacity(0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: const Color(0xFF0F172A).withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  @override
  List<BoxShadow> get shadowStrong => [
        BoxShadow(
          color: const Color(0xFF0F172A).withOpacity(0.12),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: const Color(0xFF0F172A).withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  @override
  List<BoxShadow> get shadowPremium => [
        BoxShadow(
          color: const Color(0xFF1E3A8A).withOpacity(0.15),
          blurRadius: 32,
          offset: const Offset(0, 12),
          spreadRadius: 2,
        ),
        BoxShadow(
          color: const Color(0xFF0F172A).withOpacity(0.08),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];

  @override
  List<BoxShadow> get shadowHover => [
        BoxShadow(
          color: const Color(0xFF1E3A8A).withOpacity(0.2),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

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
      const Color(0xFF3B82F6); // Bright Blue - Bloomberg Terminal Inspired
  @override
  Color secondaryColor =
      const Color(0xFF34D399); // Light Emerald - Success Glow
  @override
  Color tertiaryColor =
      const Color(0xFFA78BFA); // Light Purple - Premium Accent
  @override
  Color alternate = const Color(0xFFFBBF24); // Gold Amber - Attention
  @override
  Color primaryBackground =
      const Color(0xFF0F172A); // Deep Navy Night - Premium Dark
  @override
  Color secondaryBackground =
      const Color(0xFF1E293B); // Slate Surface - Elevated Cards
  @override
  Color tertiaryBackground =
      const Color(0xFF334155); // Dark Border - Elegant Division
  @override
  Color transparentBackground = const Color(0xFF334155).withOpacity(.5);
  @override
  Color primaryText = const Color(0xFFF1F5F9); // Off-White - Perfect Contrast
  @override
  Color secondaryText = const Color(0xFF94A3B8); // Light Slate - Readable
  @override
  Color tertiaryText = const Color(0xFF64748B); // Muted Slate - Subtle Info
  @override
  Color hintText = const Color(0xFF64748B); // Placeholder Dark
  @override
  Color error = const Color(0xFFF87171); // Light Red - Clear Error
  @override
  Color warning = const Color(0xFFFBBF24); // Gold Amber - High Visibility
  @override
  Color success = const Color(0xFF34D399); // Emerald Glow - Achievement

  /// ========================================================================
  /// SOMBRAS DARK MODE - NEGRAS PROFUNDAS para crear profundidad real
  /// ========================================================================
  /// Inspirado en Bloomberg Terminal y diseños premium de alto contraste
  /// Las sombras DEBEN ser más oscuras que el fondo, no más claras
  /// ========================================================================

  @override
  List<BoxShadow> get shadowSubtle => [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
      ];

  @override
  List<BoxShadow> get shadowMedium => [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ];

  @override
  List<BoxShadow> get shadowStrong => [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 28,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ];

  @override
  List<BoxShadow> get shadowPremium => [
        BoxShadow(
          color: Colors.black.withOpacity(0.6),
          blurRadius: 36,
          offset: const Offset(0, 12),
          spreadRadius: 2,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
        // Sutil glow azul para efecto premium
        BoxShadow(
          color: const Color(0xFF3B82F6).withOpacity(0.1),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  @override
  List<BoxShadow> get shadowHover => [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
        // Glow azul en hover
        BoxShadow(
          color: const Color(0xFF3B82F6).withOpacity(0.15),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ];

  @override
  ThemeExtension<AppTheme> copyWith() => DarkModeTheme();

  @override
  ThemeExtension<AppTheme> lerp(ThemeExtension<AppTheme>? other, double t) {
    if (other is! DarkModeTheme) return this;
    return this;
  }

  @override
  Color formBackground = const Color(0xFF3B82F6).withOpacity(.08);
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
