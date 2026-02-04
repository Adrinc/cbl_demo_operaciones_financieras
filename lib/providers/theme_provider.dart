import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ============================================================================
/// THEME PROVIDER
/// ============================================================================
/// Gestiona el tema de la aplicación (Light/Dark mode) con persistencia
/// ============================================================================
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = '__theme_mode__';
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Constructor que carga el tema guardado
  ThemeProvider() {
    _loadTheme();
  }

  /// Carga el tema desde SharedPreferences
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_themeKey) ?? false;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    } catch (e) {
      // Si falla, usa el tema por defecto (light)
      _themeMode = ThemeMode.light;
    }
  }

  /// Alterna entre Light y Dark mode
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    await _saveTheme();
  }

  /// Establece un tema específico
  Future<void> setTheme(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
      await _saveTheme();
    }
  }

  /// Guarda el tema en SharedPreferences
  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _themeMode == ThemeMode.dark);
    } catch (e) {
      // Error al guardar, pero no afecta funcionalidad
      debugPrint('Error guardando tema: $e');
    }
  }
}
