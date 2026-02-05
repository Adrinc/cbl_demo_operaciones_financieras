import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facturacion_demo/providers/factura_provider.dart';
import 'package:facturacion_demo/providers/pago_provider.dart';
import 'package:facturacion_demo/widgets/kpi_card.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// KPI CARDS SECTION - Dashboard
/// ============================================================================
/// Muestra los 5 KPIs principales del sistema
/// ============================================================================

class KPICardsSection extends StatelessWidget {
  const KPICardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final facturaProvider = context.watch<FacturaProvider>();
    final pagoProvider = context.watch<PagoProvider>();
    final isMobile = MediaQuery.of(context).size.width < mobileSize;

    final totalFacturas = facturaProvider.facturas.length;
    final ahorroGenerado = pagoProvider.getTotalAhorroGenerado();
    final pagosEjecutados = pagoProvider.getPagosEjecutados().length;
    final pagosPendientes = pagoProvider.getPagosPropuestos().length;
    final ahorroPerdido = facturaProvider.getAhorroPerdido();

    // En desktop: fila horizontal con cards compactos
    if (!isMobile) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: KPICard(
              icon: Icons.receipt_long,
              title: 'Total Facturas',
              value: totalFacturas.toString(),
              subtitle: 'Ejercicio $ejercicioFiscal',
              color: const Color(0xFF1E3A8A),
              isCompact: true,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: KPICard(
              icon: Icons.savings,
              title: 'Ahorro Generado',
              value: '\$ ${ahorroGenerado.toStringAsFixed(2)} USD',
              subtitle: 'Con optimización',
              color: const Color(0xFF10B981),
              trendIcon: Icons.trending_up,
              trendColor: const Color(0xFF10B981),
              isCompact: true,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: KPICard(
              icon: Icons.check_circle,
              title: 'Pagos Ejecutados',
              value: pagosEjecutados.toString(),
              subtitle: 'Completados',
              color: const Color(0xFF10B981),
              isCompact: true,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: KPICard(
              icon: Icons.pending,
              title: 'Pagos Pendientes',
              value: pagosPendientes.toString(),
              subtitle: 'Por aprobar',
              color: const Color(0xFFF59E0B),
              isCompact: true,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: KPICard(
              icon: Icons.trending_down,
              title: 'Ahorro Perdido',
              value: '\$ ${ahorroPerdido.toStringAsFixed(2)} USD',
              subtitle: 'Oportunidad no aprovechada',
              color: const Color(0xFFEF4444),
              trendIcon: Icons.warning,
              trendColor: const Color(0xFFEF4444),
              isCompact: true,
            ),
          ),
        ],
      );
    }

    // En mobile: columna vertical
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        KPICard(
          icon: Icons.receipt_long,
          title: 'Total Facturas',
          value: totalFacturas.toString(),
          subtitle: 'Ejercicio $ejercicioFiscal',
          color: const Color(0xFF1E3A8A), // Primary color
        ),
        KPICard(
          icon: Icons.savings,
          title: 'Ahorro Generado',
          value: '\$ ${ahorroGenerado.toStringAsFixed(2)} USD',
          subtitle: 'Con optimización',
          color: const Color(0xFF10B981), // Success color
          trendIcon: Icons.trending_up,
          trendColor: const Color(0xFF10B981),
        ),
        KPICard(
          icon: Icons.check_circle,
          title: 'Pagos Ejecutados',
          value: pagosEjecutados.toString(),
          subtitle: 'Completados',
          color: const Color(0xFF10B981), // Success color
        ),
        KPICard(
          icon: Icons.pending,
          title: 'Pagos Pendientes',
          value: pagosPendientes.toString(),
          subtitle: 'Por aprobar',
          color: const Color(0xFFF59E0B), // Warning color
        ),
        KPICard(
          icon: Icons.trending_down,
          title: 'Ahorro Perdido',
          value: '\$ ${ahorroPerdido.toStringAsFixed(2)} USD',
          subtitle: 'Oportunidad no aprovechada',
          color: const Color(0xFFEF4444), // Error color
          trendIcon: Icons.warning,
          trendColor: const Color(0xFFEF4444),
        ),
      ],
    );
  }
}
