import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/providers/factura_provider.dart';
import 'package:facturacion_demo/providers/navigation_provider.dart';
import 'package:facturacion_demo/models/models.dart';
import 'package:facturacion_demo/functions/money_format.dart';
import 'package:facturacion_demo/functions/percentage_format.dart';
import 'package:facturacion_demo/functions/proveedor_logo.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// TOP OPPORTUNITIES WIDGET
/// ============================================================================
/// Muestra las Top 5 facturas con mayor oportunidad de ahorro DPP
/// ============================================================================

class TopOpportunitiesWidget extends StatelessWidget {
  const TopOpportunitiesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final facturaProvider = context.watch<FacturaProvider>();
    final isMobile = MediaQuery.of(context).size.width < mobileSize;

    // Obtener facturas pendientes con DPP disponible, ordenadas por monto de ahorro
    final opportunities = facturaProvider.facturas
        .where((f) =>
            f.estado == EstadoFactura.pendiente &&
            f.porcentajeDPP > 0 &&
            f.diasParaPago > 0)
        .toList()
      ..sort((a, b) => b.montoDPP.compareTo(a.montoDPP));

    final top5 = opportunities.take(5).toList();

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.border.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          ...theme.shadowMedium,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.secondary.withOpacity(0.2),
                            theme.secondary.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.star,
                          color: theme.secondary, size: isMobile ? 20 : 24),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Top Oportunidades',
                            style: TextStyle(
                              color: theme.textPrimary,
                              fontSize: isMobile ? 16 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (!isMobile)
                            Text(
                              'Mayor potencial de ahorro',
                              style: TextStyle(
                                color: theme.textSecondary,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    context
                        .read<NavigationProvider>()
                        .setCurrentRoute(Routes.optimizacion);
                    context.go(Routes.optimizacion);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 10 : 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: theme.secondary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isMobile ? 'Ver' : 'Ver todas',
                          style: TextStyle(
                            color: theme.secondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward,
                          color: theme.secondary,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (top5.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 48,
                      color: theme.textSecondary.withOpacity(0.3),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No hay oportunidades disponibles',
                      style: TextStyle(
                        color: theme.textSecondary,
                        fontSize: 13,
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
              itemCount: top5.length,
              separatorBuilder: (_, __) => SizedBox(height: isMobile ? 10 : 12),
              itemBuilder: (context, index) {
                final factura = top5[index];
                final position = index + 1;

                return isMobile
                    ? _buildMobileOpportunityCard(
                        context, theme, factura, position)
                    : _buildDesktopOpportunityItem(
                        context, theme, factura, position);
              },
            ),
        ],
      ),
    );
  }

  /// Mobile: tarjeta vertical con más espacio
  Widget _buildMobileOpportunityCard(
    BuildContext context,
    AppTheme theme,
    Factura factura,
    int position,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          context.read<NavigationProvider>().setCurrentRoute(Routes.facturas);
          context.go(Routes.facturas);
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.primaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: position <= 3 ? theme.secondary : theme.border,
                width: 3,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.textPrimary.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila superior: posición + proveedor + logo
              Row(
                children: [
                  // Posición
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: position <= 3
                            ? [
                                theme.secondary,
                                theme.secondary.withOpacity(0.7)
                              ]
                            : [
                                theme.textSecondary.withOpacity(0.3),
                                theme.textSecondary.withOpacity(0.2)
                              ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '#$position',
                        style: TextStyle(
                          color: position <= 3
                              ? Colors.white
                              : theme.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Logo
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: theme.surface,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: theme.border.withOpacity(0.4)),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset(
                        getProveedorLogoPath(factura.proveedorNombre),
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(Icons.business,
                            color: theme.textSecondary, size: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Nombre proveedor
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          factura.proveedorNombre,
                          style: TextStyle(
                            color: theme.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          factura.numeroFactura,
                          style: TextStyle(
                            color: theme.textSecondary,
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Fila inferior: ahorro + porcentaje DPP
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Ahorro badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.success.withOpacity(0.15),
                          theme.success.withOpacity(0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: theme.success.withOpacity(0.25)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.savings, color: theme.success, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          moneyFormat(factura.montoDPP),
                          style: TextStyle(
                            color: theme.success,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // DPP porcentaje
                  Text(
                    '${formatPercentage(factura.porcentajeDPP)} DPP',
                    style: TextStyle(
                      color: theme.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Desktop: fila horizontal original
  Widget _buildDesktopOpportunityItem(
    BuildContext context,
    AppTheme theme,
    Factura factura,
    int position,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          context.read<NavigationProvider>().setCurrentRoute(Routes.facturas);
          context.go(Routes.facturas);
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.primaryBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: theme.border.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Posición
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: position <= 3
                        ? [theme.secondary, theme.secondary.withOpacity(0.7)]
                        : [
                            theme.textSecondary.withOpacity(0.3),
                            theme.textSecondary.withOpacity(0.2)
                          ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '#$position',
                    style: TextStyle(
                      color: position <= 3 ? Colors.white : theme.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Logo del proveedor
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.border.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    getProveedorLogoPath(factura.proveedorNombre),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.business,
                        color: theme.textSecondary,
                        size: 20,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Info factura
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      factura.proveedorNombre,
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Factura ${factura.numeroFactura}',
                      style: TextStyle(
                        color: theme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Ahorro potencial
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.success.withOpacity(0.2),
                          theme.success.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: theme.success.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      moneyFormat(factura.montoDPP),
                      style: TextStyle(
                        color: theme.success,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${formatPercentage(factura.porcentajeDPP)} DPP',
                    style: TextStyle(
                      color: theme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
