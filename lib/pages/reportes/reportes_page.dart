import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facturacion_demo/providers/pago_provider.dart';
import 'package:facturacion_demo/providers/proveedor_provider.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/helpers/constants.dart';
import 'package:facturacion_demo/functions/money_format.dart';
import 'package:facturacion_demo/pages/reportes/widgets/savings_by_period_chart.dart';
import 'package:facturacion_demo/pages/reportes/widgets/savings_by_supplier_chart.dart';
import 'package:facturacion_demo/pages/reportes/widgets/monthly_comparison_chart.dart';

/// ============================================================================
/// REPORTES Y AHORRO PAGE
/// ============================================================================
/// Visualización de reportes y análisis de ahorro
/// Charts Syncfusion: line, bar, donut
/// ============================================================================
class ReportesPage extends StatefulWidget {
  const ReportesPage({super.key});

  @override
  State<ReportesPage> createState() => _ReportesPageState();
}

class _ReportesPageState extends State<ReportesPage> {
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime(2026, 1, 1),
    end: DateTime(2026, 12, 31),
  );
  List<String> _selectedProveedorIds = [];
  String _filterEsquema = 'todos';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final pagoProvider = context.watch<PagoProvider>();
    final proveedorProvider = context.watch<ProveedorProvider>();
    final isMobile = MediaQuery.of(context).size.width <= mobileSize;

    // Calcular totales
    final pagosEjecutados = pagoProvider.pagos
        .where((p) => p.estado == EstadoPago.ejecutado)
        .toList();

    final ahorroTotal = pagosEjecutados.fold<double>(
      0.0,
      (sum, pago) => sum + pago.ahorroGenerado,
    );

    final montoTotal = pagosEjecutados.fold<double>(
      0.0,
      (sum, pago) => sum + pago.montoTotal,
    );

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con estadísticas generales
            _buildStatsHeader(theme, ahorroTotal, montoTotal,
                pagosEjecutados.length, isMobile),
            const SizedBox(height: 24),

            // Filtros
            _buildFilters(theme, proveedorProvider, isMobile),
            const SizedBox(height: 24),

            // Charts Grid
            if (isMobile)
              Column(
                children: [
                  _buildChartCard(
                    title: 'Ahorro por Período',
                    child: SavingsByPeriodChart(
                      pagos: pagosEjecutados,
                      dateRange: _dateRange,
                    ),
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                  _buildChartCard(
                    title: 'Ahorro por Proveedor',
                    child: SavingsBySupplierChart(
                      pagos: pagosEjecutados,
                      proveedores: proveedorProvider.proveedores,
                    ),
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                  _buildChartCard(
                    title: 'Comparativa Mensual',
                    child: MonthlyComparisonChart(
                      pagos: pagosEjecutados,
                    ),
                    theme: theme,
                  ),
                ],
              )
            else
              Column(
                children: [
                  // Row 1: Ahorro por período (full width)
                  _buildChartCard(
                    title: 'Ahorro por Período',
                    child: SavingsByPeriodChart(
                      pagos: pagosEjecutados,
                      dateRange: _dateRange,
                    ),
                    theme: theme,
                  ),
                  const SizedBox(height: 16),

                  // Row 2: Two charts side by side
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildChartCard(
                          title: 'Ahorro por Proveedor',
                          child: SavingsBySupplierChart(
                            pagos: pagosEjecutados,
                            proveedores: proveedorProvider.proveedores,
                          ),
                          theme: theme,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildChartCard(
                          title: 'Comparativa Mensual',
                          child: MonthlyComparisonChart(
                            pagos: pagosEjecutados,
                          ),
                          theme: theme,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            const SizedBox(height: 24),

            // Export buttons
            _buildExportButtons(theme, isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsHeader(AppTheme theme, double ahorroTotal,
      double montoTotal, int cantidadPagos, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primary, theme.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics,
                color: Colors.white,
                size: isMobile ? 28 : 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isMobile
                      ? 'Reportes y Análisis de Ahorro'
                      : 'Reportes y Análisis de Ahorro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 18 : 24,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 24,
            runSpacing: 16,
            children: [
              _buildStatItem(
                'Ahorro Total Generado',
                moneyFormat(ahorroTotal),
                Icons.savings,
                Colors.white,
              ),
              _buildStatItem(
                'Monto Total Procesado',
                moneyFormat(montoTotal),
                Icons.account_balance_wallet,
                Colors.white,
              ),
              _buildStatItem(
                'Pagos Ejecutados',
                cantidadPagos.toString(),
                Icons.check_circle,
                Colors.white,
              ),
              _buildStatItem(
                'Porcentaje de Ahorro',
                '${((ahorroTotal / montoTotal) * 100).toStringAsFixed(2)} %',
                Icons.trending_up,
                Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color.withOpacity(0.9), size: 20),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: color.withOpacity(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilters(
      AppTheme theme, ProveedorProvider proveedorProvider, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Row(
            children: [
              Icon(Icons.filter_list, color: theme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Filtros de Reporte',
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              // Rango de fechas
              ElevatedButton.icon(
                onPressed: () => _selectDateRange(context, theme),
                icon: Icon(Icons.date_range, size: 18),
                label: Text(
                  isMobile
                      ? '${_dateRange.start.day}/${_dateRange.start.month} - ${_dateRange.end.day}/${_dateRange.end.month}/26'
                      : '${_dateRange.start.day}/${_dateRange.start.month}/${_dateRange.start.year} - ${_dateRange.end.day}/${_dateRange.end.month}/${_dateRange.end.year}',
                  style: TextStyle(fontSize: isMobile ? 12 : 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryBackground,
                  foregroundColor: theme.textPrimary,
                  side: BorderSide(color: theme.border),
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 16,
                    vertical: isMobile ? 10 : 12,
                  ),
                ),
              ),

              // Filtro de esquema
              DropdownButton<String>(
                value: _filterEsquema,
                onChanged: (value) => setState(() => _filterEsquema = value!),
                items: [
                  DropdownMenuItem(
                      value: 'todos', child: Text('Todos los esquemas')),
                  DropdownMenuItem(
                      value: EsquemaPago.push, child: Text('PUSH NC-Pago')),
                  DropdownMenuItem(
                      value: EsquemaPago.pull, child: Text('PULL NC-Pago')),
                ],
                underline: Container(),
                style: TextStyle(color: theme.textPrimary, fontSize: 14),
              ),

              // Reset filters
              IconButton(
                onPressed: () {
                  setState(() {
                    _dateRange = DateTimeRange(
                      start: DateTime(2026, 1, 1),
                      end: DateTime(2026, 12, 31),
                    );
                    _selectedProveedorIds = [];
                    _filterEsquema = 'todos';
                  });
                },
                icon: Icon(Icons.refresh, color: theme.textSecondary),
                tooltip: 'Resetear filtros',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required Widget child,
    required AppTheme theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Text(
            title,
            style: TextStyle(
              color: theme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 350,
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildExportButtons(AppTheme theme, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              Icon(Icons.download, color: theme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Exportar Reportes',
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed: () => _handleExport('PDF', theme),
                icon: Icon(Icons.picture_as_pdf, size: 18),
                label: Text('Exportar PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.error,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _handleExport('Excel', theme),
                icon: Icon(Icons.table_chart, size: 18),
                label: Text('Exportar Excel'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.success,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _handleExport('CSV', theme),
                icon: Icon(Icons.insert_drive_file, size: 18),
                label: Text('Exportar CSV'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _selectDateRange(BuildContext context, AppTheme theme) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2026, 1, 1),
      lastDate: DateTime(2026, 12, 31),
      initialDateRange: _dateRange,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: theme.primary,
            colorScheme: ColorScheme.light(primary: theme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _dateRange) {
      setState(() => _dateRange = picked);
    }
  }

  void _handleExport(String format, AppTheme theme) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                  'Exportación simulada: Reporte generado en formato $format'),
            ),
          ],
        ),
        backgroundColor: theme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
