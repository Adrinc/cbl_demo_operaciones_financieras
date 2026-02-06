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

    // En desktop: fila horizontal con cards más prominentes
    if (!isMobile) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI destacado: Ahorro Generado (más grande)
          Expanded(
            flex: 2,
            child: KPICard(
              icon: Icons.savings,
              title: 'Ahorro Generado',
              value: '\$ ${ahorroGenerado.toStringAsFixed(2)} USD',
              subtitle: 'Optimización activa en $ejercicioFiscal',
              color: const Color(0xFF10B981),
              trendIcon: Icons.trending_up,
              trendColor: const Color(0xFF10B981),
              isCompact: false, // Más grande
            ),
          ),
          const SizedBox(width: 16),
          // Resto de KPIs compactos
          Expanded(
            child: KPICard(
              icon: Icons.receipt_long,
              title: 'Total Facturas',
              value: totalFacturas.toString(),
              subtitle: 'Ejercicio $ejercicioFiscal',
              color: const Color(0xFF5885FF),
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
              subtitle: 'Oportunidad',
              color: const Color(0xFFEF4444),
              trendIcon: Icons.warning,
              trendColor: const Color(0xFFEF4444),
              isCompact: true,
            ),
          ),
        ],
      );
    }

    // En mobile: grid 2x2 + 1 (última fila con 1 card centrada)
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcular ancho de cada card (50% menos spacing)
        final cardWidth = (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: cardWidth,
              child: KPICard(
                icon: Icons.receipt_long,
                title: 'Total Facturas',
                value: totalFacturas.toString(),
                subtitle: 'Ejercicio $ejercicioFiscal',
                color: const Color(0xFF5885FF),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: KPICard(
                icon: Icons.savings,
                title: 'Ahorro Generado',
                value: '\$ ${ahorroGenerado.toStringAsFixed(2)} USD',
                subtitle: 'Con optimización',
                color: const Color(0xFF10B981),
                trendIcon: Icons.trending_up,
                trendColor: const Color(0xFF10B981),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: KPICard(
                icon: Icons.check_circle,
                title: 'Pagos Ejecutados',
                value: pagosEjecutados.toString(),
                subtitle: 'Completados',
                color: const Color(0xFF10B981),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: KPICard(
                icon: Icons.pending,
                title: 'Pagos Pendientes',
                value: pagosPendientes.toString(),
                subtitle: 'Por aprobar',
                color: const Color(0xFFF59E0B),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: KPICard(
                icon: Icons.trending_down,
                title: 'Ahorro Perdido',
                value: '\$ ${ahorroPerdido.toStringAsFixed(2)} USD',
                subtitle: 'Oportunidad no aprovechada',
                color: const Color(0xFFEF4444),
                trendIcon: Icons.warning,
                trendColor: const Color(0xFFEF4444),
              ),
            ),
          ],
        );
      },
    );
  }
}
