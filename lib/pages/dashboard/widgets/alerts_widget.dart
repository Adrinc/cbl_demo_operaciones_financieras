import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:facturacion_demo/providers/factura_provider.dart';
import 'package:facturacion_demo/providers/navigation_provider.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/helpers/constants.dart';
import 'package:facturacion_demo/functions/date_format.dart';

/// ============================================================================
/// ALERTS WIDGET - Dashboard
/// ============================================================================
/// Muestra facturas con DPP próximo a vencer (< 7 días)
/// ============================================================================

class AlertsWidget extends StatelessWidget {
  const AlertsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final facturaProvider = context.watch<FacturaProvider>();
    final isMobile = MediaQuery.of(context).size.width < mobileSize;

    // Filtrar facturas con DPP próximo a vencer
    final facturas = facturaProvider.facturas.where((f) {
      if (f.estado != EstadoFactura.pendiente || f.porcentajeDPP == 0) {
        return false;
      }
      final diasRestantes =
          f.fechaVencimiento.difference(DateTime.now()).inDays;
      return diasRestantes <= alertaDiasDPP && diasRestantes > 0;
    }).toList();

    if (facturas.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.warning.withOpacity(0.5),
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
            children: [
              // Icono con degradado
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.warning.withOpacity(0.3),
                      theme.warning.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: theme.warning.withOpacity(0.5),
                  ),
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: theme.warning,
                  size: isMobile ? 20 : 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Alertas: DPP Próximos a Vencer',
                  style: theme.subtitle2.override(
                    fontFamily: theme.subtitle2Family,
                    fontSize: isMobile ? 16 : 20,
                    fontWeight: FontWeight.w600,
                    color: theme.primaryText,
                  ),
                ),
              ),
              // Badge de conteo con degradado
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.warning,
                      theme.warning.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: theme.warning.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '${facturas.length}',
                  style: theme.subtitle2.override(
                    fontFamily: theme.subtitle2Family,
                    fontSize: isMobile ? 14 : 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...facturas.take(5).map((factura) {
            final diasRestantes =
                factura.fechaVencimiento.difference(DateTime.now()).inDays;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    theme.warning.withOpacity(0.08),
                    theme.warning.withOpacity(0.02),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: theme.warning.withOpacity(0.35), // 🔥 Más visible
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          factura.numeroFactura,
                          style: theme.bodyText1.override(
                            fontFamily: theme.bodyText1Family,
                            fontSize: isMobile ? 14 : 16,
                            color: theme.primaryText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          factura.proveedorNombre,
                          style: theme.bodyText2.override(
                            fontFamily: theme.bodyText2Family,
                            fontSize: isMobile ? 12 : 14,
                            color: theme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Vence: ${formatDate(factura.fechaVencimiento)}',
                          style: theme.bodyText3.override(
                            fontFamily: theme.bodyText3Family,
                            fontSize: isMobile ? 10 : 12,
                            color: theme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Badge de días con degradado
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.warning.withOpacity(0.25),
                              theme.warning.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.warning.withOpacity(0.4),
                          ),
                        ),
                        child: Text(
                          '$diasRestantes días',
                          style: theme.bodyText3.override(
                            fontFamily: theme.bodyText3Family,
                            fontSize: isMobile ? 10 : 12,
                            color: theme.warning,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'DPP: ${factura.porcentajeDPP.toStringAsFixed(2)}%',
                        style: theme.bodyText3.override(
                          fontFamily: theme.bodyText3Family,
                          fontSize: isMobile ? 10 : 12,
                          color: theme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          if (facturas.length > 5) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                context
                    .read<NavigationProvider>()
                    .setCurrentRoute(Routes.facturas);
                context.go(Routes.facturas);
              },
              child: Text(
                'Ver todas las ${facturas.length} facturas con DPP por vencer',
                style: theme.bodyText2.override(
                  fontFamily: theme.bodyText2Family,
                  fontSize: isMobile ? 12 : 14,
                  color: theme.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
