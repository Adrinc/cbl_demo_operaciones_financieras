import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';
import 'package:facturacion_demo/providers/factura_provider.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// INVOICES STATUS CHART - Dashboard
/// ============================================================================
/// Gráfico de dona que muestra la distribución de facturas por estado
/// ============================================================================

class InvoicesStatusChart extends StatelessWidget {
  const InvoicesStatusChart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final facturaProvider = context.watch<FacturaProvider>();
    final isMobile = MediaQuery.of(context).size.width < mobileSize;

    final counts = facturaProvider.getFacturasCountByEstado();

    final chartData = [
      _ChartData(
        'Pendientes',
        counts[EstadoFactura.pendiente]?.toDouble() ?? 0,
        const Color(0xFFF59E0B),
      ),
      _ChartData(
        'Pagadas',
        counts[EstadoFactura.pagada]?.toDouble() ?? 0,
        const Color(0xFF10B981),
      ),
      _ChartData(
        'Vencidas',
        counts[EstadoFactura.vencida]?.toDouble() ?? 0,
        const Color(0xFFEF4444),
      ),
      _ChartData(
        'Canceladas',
        counts[EstadoFactura.cancelada]?.toDouble() ?? 0,
        const Color(0xFF94A3B8),
      ),
    ];

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con icono
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
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
                  ),
                ),
                child: Icon(
                  Icons.pie_chart_outline,
                  color: theme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Facturas por Estado',
                  style: theme.subtitle2.override(
                    fontFamily: theme.subtitle2Family,
                    fontSize: isMobile ? 16 : 20,
                    fontWeight: FontWeight.w600,
                    color: theme.primaryText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: isMobile ? 250 : 300,
            child: SfCircularChart(
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                overflowMode: LegendItemOverflowMode.wrap,
                textStyle: TextStyle(
                  color: theme.textSecondary,
                  fontSize: isMobile ? 10 : 12,
                ),
              ),
              series: <CircularSeries>[
                DoughnutSeries<_ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (_ChartData data, _) => data.categoria,
                  yValueMapper: (_ChartData data, _) => data.valor,
                  pointColorMapper: (_ChartData data, _) => data.color,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    connectorLineSettings: ConnectorLineSettings(
                      color: theme.textSecondary.withOpacity(0.5),
                      width: 1,
                    ),
                    textStyle: TextStyle(
                      color: theme.textPrimary,
                      fontSize: isMobile ? 10 : 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  dataLabelMapper: (_ChartData data, _) =>
                      '${data.valor.toInt()}',
                  innerRadius: '60%',
                  explode: true,
                  explodeOffset: '3%',
                  strokeColor: theme.surface,
                  strokeWidth: 2,
                ),
              ],
              tooltipBehavior: TooltipBehavior(
                enable: true,
                color: theme.surface,
                textStyle: TextStyle(color: theme.textPrimary),
                format: 'point.x: point.y facturas',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.categoria, this.valor, this.color);
  final String categoria;
  final double valor;
  final Color color;
}
