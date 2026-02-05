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
            color: theme.border.withOpacity(0.5),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo + Collapse button
          Container(
            height: 70,
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 8 : 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.primary.withOpacity(0.08),
                  theme.primary.withOpacity(0.02),
                ],
              ),
              border: Border(
                bottom: BorderSide(
                  color: theme.border.withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
            child: isCollapsed
                // Colapsado: solo logo centrado, botón debajo
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.primary.withOpacity(0.2),
                              theme.primary.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: theme.primary.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/favicon.png',
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  )
                // Expandido: Row con logo + texto + botón
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo ARXIS
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  theme.primary.withOpacity(0.2),
                                  theme.primary.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: theme.primary.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/favicon.png',
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                theme.primary,
                                theme.primary.withOpacity(0.8),
                              ],
                            ).createShader(bounds),
                            child: Text(
                              appName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Collapse button
                      Container(
                        decoration: BoxDecoration(
                          color: theme.border.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.chevron_left,
                            color: theme.textSecondary,
                            size: 20,
                          ),
                          onPressed: onToggleCollapse,
                          tooltip: 'Colapsar',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 28,
                            minHeight: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),

          // Botón expandir (solo visible cuando está colapsado)
          if (isCollapsed)
            GestureDetector(
              onTap: onToggleCollapse,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: theme.border.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.chevron_right,
                  color: theme.textSecondary,
                  size: 20,
                ),
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
                  color: theme.border.withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _launchURL('https://cbluna.com/'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.error.withOpacity(0.15),
                        theme.error.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: theme.error.withOpacity(0.5),
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
                        const SizedBox(width: 10),
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
