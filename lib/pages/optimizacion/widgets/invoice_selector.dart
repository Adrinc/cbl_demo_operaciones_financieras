import 'package:flutter/material.dart';
import 'package:facturacion_demo/models/models.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/functions/money_format.dart';
import 'package:facturacion_demo/functions/date_format.dart';

/// ============================================================================
/// INVOICE SELECTOR WIDGET
/// ============================================================================
/// Selector de facturas con checkboxes para optimización de pagos
/// Muestra facturas pendientes con opción de selección múltiple
/// ============================================================================
class InvoiceSelector extends StatefulWidget {
  final List<Factura> facturas;
  final Set<String> selectedIds;
  final Function(Set<String>) onSelectionChanged;

  const InvoiceSelector({
    super.key,
    required this.facturas,
    required this.selectedIds,
    required this.onSelectionChanged,
  });

  @override
  State<InvoiceSelector> createState() => _InvoiceSelectorState();
}

class _InvoiceSelectorState extends State<InvoiceSelector> {
  bool _selectAll = false;
  String _filterEsquema = 'todos'; // 'todos' | 'push' | 'pull'
  bool _soloConDPP = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 768;

    // Aplicar filtros
    List<Factura> factuasFiltradas = widget.facturas;

    if (_filterEsquema != 'todos') {
      factuasFiltradas = factuasFiltradas
          .where((f) => f.esquema.toLowerCase() == _filterEsquema)
          .toList();
    }

    if (_soloConDPP) {
      factuasFiltradas =
          factuasFiltradas.where((f) => f.porcentajeDPP > 0).toList();
    }

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
          // Header con título y filtros
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.primary.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.receipt_long, color: theme.primary, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Facturas Pendientes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${factuasFiltradas.length} disponibles',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Filtros y checkbox "Seleccionar todo"
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    // Seleccionar todo
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectAll = !_selectAll;
                          if (_selectAll) {
                            widget.onSelectionChanged(
                                factuasFiltradas.map((f) => f.id).toSet());
                          } else {
                            widget.onSelectionChanged({});
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: _selectAll
                              ? theme.primary.withOpacity(0.15)
                              : theme.primaryBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _selectAll ? theme.primary : theme.border,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _selectAll
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: _selectAll
                                  ? theme.primary
                                  : theme.textSecondary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Seleccionar todo',
                              style: TextStyle(
                                color: _selectAll
                                    ? theme.primary
                                    : theme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Filtro por esquema
                    DropdownButton<String>(
                      value: _filterEsquema,
                      underline: const SizedBox(),
                      icon: Icon(Icons.arrow_drop_down, color: theme.primary),
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'todos', child: Text('Todos los esquemas')),
                        DropdownMenuItem(
                            value: 'push', child: Text('PUSH NC-Pago')),
                        DropdownMenuItem(
                            value: 'pull', child: Text('PULL NC-Pago')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _filterEsquema = value;
                            _selectAll = false;
                            widget.onSelectionChanged({});
                          });
                        }
                      },
                    ),

                    // Solo con DPP
                    InkWell(
                      onTap: () {
                        setState(() {
                          _soloConDPP = !_soloConDPP;
                          _selectAll = false;
                          widget.onSelectionChanged({});
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: _soloConDPP
                              ? theme.success.withOpacity(0.15)
                              : theme.primaryBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _soloConDPP ? theme.success : theme.border,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _soloConDPP ? Icons.savings : Icons.money_off,
                              color: _soloConDPP
                                  ? theme.success
                                  : theme.textSecondary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Solo con DPP',
                              style: TextStyle(
                                color: _soloConDPP
                                    ? theme.success
                                    : theme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Lista de facturas
          Container(
            constraints: const BoxConstraints(maxHeight: 500),
            child: factuasFiltradas.isEmpty
                ? _buildEmptyState(theme)
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: factuasFiltradas.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final factura = factuasFiltradas[index];
                      final isSelected =
                          widget.selectedIds.contains(factura.id);

                      return _buildInvoiceCard(
                        factura,
                        isSelected,
                        theme,
                        isMobile,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppTheme theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.filter_list_off,
              size: 64,
              color: theme.textSecondary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay facturas que coincidan con los filtros',
              style: TextStyle(
                fontSize: 16,
                color: theme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceCard(
    Factura factura,
    bool isSelected,
    AppTheme theme,
    bool isMobile,
  ) {
    return InkWell(
      onTap: () {
        final newSelection = Set<String>.from(widget.selectedIds);
        if (isSelected) {
          newSelection.remove(factura.id);
        } else {
          newSelection.add(factura.id);
        }
        widget.onSelectionChanged(newSelection);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primary.withOpacity(0.08)
              : theme.primaryBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? theme.primary : theme.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Checkbox
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? theme.primary : theme.textSecondary,
              size: 28,
            ),
            const SizedBox(width: 16),

            // Info factura
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Proveedor y Factura
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          factura.proveedorNombre,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: theme.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildEsquemaBadge(factura.esquema, theme),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    factura.numeroFactura,
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Importe y DPP
                  if (isMobile)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMoneyRow(
                          'Importe:',
                          factura.importe,
                          theme.textPrimary,
                          theme,
                        ),
                        if (factura.porcentajeDPP > 0) ...[
                          const SizedBox(height: 4),
                          _buildMoneyRow(
                            'Ahorro DPP:',
                            factura.montoDPP,
                            theme.success,
                            theme,
                          ),
                          const SizedBox(height: 4),
                          _buildMoneyRow(
                            'Pronto Pago:',
                            factura.montoConDPP,
                            theme.secondary,
                            theme,
                          ),
                        ],
                        const SizedBox(height: 8),
                        Text(
                          'Vence: ${formatDate(factura.fechaVencimiento)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.textSecondary,
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildMoneyRow(
                                'Importe:',
                                factura.importe,
                                theme.textPrimary,
                                theme,
                              ),
                              if (factura.porcentajeDPP > 0) ...[
                                const SizedBox(height: 4),
                                _buildMoneyRow(
                                  'Ahorro DPP:',
                                  factura.montoDPP,
                                  theme.success,
                                  theme,
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (factura.porcentajeDPP > 0)
                          Expanded(
                            child: _buildMoneyRow(
                              'Pronto Pago:',
                              factura.montoConDPP,
                              theme.secondary,
                              theme,
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoneyRow(
      String label, double amount, Color color, AppTheme theme) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: theme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          moneyFormat(amount),
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEsquemaBadge(String esquema, AppTheme theme) {
    final isPull = esquema.toLowerCase() == 'pull';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPull
            ? theme.secondary.withOpacity(0.15)
            : theme.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPull ? theme.secondary : theme.primary,
          width: 1,
        ),
      ),
      child: Text(
        isPull ? 'PULL' : 'PUSH',
        style: TextStyle(
          color: isPull ? theme.secondary : theme.primary,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
}
