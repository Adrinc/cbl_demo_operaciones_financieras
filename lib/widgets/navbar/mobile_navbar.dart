import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:facturacion_demo/providers/navigation_provider.dart';
import 'package:facturacion_demo/helpers/constants.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

/// ============================================================================
/// MOBILE NAVBAR
/// ============================================================================
/// Navegación tipo drawer para dispositivos móviles
/// ============================================================================
class MobileNavbar extends StatelessWidget {
  final VoidCallback onClose;

  const MobileNavbar({
    super.key,
    required this.onClose,
  });

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.watch<NavigationProvider>();
    final theme = Theme.of(context).extension<AppTheme>()!;

    return Container(
      color: theme.surface,
      child: Column(
        children: [
          // Header con logo
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.border,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'A',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'ARUX',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  route: Routes.dashboard,
                  isActive: navigationProvider.isRouteActive(Routes.dashboard),
                  onTap: () {
                    context.go(Routes.dashboard);
                    navigationProvider.setCurrentRoute(Routes.dashboard);
                    onClose();
                  },
                ),
                _buildNavItem(
                  context,
                  icon: Icons.receipt_long_outlined,
                  label: 'Facturas',
                  route: Routes.facturas,
                  isActive: navigationProvider.isRouteActive(Routes.facturas),
                  onTap: () {
                    context.go(Routes.facturas);
                    navigationProvider.setCurrentRoute(Routes.facturas);
                    onClose();
                  },
                ),
                _buildNavItem(
                  context,
                  icon: Icons.analytics_outlined,
                  label: 'Optimización',
                  route: Routes.optimizacion,
                  isActive: navigationProvider.isRouteActive(Routes.optimizacion),
                  onTap: () {
                    context.go(Routes.optimizacion);
                    navigationProvider.setCurrentRoute(Routes.optimizacion);
                    onClose();
                  },
                ),
                _buildNavItem(
                  context,
                  icon: Icons.calculate_outlined,
                  label: 'Simulador',
                  route: Routes.simulador,
                  isActive: navigationProvider.isRouteActive(Routes.simulador),
                  onTap: () {
                    context.go(Routes.simulador);
                    navigationProvider.setCurrentRoute(Routes.simulador);
                    onClose();
                  },
                ),
                _buildNavItem(
                  context,
                  icon: Icons.verified_outlined,
                  label: 'Validaciones',
                  route: Routes.validaciones,
                  isActive: navigationProvider.isRouteActive(Routes.validaciones),
                  onTap: () {
                    context.go(Routes.validaciones);
                    navigationProvider.setCurrentRoute(Routes.validaciones);
                    onClose();
                  },
                ),
                _buildNavItem(
                  context,
                  icon: Icons.business_outlined,
                  label: 'Proveedores',
                  route: Routes.proveedores,
                  isActive: navigationProvider.isRouteActive(Routes.proveedores),
                  onTap: () {
                    context.go(Routes.proveedores);
                    navigationProvider.setCurrentRoute(Routes.proveedores);
                    onClose();
                  },
                ),
                _buildNavItem(
                  context,
                  icon: Icons.assessment_outlined,
                  label: 'Reportes',
                  route: Routes.reportes,
                  isActive: navigationProvider.isRouteActive(Routes.reportes),
                  onTap: () {
                    context.go(Routes.reportes);
                    navigationProvider.setCurrentRoute(Routes.reportes);
                    onClose();
                  },
                ),
                _buildNavItem(
                  context,
                  icon: Icons.settings_outlined,
                  label: 'Configuración',
                  route: Routes.configuracion,
                  isActive: navigationProvider.isRouteActive(Routes.configuracion),
                  onTap: () {
                    context.go(Routes.configuracion);
                    navigationProvider.setCurrentRoute(Routes.configuracion);
                    onClose();
                  },
                ),
              ],
            ),
          ),

          // Exit button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: theme.border,
                  width: 1,
                ),
              ),
            ),
            child: GestureDetector(
              onTap: () {
                onClose();
                _launchURL('https://cbluna.com/');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: theme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.error,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.exit_to_app,
                      size: 22,
                      color: theme.error,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Salir de la Demo',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: theme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context).extension<AppTheme>()!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? theme.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? theme.primary : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? theme.primary : theme.textSecondary,
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? theme.primary : theme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
