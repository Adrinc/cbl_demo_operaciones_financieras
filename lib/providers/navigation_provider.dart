import 'package:flutter/material.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// NAVIGATION PROVIDER
/// ============================================================================
/// Gestiona la navegación entre páginas y el estado de la ruta actual
/// ============================================================================
class NavigationProvider extends ChangeNotifier {
  String _currentRoute = Routes.dashboard;

  String get currentRoute => _currentRoute;

  /// Establece la ruta actual y notifica a los listeners
  void setCurrentRoute(String route) {
    if (_currentRoute != route) {
      _currentRoute = route;
      notifyListeners();
    }
  }

  /// Verifica si una ruta está activa
  bool isRouteActive(String route) {
    return _currentRoute == route;
  }
}
