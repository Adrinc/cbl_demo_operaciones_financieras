import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:facturacion_demo/models/models.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/data/mock_data.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// SAVINGS BY SUPPLIER CHART
/// ============================================================================
/// Chart de barras horizontales (Syncfusion) mostrando ahorro por proveedor
/// Top 10 proveedores con mayor ahorro generado
/// ============================================================================
class SavingsBySupplierChart extends StatelessWidget {
  final List<Pago> pagos;
  final List<Proveedor> proveedores;

  const SavingsBySupplierChart({
    super.key,
    required this.pagos,
    required this.proveedores,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;

    // Agrupar ahorro por proveedor (usando facturas)
    final Map<String, double> ahorrosPorProveedor = {};

    for (final pago in pagos) {
      if (pago.estado == EstadoPago.ejecutado) {
        // Obtener facturas del pago
        for (final facturaId in pago.facturaIds) {
          final factura = mockFacturas.firstWhere(
            (f) => f.id == facturaId,
            orElse: () => mockFacturas.first,
          );

          final proveedorNombre = factura.proveedorNombre;
          final ahorroPorFactura = pago.ahorroGenerado / pago.facturaIds.length;

          ahorrosPorProveedor[proveedorNombre] =
              (ahorrosPorProveedor[proveedorNombre] ?? 0.0) + ahorroPorFactura;
        }
      }
    }

    // Ordenar y tomar top 10
    final sortedProveedores = ahorrosPorProveedor.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final top10 = sortedProveedores.take(10).toList();

    // Crear serie de datos
    final List<_ChartData> chartData = top10.map((entry) {
      return _ChartData(
        proveedor: entry.key.length > 18
            ? '${entry.key.substring(0, 18)}...'
            : entry.key,
        ahorro: entry.value,
      );
    }).toList();

    if (chartData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.business, size: 64, color: theme.textSecondary),
            const SizedBox(height: 16),
            Text(
              'No hay datos de ahorro por proveedor',
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
        labelRotation: -45,
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
      tooltipBehavior: TooltipBehavior(
        enable: true,
        format: 'point.x : point.y',
        textStyle: TextStyle(color: Colors.white, fontSize: 12),
        color: theme.secondary.withOpacity(0.9),
        borderColor: theme.secondary,
        borderWidth: 2,
      ),
      series: <CartesianSeries<_ChartData, String>>[
        BarSeries<_ChartData, String>(
          dataSource: chartData,
          xValueMapper: (_ChartData data, _) => data.proveedor,
          yValueMapper: (_ChartData data, _) => data.ahorro,
          name: 'Ahorro',
          color: theme.secondary,
          gradient: LinearGradient(
            colors: [
              theme.secondary.withOpacity(0.7),
              theme.secondary,
            ],
          ),
          borderRadius: BorderRadius.circular(4),
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.outer,
            textStyle: TextStyle(
              color: theme.textPrimary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
            builder: (dynamic data, dynamic point, dynamic series,
                int pointIndex, int seriesIndex) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.secondary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '\$ ${(data.ahorro / 1000).toStringAsFixed(1)}K',
                  style: TextStyle(
                    color: theme.secondary,
                    fontSize: 9,
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
}

class _ChartData {
  final String proveedor;
  final double ahorro;

  _ChartData({required this.proveedor, required this.ahorro});
}
