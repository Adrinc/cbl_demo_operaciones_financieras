import 'package:flutter/material.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/functions/money_format.dart';

/// ============================================================================
/// IMPACT PREVIEW WIDGET
/// ============================================================================
/// Vista de impacto en tiempo real de la simulación
/// Muestra comparaciones antes/después, gráficos y métricas
/// ============================================================================
class ImpactPreview extends StatelessWidget {
  final double montoOriginal;
  final double ahorroSimulado;
  final double montoFinal;
  final double ahorroActual;
  final double diferencia;
  final double mejora;
  final int cantidadFacturas;
  final double dppPercentage;
  final int paymentDays;

  const ImpactPreview({
    super.key,
    required this.montoOriginal,
    required this.ahorroSimulado,
    required this.montoFinal,
    required this.ahorroActual,
    required this.diferencia,
    required this.mejora,
    required this.cantidadFacturas,
    required this.dppPercentage,
    required this.paymentDays,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 768;

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
          // Header con indicador de simulación activa
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.secondary.withOpacity(0.2),
                  theme.success.withOpacity(0.1),
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.success,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vista Previa del Impacto',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$cantidadFacturas facturas analizadas',
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Indicador pulsante
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: theme.success,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.success.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Comparación de ahorros
                _buildComparisonSection(theme, isMobile),
                const SizedBox(height: 24),

                // Métricas principales
                _buildMetricsGrid(theme, isMobile),
                const SizedBox(height: 24),

                // Barra de progreso visual
                _buildProgressBar(theme),
                const SizedBox(height: 24),

                // Indicadores de mejora
                _buildImprovementIndicators(theme, isMobile),
                const SizedBox(height: 24),

                // Desglose de parámetros
                _buildParametersBreakdown(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonSection(AppTheme theme, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primary.withOpacity(0.05),
            theme.secondary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comparación de Escenarios',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),

          // Escenario actual
          _buildScenarioRow(
            'Escenario Actual',
            ahorroActual,
            theme.textSecondary,
            theme,
            isSimulated: false,
          ),
          const SizedBox(height: 16),

          // Flecha de cambio
          Center(
            child: Icon(
              Icons.arrow_downward,
              color: diferencia >= 0 ? theme.success : theme.error,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),

          // Escenario simulado
          _buildScenarioRow(
            'Escenario Simulado',
            ahorroSimulado,
            theme.success,
            theme,
            isSimulated: true,
          ),
          const SizedBox(height: 20),

          // Diferencia
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: diferencia >= 0
                  ? theme.success.withOpacity(0.1)
                  : theme.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: diferencia >= 0 ? theme.success : theme.error,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      diferencia >= 0 ? Icons.trending_up : Icons.trending_down,
                      color: diferencia >= 0 ? theme.success : theme.error,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Diferencia',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.textPrimary,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${diferencia >= 0 ? '+' : ''}${moneyFormat(diferencia)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: diferencia >= 0 ? theme.success : theme.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioRow(
    String label,
    double amount,
    Color color,
    AppTheme theme, {
    bool isSimulated = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSimulated ? FontWeight.bold : FontWeight.w500,
                color: theme.textPrimary,
              ),
            ),
          ],
        ),
        Text(
          moneyFormat(amount),
          style: TextStyle(
            fontSize: isSimulated ? 18 : 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsGrid(AppTheme theme, bool isMobile) {
    return GridView.count(
      crossAxisCount: isMobile ? 2 : 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: isMobile ? 1.5 : 1.8,
      children: [
        _buildMetricCard(
          icon: Icons.receipt_long,
          label: 'Monto Original',
          value: moneyFormat(montoOriginal),
          color: theme.textSecondary,
          theme: theme,
        ),
        _buildMetricCard(
          icon: Icons.savings,
          label: 'Ahorro Simulado',
          value: moneyFormat(ahorroSimulado),
          color: theme.success,
          theme: theme,
        ),
        _buildMetricCard(
          icon: Icons.paid,
          label: 'Monto Final',
          value: moneyFormat(montoFinal),
          color: theme.primary,
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required AppTheme theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: theme.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(AppTheme theme) {
    final progress = montoOriginal > 0 ? montoFinal / montoOriginal : 0.0;
    final porcentajeAhorro =
        montoOriginal > 0 ? (ahorroSimulado / montoOriginal) * 100 : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Eficiencia de Pago',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.textPrimary,
              ),
            ),
            Text(
              '${porcentajeAhorro.toStringAsFixed(2)}% ahorro',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: theme.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 40,
            child: Stack(
              children: [
                // Fondo
                Container(
                  color: theme.border.withOpacity(0.3),
                ),
                // Progreso
                FractionallySizedBox(
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [theme.success, theme.secondary],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                ),
                // Texto centrado
                Center(
                  child: Text(
                    'Pago optimizado',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImprovementIndicators(AppTheme theme, bool isMobile) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildIndicatorChip(
          icon: Icons.show_chart,
          label: 'Mejora',
          value: '${mejora.abs().toStringAsFixed(1)}%',
          color: mejora >= 0 ? theme.success : theme.error,
          theme: theme,
        ),
        _buildIndicatorChip(
          icon: Icons.receipt,
          label: 'Facturas',
          value: '$cantidadFacturas',
          color: theme.accent,
          theme: theme,
        ),
        _buildIndicatorChip(
          icon: Icons.percent,
          label: 'DPP Aplicado',
          value: '${dppPercentage.toStringAsFixed(1)}%',
          color: theme.secondary,
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildIndicatorChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required AppTheme theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: theme.textSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParametersBreakdown(AppTheme theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.accent.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.accent.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: theme.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                'Parámetros Aplicados',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: theme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildParameterRow(
            'DPP',
            '${dppPercentage.toStringAsFixed(1)}%',
            theme,
          ),
          const SizedBox(height: 8),
          _buildParameterRow(
            'Días de pago',
            '$paymentDays días',
            theme,
          ),
          const SizedBox(height: 8),
          _buildParameterRow(
            'Facturas analizadas',
            '$cantidadFacturas',
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildParameterRow(String label, String value, AppTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: theme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: theme.textPrimary,
          ),
        ),
      ],
    );
  }
}
