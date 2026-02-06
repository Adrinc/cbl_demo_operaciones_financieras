import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/providers/navigation_provider.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// QUICK ACTIONS SECTION
/// ============================================================================
/// Botones de acción rápida para funciones principales del dashboard
/// ============================================================================

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final isMobile = MediaQuery.of(context).size.width < mobileSize;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.border.withOpacity(0.5),
          width: 1.5, // 🔥 Borde más grueso
        ),
        // 🔥 SOMBRAS PREMIUM
        boxShadow: [
          ...theme.shadowMedium,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.primary.withOpacity(0.2),
                      theme.primary.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.bolt, color: theme.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                'Acciones Rápidas',
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (isMobile)
            // 🔥 GRID 2x2 para mobile - más limpio y organizado
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.15,
              children: [
                _buildActionButton(
                  context: context,
                  theme: theme,
                  icon: Icons.analytics,
                  title: 'Optimizar Pagos',
                  subtitle: 'Mejores oportunidades',
                  color: theme.secondary,
                  onTap: () {
                    context
                        .read<NavigationProvider>()
                        .setCurrentRoute(Routes.optimizacion);
                    context.go(Routes.optimizacion);
                  },
                ),
                _buildActionButton(
                  context: context,
                  theme: theme,
                  icon: Icons.receipt_long,
                  title: 'Ver Facturas',
                  subtitle: 'Gestiona pendientes',
                  color: theme.primary,
                  onTap: () {
                    context
                        .read<NavigationProvider>()
                        .setCurrentRoute(Routes.facturas);
                    context.go(Routes.facturas);
                  },
                ),
                _buildActionButton(
                  context: context,
                  theme: theme,
                  icon: Icons.calculate,
                  title: 'Simulador',
                  subtitle: 'Prueba estrategias',
                  color: theme.accent,
                  onTap: () {
                    context
                        .read<NavigationProvider>()
                        .setCurrentRoute(Routes.simulador);
                    context.go(Routes.simulador);
                  },
                ),
                _buildActionButton(
                  context: context,
                  theme: theme,
                  icon: Icons.assessment,
                  title: 'Reportes',
                  subtitle: 'Análisis detallado',
                  color: theme.warning,
                  onTap: () {
                    context
                        .read<NavigationProvider>()
                        .setCurrentRoute(Routes.reportes);
                    context.go(Routes.reportes);
                  },
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    theme: theme,
                    icon: Icons.analytics,
                    title: 'Optimizar Pagos',
                    subtitle: 'Encuentra las mejores oportunidades',
                    color: theme.secondary,
                    onTap: () {
                      context
                          .read<NavigationProvider>()
                          .setCurrentRoute(Routes.optimizacion);
                      context.go(Routes.optimizacion);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    theme: theme,
                    icon: Icons.receipt_long,
                    title: 'Ver Facturas',
                    subtitle: 'Gestiona facturas pendientes',
                    color: theme.primary,
                    onTap: () {
                      context
                          .read<NavigationProvider>()
                          .setCurrentRoute(Routes.facturas);
                      context.go(Routes.facturas);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    theme: theme,
                    icon: Icons.calculate,
                    title: 'Simular Escenarios',
                    subtitle: 'Prueba diferentes estrategias',
                    color: theme.accent,
                    onTap: () {
                      context
                          .read<NavigationProvider>()
                          .setCurrentRoute(Routes.simulador);
                      context.go(Routes.simulador);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    theme: theme,
                    icon: Icons.assessment,
                    title: 'Ver Reportes',
                    subtitle: 'Análisis detallado de ahorro',
                    color: theme.warning,
                    onTap: () {
                      context
                          .read<NavigationProvider>()
                          .setCurrentRoute(Routes.reportes);
                      context.go(Routes.reportes);
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required AppTheme theme,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isMobile = MediaQuery.of(context).size.width < mobileSize;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(isMobile ? 12 : 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.15),
                color.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.4),
              width: 2, // 🔥 Borde prominente en botones
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 8 : 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child:
                    Icon(icon, color: Colors.white, size: isMobile ? 22 : 28),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: isMobile ? 13 : 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: theme.textSecondary,
                  fontSize: isMobile ? 11 : 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
