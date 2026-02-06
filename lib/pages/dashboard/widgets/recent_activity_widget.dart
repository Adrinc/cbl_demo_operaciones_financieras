import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/providers/pago_provider.dart';
import 'package:facturacion_demo/models/models.dart';
import 'package:facturacion_demo/functions/money_format.dart';
import 'package:facturacion_demo/functions/date_time_format.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// RECENT ACTIVITY WIDGET
/// ============================================================================
/// Timeline de actividad reciente (últimos pagos ejecutados)
/// ============================================================================

class RecentActivityWidget extends StatelessWidget {
  const RecentActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final pagoProvider = context.watch<PagoProvider>();

    // Últimos 5 pagos ejecutados ordenados por fecha
    final recentPayments = pagoProvider.pagos
        .where(
            (p) => p.estado == EstadoPago.ejecutado && p.fechaEjecucion != null)
        .toList()
      ..sort((a, b) => b.fechaEjecucion!.compareTo(a.fechaEjecucion!));

    final last5 = recentPayments.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.border.withOpacity(0.5),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.primary.withOpacity(0.2),
                          theme.primary.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.history, color: theme.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Actividad Reciente',
                        style: TextStyle(
                          color: theme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Últimos pagos ejecutados',
                        style: TextStyle(
                          color: theme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => context.go(Routes.validaciones),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: theme.primary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Ver historial',
                          style: TextStyle(
                            color: theme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward,
                          color: theme.primary,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (last5.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.pending_actions_outlined,
                      size: 64,
                      color: theme.textSecondary.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay actividad reciente',
                      style: TextStyle(
                        color: theme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: last5.length,
              separatorBuilder: (_, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final pago = last5[index];
                return _buildActivityItem(context, theme, pago);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, AppTheme theme, Pago pago) {
    final isOptimizado = pago.tipo == 'optimizado';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOptimizado
              ? theme.success.withOpacity(0.3)
              : theme.border.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.textPrimary.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row con badge
          Row(
            children: [
              // Badge de tipo
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isOptimizado
                        ? [theme.success, theme.success.withOpacity(0.8)]
                        : [theme.primary, theme.primary.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (isOptimizado ? theme.success : theme.primary)
                          .withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isOptimizado ? Icons.check_circle : Icons.payment,
                      color: Colors.white,
                      size: 13,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isOptimizado ? 'OPTIMIZADO' : 'NORMAL',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                dateTimeFormat(pago.fechaEjecucion!),
                style: TextStyle(
                  color: theme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Info de facturas
          Row(
            children: [
              Icon(
                Icons.receipt_long,
                color: theme.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                '${pago.facturaIds.length} factura${pago.facturaIds.length != 1 ? 's' : ''}',
                style: TextStyle(
                  color: theme.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Divider sutil
          Container(
            height: 1,
            color: theme.border.withOpacity(0.3),
          ),
          const SizedBox(height: 12),
          // Montos principales
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Monto pagado
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monto Pagado',
                      style: TextStyle(
                        color: theme.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      moneyFormat(pago.montoTotal),
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              // Ahorro (si existe)
              if (pago.ahorroGenerado > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.success.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: theme.success.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Ahorro',
                        style: TextStyle(
                          color: theme.success,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.savings,
                            color: theme.success,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            moneyFormat(pago.ahorroGenerado),
                            style: TextStyle(
                              color: theme.success,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
