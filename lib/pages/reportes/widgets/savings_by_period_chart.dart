import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:facturacion_demo/models/models.dart';
import 'package:facturacion_demo/theme/theme.dart';

/// ============================================================================
/// SAVINGS BY PERIOD CHART
/// ============================================================================
/// Chart de área (Syncfusion) mostrando ahorro generado por período
/// Agrupado por mes con CategoryAxis
/// ============================================================================
class SavingsByPeriodChart extends StatelessWidget {
  final List<Pago> pagos;
  final DateTimeRange dateRange;

  const SavingsByPeriodChart({
    super.key,
    required this.pagos,
    required this.dateRange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;

    // Agrupar pagos por mes (solo los que tienen fechaEjecucion)
    final Map<String, double> ahorrosPorMes = {};

    for (final pago in pagos) {
      if (pago.fechaEjecucion != null) {
        final fecha = pago.fechaEjecucion!;
        // Verificar que está dentro del rango (inclusive)
        if ((fecha.isAfter(dateRange.start) ||
                fecha.isAtSameMomentAs(dateRange.start)) &&
            (fecha.isBefore(dateRange.end) ||
                fecha.isAtSameMomentAs(dateRange.end))) {
          // Usar string "Mes YYYY" como key
          final mesKey = '${_getMonthName(fecha.month)} ${fecha.year}';
          ahorrosPorMes[mesKey] =
              (ahorrosPorMes[mesKey] ?? 0.0) + pago.ahorroGenerado;
        }
      }
    }

    // Si no hay datos, mostrar mensaje
    if (ahorrosPorMes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.show_chart, size: 64, color: theme.textSecondary),
            const SizedBox(height: 16),
            Text(
              'No hay datos de ahorro para el período seleccionado',
              style: TextStyle(
                color: theme.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    // Crear serie de datos
    final List<_ChartData> chartData = ahorrosPorMes.entries.map((entry) {
      return _ChartData(
        mes: entry.key,
        ahorro: entry.value,
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(12),
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
          // Header
          Row(
            children: [
              Icon(Icons.trending_up, color: theme.success, size: 24),
              const SizedBox(width: 12),
              Text(
                'Ahorro por Período',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Chart
          Expanded(
            child: SfCartesianChart(
              backgroundColor: Colors.transparent,
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                labelStyle: TextStyle(
                  color: theme.textSecondary,
                  fontSize: 12,
                ),
                axisLine: AxisLine(color: theme.border, width: 1),
              ),
              primaryYAxis: NumericAxis(
                numberFormat: intl.NumberFormat.simpleCurrency(name: 'USD'),
                majorGridLines: MajorGridLines(
                  color: theme.border.withOpacity(0.3),
                  width: 1,
                ),
                labelStyle: TextStyle(
                  color: theme.textSecondary,
                  fontSize: 11,
                ),
                axisLine: const AxisLine(width: 0),
              ),
              tooltipBehavior: TooltipBehavior(
                enable: true,
                format: 'point.x: point.y',
                header: '',
                canShowMarker: true,
              ),
              series: <CartesianSeries<_ChartData, String>>[
                AreaSeries<_ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (_ChartData data, _) => data.mes,
                  yValueMapper: (_ChartData data, _) => data.ahorro,
                  name: 'Ahorro',
                  color: theme.success.withOpacity(0.3),
                  borderColor: theme.success,
                  borderWidth: 3,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    height: 8,
                    width: 8,
                    shape: DataMarkerType.circle,
                    borderWidth: 2,
                    borderColor: theme.success,
                    color: theme.surface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];
    return months[month - 1];
  }
}

/// ============================================================================
/// CHART DATA MODEL
/// ============================================================================
class _ChartData {
  final String mes;
  final double ahorro;

  _ChartData({
    required this.mes,
    required this.ahorro,
  });
}
