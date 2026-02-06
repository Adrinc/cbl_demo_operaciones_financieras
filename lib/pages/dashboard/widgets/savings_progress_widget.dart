import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/providers/pago_provider.dart';
import 'package:facturacion_demo/providers/factura_provider.dart';
import 'package:facturacion_demo/functions/money_format.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// SAVINGS PROGRESS WIDGET
/// ============================================================================
/// Indicador de progreso de ahorro vs objetivo anual
/// ============================================================================

class SavingsProgressWidget extends StatelessWidget {
  const SavingsProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final pagoProvider = context.watch<PagoProvider>();
    final facturaProvider = context.watch<FacturaProvider>();

    // Calcular ahorro actual
    final ahorroGenerado = pagoProvider.getTotalAhorroGenerado();

    // Calcular ahorro potencial total (actual + oportunidades pendientes)
    final ahorroPotencial =
        ahorroGenerado + facturaProvider.getAhorroPotencial();

    // Objetivo del ejercicio fiscal (ejemplo: total potencial)
    final objetivoAnual = ahorroPotencial > 0 ? ahorroPotencial : 100000.0;

    // Porcentaje alcanzado
    final porcentajeAlcanzado =
        (ahorroGenerado / objetivoAnual * 100).clamp(0, 100);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // 🔥 SIN opacidades ni degradados - color surface puro
        color: theme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.success.withOpacity(0.4),
          width: 2, // 🔥 Borde prominente
        ),
        // 🔥 SOMBRAS PREMIUM - Este es un hero widget
        boxShadow: [
          ...theme.shadowPremium,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.success,
                      theme.success.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: theme.success.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.emoji_events, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progreso de Ahorro $ejercicioFiscal',
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Objetivo anual vs ahorro alcanzado',
                      style: TextStyle(
                        color: theme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Progress bar
          Stack(
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: theme
                      .primaryBackground, // 🔥 Color sólido - sin difuminación
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.border.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                height: 40,
                width: MediaQuery.of(context).size.width *
                    (porcentajeAlcanzado / 100),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.success,
                      theme.success.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: theme.success.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${porcentajeAlcanzado.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Stats row
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  theme,
                  'Ahorro Alcanzado',
                  moneyFormat(ahorroGenerado),
                  Icons.check_circle,
                  theme.success,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: theme.border.withOpacity(0.3),
              ),
              Expanded(
                child: _buildStatItem(
                  theme,
                  'Objetivo Anual',
                  moneyFormat(objetivoAnual),
                  Icons.flag,
                  theme.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Message
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.surface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: theme.border.withOpacity(0.5), // 🔥 Más visible
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  porcentajeAlcanzado >= 75
                      ? Icons.trending_up
                      : Icons.lightbulb_outline,
                  color:
                      porcentajeAlcanzado >= 75 ? theme.success : theme.warning,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    porcentajeAlcanzado >= 75
                        ? '¡Excelente progreso! Vas muy bien encaminado.'
                        : 'Aprovecha las oportunidades en Optimización de Pagos.',
                    style: TextStyle(
                      color: theme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    AppTheme theme,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: theme.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: theme.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
