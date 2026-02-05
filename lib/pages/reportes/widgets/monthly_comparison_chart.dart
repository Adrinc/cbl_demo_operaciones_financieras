import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:facturacion_demo/models/models.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// MONTHLY COMPARISON CHART
/// ============================================================================
/// Chart de barras agrupadas (Syncfusion) comparando:
/// - Monto total pagado
/// - Ahorro generado
/// Por mes
/// ============================================================================
class MonthlyComparisonChart extends StatelessWidget {
  final List<Pago> pagos;

  const MonthlyComparisonChart({
    super.key,
    required this.pagos,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;

    // Agrupar por mes
    final Map<DateTime, double> montosPorMes = {};
    final Map<DateTime, double> ahorrosPorMes = {};

    for (final pago in pagos) {
      if (pago.fechaEjecucion != null && pago.estado == EstadoPago.ejecutado) {
        final mes =
            DateTime(pago.fechaEjecucion!.year, pago.fechaEjecucion!.month, 1);
        montosPorMes[mes] = (montosPorMes[mes] ?? 0.0) + pago.montoTotal;
        ahorrosPorMes[mes] = (ahorrosPorMes[mes] ?? 0.0) + pago.ahorroGenerado;
      }
    }

    // Ordenar por fecha
    final sortedKeys = montosPorMes.keys.toList()..sort();

    // Crear series de datos
    final List<_ChartData> chartData = sortedKeys.map((mes) {
      return _ChartData(
        mes: mes,
        monto: montosPorMes[mes]!,
        ahorro: ahorrosPorMes[mes]!,
      );
    }).toList();

    if (chartData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 64, color: theme.textSecondary),
            const SizedBox(height: 16),
            Text(
              'No hay datos de comparativa mensual',
              style: TextStyle(
                color: theme.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        axisLine: AxisLine(color: theme.border),
        labelStyle: TextStyle(
          color: theme.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: MajorGridLines(color: theme.border.withOpacity(0.3)),
        axisLine: AxisLine(color: theme.border),
        labelStyle: TextStyle(color: theme.textSecondary, fontSize: 11),
        numberFormat: intl.NumberFormat.simpleCurrency(
          name: 'USD',
          decimalDigits: 0,
        ),
      ),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        textStyle: TextStyle(
          color: theme.textPrimary,
          fontSize: 12,
        ),
        iconHeight: 12,
        iconWidth: 12,
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        format: 'point.x : point.y',
        textStyle: TextStyle(color: Colors.white, fontSize: 12),
        borderWidth: 2,
      ),
      series: <CartesianSeries<_ChartData, String>>[
        ColumnSeries<_ChartData, String>(
          dataSource: chartData,
          xValueMapper: (_ChartData data, _) => _getMonthName(data.mes),
          yValueMapper: (_ChartData data, _) => data.monto,
          name: 'Monto Total',
          color: theme.primary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.top,
            textStyle: TextStyle(
              color: theme.textPrimary,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
            builder: (dynamic data, dynamic point, dynamic series,
                int pointIndex, int seriesIndex) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  '\$ ${(data.monto / 1000).toStringAsFixed(0)}K',
                  style: TextStyle(
                    color: theme.primary,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
        ColumnSeries<_ChartData, String>(
          dataSource: chartData,
          xValueMapper: (_ChartData data, _) => _getMonthName(data.mes),
          yValueMapper: (_ChartData data, _) => data.ahorro,
          name: 'Ahorro Generado',
          color: theme.success,
          borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.top,
            textStyle: TextStyle(
              color: theme.textPrimary,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
            builder: (dynamic data, dynamic point, dynamic series,
                int pointIndex, int seriesIndex) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.success.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  '\$ ${(data.ahorro / 1000).toStringAsFixed(1)}K',
                  style: TextStyle(
                    color: theme.success,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getMonthName(DateTime date) {
    final months = [
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
    return months[date.month - 1];
  }
}

class _ChartData {
  final DateTime mes;
  final double monto;
  final double ahorro;

  _ChartData({
    required this.mes,
    required this.monto,
    required this.ahorro,
  });
}
