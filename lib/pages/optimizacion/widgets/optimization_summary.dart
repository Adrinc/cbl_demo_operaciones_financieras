import 'package:flutter/material.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/functions/money_format.dart';

/// ============================================================================
/// OPTIMIZATION SUMMARY WIDGET
/// ============================================================================
/// Panel de resumen con cálculos en tiempo real de la optimización
/// Muestra totales, ahorros y comparación antes/después
/// ============================================================================
class OptimizationSummary extends StatelessWidget {
  final int cantidadSeleccionada;
  final double montoTotal;
  final double ahorroTotal;
  final double montoFinal;

  const OptimizationSummary({
    super.key,
    required this.cantidadSeleccionada,
    required this.montoTotal,
    required this.ahorroTotal,
    required this.montoFinal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 768;

    final porcentajeAhorro =
        montoTotal > 0 ? (ahorroTotal / montoTotal) * 100 : 0.0;

    return Container(
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
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.secondary.withOpacity(0.15),
                  theme.secondary.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.savings,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resumen de Optimización',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cantidadSeleccionada == 0
                            ? 'Selecciona facturas para optimizar'
                            : '$cantidadSeleccionada ${cantidadSeleccionada == 1 ? 'factura seleccionada' : 'facturas seleccionadas'}',
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: cantidadSeleccionada == 0
                ? _buildEmptyState(theme)
                : Column(
                    children: [
                      // Monto original
                      _buildSummaryRow(
                        icon: Icons.receipt,
                        label: 'Monto Original',
                        value: moneyFormat(montoTotal),
                        valueColor: theme.textPrimary,
                        theme: theme,
                        isBold: true,
                      ),
                      const SizedBox(height: 16),

                      // Divider con flecha
                      Row(
                        children: [
                          Expanded(child: Divider(color: theme.border)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(
                              Icons.arrow_downward,
                              color: theme.success,
                              size: 20,
                            ),
                          ),
                          Expanded(child: Divider(color: theme.border)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Ahorro DPP
                      _buildSummaryRow(
                        icon: Icons.trending_down,
                        label: 'Ahorro DPP',
                        value: '- ${moneyFormat(ahorroTotal)}',
                        valueColor: theme.success,
                        theme: theme,
                        isBold: true,
                        showPercentage: true,
                        percentage: porcentajeAhorro,
                      ),
                      const SizedBox(height: 16),

                      // Divider
                      Divider(color: theme.border, thickness: 2),
                      const SizedBox(height: 16),

                      // Monto final optimizado
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.primary.withOpacity(0.1),
                              theme.secondary.withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: theme.primary.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: theme.primary,
                              size: 32,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Monto Final Optimizado',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: theme.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    moneyFormat(montoFinal),
                                    style: TextStyle(
                                      fontSize: isMobile ? 20 : 24,
                                      fontWeight: FontWeight.bold,
                                      color: theme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Comparación visual
                      _buildComparisonBar(theme),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppTheme theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Icon(
              Icons.touch_app,
              size: 64,
              color: theme.textSecondary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Selecciona facturas pendientes\npara ver el resumen de optimización',
              style: TextStyle(
                fontSize: 14,
                color: theme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
    required AppTheme theme,
    bool isBold = false,
    bool showPercentage = false,
    double percentage = 0.0,
  }) {
    return Row(
      children: [
        Icon(icon, color: theme.textSecondary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: theme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: isBold ? 18 : 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: valueColor,
              ),
            ),
            if (showPercentage && percentage > 0)
              Text(
                '${percentage.toStringAsFixed(2)}%',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.success,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildComparisonBar(AppTheme theme) {
    final progressValue = montoTotal > 0 ? montoFinal / montoTotal : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comparación Visual',
          style: TextStyle(
            fontSize: 13,
            color: theme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        // Barra original (100%)
        Container(
          height: 32,
          decoration: BoxDecoration(
            color: theme.error.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.error.withOpacity(0.3)),
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Sin optimizar',
            style: TextStyle(
              fontSize: 12,
              color: theme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Barra optimizada (reducida)
        Container(
          height: 32,
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.primaryBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.border),
          ),
          child: FractionallySizedBox(
            widthFactor: progressValue.clamp(0.0, 1.0),
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.success, theme.secondary],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Optimizado',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
