import 'package:flutter/material.dart';
import 'package:facturacion_demo/pages/dashboard/widgets/kpi_cards_section.dart';
import 'package:facturacion_demo/pages/dashboard/widgets/savings_chart.dart';
import 'package:facturacion_demo/pages/dashboard/widgets/invoices_status_chart.dart';
import 'package:facturacion_demo/pages/dashboard/widgets/alerts_widget.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// DASHBOARD PAGE
/// ============================================================================
/// Página principal con KPIs, gráficos y alertas del sistema
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
          // KPI Cards
          const KPICardsSection(),

          const SizedBox(height: 24),

          // Alertas
          const AlertsWidget(),

          const SizedBox(height: 24),

          // Gráficos
          if (isMobile) ...[
            // Mobile: stacked vertically
            const SavingsChart(),
            const SizedBox(height: 24),
            const InvoicesStatusChart(),
          ] else ...[
            // Desktop: side by side
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  flex: 2,
                  child: SavingsChart(),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: const InvoicesStatusChart(),
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
