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

  /// Obtiene el título de la página actual
  String getPageTitle() {
    switch (_currentRoute) {
      case Routes.dashboard:
        return 'Dashboard Financiero';
      case Routes.facturas:
        return 'Gestión de Facturas';
      case Routes.optimizacion:
        return 'Optimización de Pagos';
      case Routes.simulador:
        return 'Simulador de Escenarios';
      case Routes.validaciones:
        return 'Validación y Control';
      case Routes.proveedores:
        return 'Gestión de Proveedores';
      case Routes.reportes:
        return 'Reportes y Ahorro';
      case Routes.configuracion:
        return 'Configuración del Ejercicio';
      default:
        return 'ARXIS';
    }
  }

  /// Obtiene el ícono de la página actual
  IconData getPageIcon() {
    switch (_currentRoute) {
      case Routes.dashboard:
        return Icons.dashboard_outlined;
      case Routes.facturas:
        return Icons.receipt_long;
      case Routes.optimizacion:
        return Icons.trending_up;
      case Routes.simulador:
        return Icons.science_outlined;
      case Routes.validaciones:
        return Icons.check_circle_outline;
      case Routes.proveedores:
        return Icons.business;
      case Routes.reportes:
        return Icons.bar_chart;
      case Routes.configuracion:
        return Icons.settings;
      default:
        return Icons.error_outline;
    }
  }
}
