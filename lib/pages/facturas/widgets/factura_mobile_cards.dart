import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facturacion_demo/models/models.dart';
import 'package:facturacion_demo/providers/factura_provider.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/functions/money_format.dart';
import 'package:facturacion_demo/functions/date_format.dart';
import 'package:facturacion_demo/widgets/status_badge.dart';

/// ============================================================================
/// FACTURA MOBILE CARDS
/// ============================================================================
/// Vista móvil de facturas con tarjetas y paginación de 5 en 5
/// ============================================================================

class FacturaMobileCards extends StatefulWidget {
  const FacturaMobileCards({super.key});

  @override
  State<FacturaMobileCards> createState() => _FacturaMobileCardsState();
}

class _FacturaMobileCardsState extends State<FacturaMobileCards> {
  int _currentPage = 0;
  final int _itemsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final facturaProvider = context.watch<FacturaProvider>();
    final facturas = facturaProvider.facturas;

    // Calcular paginación
    final totalPages = (facturas.length / _itemsPerPage).ceil();
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, facturas.length);
    final currentPageFacturas = facturas.sublist(startIndex, endIndex);

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Header con contador
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.primary.withOpacity(0.1),
                theme.primary.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.border.withOpacity(0.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.receipt_long,
                    color: theme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Total Facturas',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.primary,
                    width: 1,
                  ),
                ),
                child: Text(
                  '${facturas.length}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Lista de tarjetas
        if (currentPageFacturas.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: theme.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay facturas',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...currentPageFacturas.map((factura) => _buildFacturaCard(
                context,
                theme,
                factura,
              )),

        const SizedBox(height: 16),

        // Paginador
        if (totalPages > 1)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.border.withOpacity(0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botón anterior
                IconButton(
                  onPressed: _currentPage > 0
                      ? () {
                          setState(() {
                            _currentPage--;
                          });
                        }
                      : null,
                  icon: Icon(
                    Icons.chevron_left,
                    color:
                        _currentPage > 0 ? theme.primary : theme.textDisabled,
                  ),
                ),

                // Indicador de página
                Text(
                  'Página ${_currentPage + 1} de $totalPages',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.textPrimary,
                  ),
                ),

                // Botón siguiente
                IconButton(
                  onPressed: _currentPage < totalPages - 1
                      ? () {
                          setState(() {
                            _currentPage++;
                          });
                        }
                      : null,
                  icon: Icon(
                    Icons.chevron_right,
                    color: _currentPage < totalPages - 1
                        ? theme.primary
                        : theme.textDisabled,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFacturaCard(
      BuildContext context, AppTheme theme, Factura factura) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.border.withOpacity(0.5),
          width: 1,
        ),
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
          // Header con proveedor y estado
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.primary.withOpacity(0.08),
                  theme.primary.withOpacity(0.02),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Proveedor
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.secondary.withOpacity(0.2),
                              theme.secondary.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.secondary.withOpacity(0.3),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            factura.proveedorNombre
                                .substring(0, 1)
                                .toUpperCase(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.secondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              factura.proveedorNombre,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: theme.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID: ${factura.id}',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Estado
                _buildStatusBadge(context, factura.estado),
              ],
            ),
          ),

          // Contenido
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Número de factura
                _buildInfoRow(
                  context,
                  theme,
                  icon: Icons.numbers,
                  label: 'Factura',
                  value: factura.numeroFactura,
                ),
                const SizedBox(height: 12),

                // Importe
                _buildInfoRow(
                  context,
                  theme,
                  icon: Icons.attach_money,
                  label: 'Importe',
                  value: moneyFormat(factura.importe),
                  valueColor: theme.textPrimary,
                  isBold: true,
                ),
                const SizedBox(height: 12),

                // Días para pago
                _buildInfoRow(
                  context,
                  theme,
                  icon: Icons.calendar_today,
                  label: 'Días Pago',
                  value: '${factura.diasParaPago} días',
                ),
                const SizedBox(height: 12),

                // DPP %
                _buildInfoRow(
                  context,
                  theme,
                  icon: Icons.percent,
                  label: 'DPP',
                  value: '${factura.porcentajeDPP.toStringAsFixed(2)} %',
                  valueColor: factura.porcentajeDPP > 0
                      ? theme.success
                      : theme.textSecondary,
                ),
                const SizedBox(height: 12),

                // Monto DPP (ahorro)
                if (factura.porcentajeDPP > 0) ...[
                  _buildInfoRow(
                    context,
                    theme,
                    icon: Icons.savings,
                    label: 'Ahorro DPP',
                    value: moneyFormat(factura.montoDPP),
                    valueColor: theme.success,
                    isBold: true,
                  ),
                  const SizedBox(height: 12),
                ],

                // Monto con DPP
                if (factura.porcentajeDPP > 0) ...[
                  _buildInfoRow(
                    context,
                    theme,
                    icon: Icons.monetization_on,
                    label: 'Pronto Pago',
                    value: moneyFormat(factura.montoConDPP),
                    valueColor: theme.secondary,
                    isBold: true,
                  ),
                  const SizedBox(height: 12),
                ],

                // Esquema
                _buildInfoRow(
                  context,
                  theme,
                  icon: Icons.swap_horiz,
                  label: 'Esquema',
                  value: '',
                  trailing: _buildEsquemaBadge(context, factura.esquema),
                ),
                const SizedBox(height: 12),

                // Fechas
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.border.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Emisión',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.textSecondary,
                            ),
                          ),
                          Text(
                            formatDate(factura.fechaEmision),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: theme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Vencimiento',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.textSecondary,
                            ),
                          ),
                          Text(
                            formatDate(factura.fechaVencimiento),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: theme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      if (factura.fechaPago != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pagada',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.textSecondary,
                              ),
                            ),
                            Text(
                              formatDate(factura.fechaPago!),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: theme.success,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    AppTheme theme, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool isBold = false,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: theme.textSecondary,
        ),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 13,
            color: theme.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        if (trailing != null)
          trailing
        else
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
                color: valueColor ?? theme.textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context, String estado) {
    switch (estado) {
      case 'pendiente':
        return StatusBadge.pendiente(context, isCompact: true);
      case 'pagada':
        return StatusBadge.pagada(context, isCompact: true);
      case 'vencida':
        return StatusBadge.vencida(context, isCompact: true);
      case 'cancelada':
        return StatusBadge.cancelada(context, isCompact: true);
      default:
        return StatusBadge.pendiente(context, isCompact: true);
    }
  }

  Widget _buildEsquemaBadge(BuildContext context, String esquema) {
    if (esquema == 'push') {
      return StatusBadge.push(context, isCompact: true);
    } else {
      return StatusBadge.pull(context, isCompact: true);
    }
  }
}
