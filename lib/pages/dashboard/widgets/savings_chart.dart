import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:facturacion_demo/providers/pago_provider.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// SAVINGS CHART - Dashboard
/// ============================================================================
/// Gráfico de línea que muestra la tendencia de ahorro a lo largo del tiempo
/// ============================================================================

class SavingsChart extends StatelessWidget {
  const SavingsChart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final pagoProvider = context.watch<PagoProvider>();
    final isMobile = MediaQuery.of(context).size.width < mobileSize;

    // Agrupar pagos por mes
    final pagosEjecutados = pagoProvider.getPagosEjecutados();
    final Map<int, double> ahorrosPorMes = {};

    for (var pago in pagosEjecutados) {
      if (pago.fechaEjecucion != null) {
        final mes = pago.fechaEjecucion!.month;
        ahorrosPorMes[mes] = (ahorrosPorMes[mes] ?? 0) + pago.ahorroGenerado;
      }
    }

    // Crear datos acumulativos con variación realista para DEMO
    final chartData = <_ChartData>[];
    double acumulado = 0;
    final variaciones = [
      1.0,
      1.8,
      2.2,
      3.5,
      4.1,
      5.3,
      6.2,
      7.8,
      9.1,
      10.5,
      11.2,
      12.0
    ];

    for (int mes = 1; mes <= 12; mes++) {
      // Si hay datos reales, usarlos; si no, simular crecimiento
      acumulado +=
          (ahorrosPorMes[mes] ?? (acumulado * 0.15 * variaciones[mes - 1]));
      chartData.add(_ChartData(_nombreMes(mes), acumulado));
    }

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.success.withOpacity(0.3),
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
                      theme.success.withOpacity(0.2),
                      theme.success.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: theme.success.withOpacity(0.3),
                  ),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: theme.success,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tendencia de Ahorro Acumulado',
                  style: theme.subtitle2.override(
                    fontFamily: theme.subtitle2Family,
                    fontSize: isMobile ? 14 : 20,
                    fontWeight: FontWeight.w600,
                    color: theme.primaryText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: isMobile ? 250 : 300,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                labelStyle: TextStyle(
                  color: theme.textSecondary,
                  fontSize: isMobile ? 10 : 12,
                ),
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: AxisLine(color: theme.border),
              ),
              primaryYAxis: NumericAxis(
                labelStyle: TextStyle(
                  color: theme.textSecondary,
                  fontSize: isMobile ? 10 : 12,
                ),
                numberFormat: NumberFormat.currency(
                  symbol: '\$',
                  decimalDigits: 0,
                ),
                majorGridLines: MajorGridLines(
                  color: theme.border.withOpacity(0.5),
                  dashArray: const <double>[5, 5],
                ),
                axisLine: const AxisLine(width: 0),
              ),
              series: <CartesianSeries<_ChartData, String>>[
                AreaSeries<_ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (_ChartData data, _) => data.mes,
                  yValueMapper: (_ChartData data, _) => data.ahorro,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.success.withOpacity(0.4),
                      theme.success.withOpacity(0.05),
                    ],
                  ),
                  borderColor: theme.success,
                  borderWidth: 3,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                    color: theme.success,
                    borderColor: theme.surface,
                    borderWidth: 2,
                    width: 10,
                    height: 10,
                  ),
                ),
              ],
              tooltipBehavior: TooltipBehavior(
                enable: true,
                color: theme.surface,
                textStyle: TextStyle(color: theme.textPrimary),
                format: 'point.x: \$point.y USD',
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _nombreMes(int mes) {
    const meses = [
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
    return meses[mes - 1];
  }
}

class _ChartData {
  _ChartData(this.mes, this.ahorro);
  final String mes;
  final double ahorro;
}
