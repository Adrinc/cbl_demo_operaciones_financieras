import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:facturacion_demo/theme/theme.dart';
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
        border: Border.all(color: theme.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: theme.textPrimary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
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
            Column(
              children: [
                _buildActionButton(
                  context: context,
                  theme: theme,
                  icon: Icons.analytics,
                  title: 'Optimizar Pagos',
                  subtitle: 'Encuentra las mejores oportunidades',
                  color: theme.secondary,
                  onTap: () => context.go(Routes.optimizacion),
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  context: context,
                  theme: theme,
                  icon: Icons.receipt_long,
                  title: 'Ver Facturas',
                  subtitle: 'Gestiona facturas pendientes',
                  color: theme.primary,
                  onTap: () => context.go(Routes.facturas),
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  context: context,
                  theme: theme,
                  icon: Icons.calculate,
                  title: 'Simular Escenarios',
                  subtitle: 'Prueba diferentes estrategias',
                  color: theme.accent,
                  onTap: () => context.go(Routes.simulador),
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  context: context,
                  theme: theme,
                  icon: Icons.assessment,
                  title: 'Ver Reportes',
                  subtitle: 'Análisis detallado de ahorro',
                  color: theme.warning,
                  onTap: () => context.go(Routes.reportes),
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
                    onTap: () => context.go(Routes.optimizacion),
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
                    onTap: () => context.go(Routes.facturas),
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
                    onTap: () => context.go(Routes.simulador),
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
                    onTap: () => context.go(Routes.reportes),
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
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
            border: Border.all(color: color.withOpacity(0.3), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
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
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: theme.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
