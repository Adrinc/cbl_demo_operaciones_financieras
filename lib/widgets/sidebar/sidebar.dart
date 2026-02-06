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
        color: theme.primaryBackground,
        border: Border(
          right: BorderSide(
            color: theme.border.withOpacity(0.3),
            width: 1,
          ),
        ),
        // 🔥 SOMBRAS PREMIUM - Profundidad real en dark mode
        boxShadow: [
          ...theme.shadowStrong,
        ],
      ),
      child: Column(
        children: [
          // Logo + Collapse button
          Container(
            constraints: const BoxConstraints(
              minHeight: 60,
              maxHeight: 70,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 8 : 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.surface,
                  theme.surface.withOpacity(0.95),
                ],
              ),
              border: Border(
                bottom: BorderSide(
                  color: theme.border.withOpacity(0.3),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : theme.textPrimary)
                      .withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
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
                      // Collapse button mejorado
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                theme.primary.withOpacity(0.15),
                                theme.primary.withOpacity(0.08),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: theme.primary.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.chevron_left,
                              color: theme.primary,
                              size: 20,
                            ),
                            onPressed: onToggleCollapse,
                            tooltip: 'Colapsar',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),

          // Botón expandir (solo visible cuando está colapsado) - Mejorado
          if (isCollapsed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onToggleCollapse,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.primary.withOpacity(0.15),
                          theme.primary.withOpacity(0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.primary.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primary.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.chevron_right,
                      color: theme.primary,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),

          // Navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              physics: const ClampingScrollPhysics(),
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

          // Exit button - Premium design
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.primaryBackground.withOpacity(0.5),
                  theme.primaryBackground,
                ],
              ),
              border: Border(
                top: BorderSide(
                  color: theme.border.withOpacity(0.5),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : theme.textPrimary)
                      .withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: _ExitButton(
              isCollapsed: isCollapsed,
              onTap: () => _launchURL('https://cbluna.com/'),
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// EXIT BUTTON - Componente premium con hover state
/// ============================================================================
class _ExitButton extends StatefulWidget {
  final bool isCollapsed;
  final VoidCallback onTap;

  const _ExitButton({
    required this.isCollapsed,
    required this.onTap,
  });

  @override
  State<_ExitButton> createState() => _ExitButtonState();
}

class _ExitButtonState extends State<_ExitButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _isHovered
                    ? [
                        theme.error.withOpacity(0.2),
                        theme.error.withOpacity(0.1),
                      ]
                    : [
                        theme.error.withOpacity(0.15),
                        theme.error.withOpacity(0.05),
                      ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.error.withOpacity(_isHovered ? 0.7 : 0.5),
                width: _isHovered ? 2 : 1,
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: theme.error.withOpacity(isDark ? 0.3 : 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: theme.error.withOpacity(isDark ? 0.15 : 0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: theme.error.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.error.withOpacity(isDark ? 0.15 : 0.1),
                    boxShadow: _isHovered
                        ? [
                            BoxShadow(
                              color: theme.error.withOpacity(0.3),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    Icons.exit_to_app,
                    size: 18,
                    color: theme.error,
                  ),
                ),
                if (!widget.isCollapsed) ...[
                  const SizedBox(width: 10),
                  Text(
                    'Salir de la Demo',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.error,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
