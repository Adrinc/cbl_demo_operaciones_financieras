import 'package:flutter/material.dart';
import 'package:facturacion_demo/pages/dashboard/widgets/kpi_cards_section.dart';
import 'package:facturacion_demo/pages/dashboard/widgets/quick_actions_section.dart';
import 'package:facturacion_demo/pages/dashboard/widgets/savings_progress_widget.dart';
import 'package:facturacion_demo/pages/dashboard/widgets/top_opportunities_widget.dart';
import 'package:facturacion_demo/pages/dashboard/widgets/recent_activity_widget.dart';
import 'package:facturacion_demo/pages/dashboard/widgets/savings_chart.dart';
import 'package:facturacion_demo/pages/dashboard/widgets/invoices_status_chart.dart';
import 'package:facturacion_demo/pages/dashboard/widgets/alerts_widget.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// DASHBOARD PAGE
/// ============================================================================
/// Dashboard ejecutivo con KPIs, acciones rápidas, análisis y actividad
/// Vista "at a glance" del estado del negocio
/// ============================================================================

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < mobileSize;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================== SECCIÓN 1: KPIs Principales ====================
          const KPICardsSection(),
          const SizedBox(height: 24),

          // ==================== SECCIÓN 2: Progreso de Ahorro ====================
          const SavingsProgressWidget(),
          const SizedBox(height: 24),

          // ==================== SECCIÓN 3: Acciones Rápidas ====================
          const QuickActionsSection(),
          const SizedBox(height: 24),

          // ==================== SECCIÓN 4: Alertas Críticas ====================
          const AlertsWidget(),
          const SizedBox(height: 24),

          // ==================== SECCIÓN 5: Análisis y Actividad ====================
          if (isMobile) ...[
            // Mobile: Todo apilado verticalmente
            const TopOpportunitiesWidget(),
            const SizedBox(height: 24),
            const RecentActivityWidget(),
            const SizedBox(height: 24),
            const SavingsChart(),
            const SizedBox(height: 24),
            const InvoicesStatusChart(),
          ] else ...[
            // Desktop: Layout en 2 columnas
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Columna izquierda: Top Oportunidades y Actividad Reciente
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      const TopOpportunitiesWidget(),
                      const SizedBox(height: 24),
                      const RecentActivityWidget(),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // Columna derecha: Gráficos
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      const SavingsChart(),
                      const SizedBox(height: 24),
                      const InvoicesStatusChart(),
                    ],
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
