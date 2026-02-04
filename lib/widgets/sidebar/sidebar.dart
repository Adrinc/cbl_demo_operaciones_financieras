import 'package:flutter/material.dart';
import 'package:facturacion_demo/widgets/sidebar/sidebar_item.dart';
import 'package:facturacion_demo/helpers/constants.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';

/// ============================================================================
/// SIDEBAR
/// ============================================================================
/// Sidebar para desktop con logo ARUX, navegación y botón de salida
/// Colapsable para más espacio
/// ============================================================================
class Sidebar extends StatelessWidget {
  final bool isCollapsed;
  final VoidCallback onToggleCollapse;

  const Sidebar({
    super.key,
    required this.isCollapsed,
    required this.onToggleCollapse,
  });

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: isCollapsed ? 80 : 260,
      decoration: BoxDecoration(
        color: theme.surface,
        border: Border(
          right: BorderSide(
            color: theme.border,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.textPrimary.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo + Collapse button
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.border,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isCollapsed) ...[
                  // Logo ARUX
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: theme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'A',
                            style: TextStyle(
                              fontSize: 20,
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  // Logo colapsado
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: theme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'A',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
                // Collapse button
                IconButton(
                  icon: Icon(
                    isCollapsed ? Icons.chevron_right : Icons.chevron_left,
                    color: theme.textSecondary,
                    size: 20,
                  ),
                  onPressed: onToggleCollapse,
                  tooltip: isCollapsed ? 'Expandir' : 'Colapsar',
                ),
              ],
            ),
          ),

          // Navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                SidebarItem(
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  route: Routes.dashboard,
                  isCollapsed: isCollapsed,
                ),
                SidebarItem(
                  icon: Icons.receipt_long_outlined,
                  label: 'Facturas',
                  route: Routes.facturas,
                  isCollapsed: isCollapsed,
                ),
                SidebarItem(
                  icon: Icons.analytics_outlined,
                  label: 'Optimización',
                  route: Routes.optimizacion,
                  isCollapsed: isCollapsed,
                ),
                SidebarItem(
                  icon: Icons.calculate_outlined,
                  label: 'Simulador',
                  route: Routes.simulador,
                  isCollapsed: isCollapsed,
                ),
                SidebarItem(
                  icon: Icons.verified_outlined,
                  label: 'Validaciones',
                  route: Routes.validaciones,
                  isCollapsed: isCollapsed,
                ),
                SidebarItem(
                  icon: Icons.business_outlined,
                  label: 'Proveedores',
                  route: Routes.proveedores,
                  isCollapsed: isCollapsed,
                ),
                SidebarItem(
                  icon: Icons.assessment_outlined,
                  label: 'Reportes',
                  route: Routes.reportes,
                  isCollapsed: isCollapsed,
                ),
                SidebarItem(
                  icon: Icons.settings_outlined,
                  label: 'Configuración',
                  route: Routes.configuracion,
                  isCollapsed: isCollapsed,
                ),
              ],
            ),
          ),

          // Exit button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: theme.border,
                  width: 1,
                ),
              ),
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _launchURL('https://cbluna.com/'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        size: 20,
                        color: theme.error,
                      ),
                      if (!isCollapsed) ...[
                        const SizedBox(width: 8),
                        Text(
                          'Salir de la Demo',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
