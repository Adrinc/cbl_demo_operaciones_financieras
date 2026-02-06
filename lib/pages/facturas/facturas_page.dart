import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facturacion_demo/pages/facturas/widgets/factura_pluto_grid.dart';
import 'package:facturacion_demo/pages/facturas/widgets/factura_mobile_cards.dart';
import 'package:facturacion_demo/providers/proveedor_provider.dart';
import 'package:facturacion_demo/helpers/constants.dart';
import 'package:facturacion_demo/theme/theme.dart';

/// ============================================================================
/// FACTURAS PAGE
/// ============================================================================
/// Página de gestión de facturas con PlutoGrid (desktop) y Cards (mobile)
/// Responsive: Desktop muestra tabla, móvil muestra tarjetas con paginación
/// ============================================================================

class FacturasPage extends StatefulWidget {
  const FacturasPage({super.key});

  @override
  State<FacturasPage> createState() => _FacturasPageState();
}

class _FacturasPageState extends State<FacturasPage> {
  String _filterEstado = 'todos';
  String _filterEsquema = 'todos';
  String _filterProveedor = 'todos';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final isMobile = MediaQuery.of(context).size.width < mobileSize;

    return Column(
      children: [
        // Filtros de búsqueda
        Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: _buildFilters(theme, isMobile),
        ),

        // Tabla o cards
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
            child: !isMobile
                ? FacturaPlutoGrid(
                    filterEstado: _filterEstado,
                    filterEsquema: _filterEsquema,
                    filterProveedor: _filterProveedor,
                    searchQuery: _searchQuery,
                  )
                : const FacturaMobileCards(),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters(AppTheme theme, bool isMobile) {
    final proveedorProvider = context.watch<ProveedorProvider>();
    final proveedores = proveedorProvider.proveedores;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.border.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: theme.textPrimary.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.receipt_long, color: theme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Filtros de Facturas',
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Filtros en fila
          if (!isMobile)
            Row(
              children: [
                // Búsqueda
                Expanded(
                  flex: 2,
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Buscar por factura, proveedor o ID...',
                      prefixIcon:
                          Icon(Icons.search, color: theme.textSecondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.primary, width: 2),
                      ),
                      filled: true,
                      fillColor: theme.primaryBackground,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Estado
                Expanded(
                  child: _buildDropdown(
                    'Estado',
                    _filterEstado,
                    [
                      {'value': 'todos', 'label': 'Todos'},
                      {'value': EstadoFactura.pendiente, 'label': 'Pendiente'},
                      {'value': EstadoFactura.pagada, 'label': 'Pagada'},
                      {'value': EstadoFactura.vencida, 'label': 'Vencida'},
                      {'value': EstadoFactura.cancelada, 'label': 'Cancelada'},
                    ],
                    (value) => setState(() => _filterEstado = value!),
                    theme,
                  ),
                ),
                const SizedBox(width: 12),
                // Esquema
                Expanded(
                  child: _buildDropdown(
                    'Esquema',
                    _filterEsquema,
                    [
                      {'value': 'todos', 'label': 'Todos'},
                      {'value': EsquemaPago.push, 'label': 'PUSH'},
                      {'value': EsquemaPago.pull, 'label': 'PULL'},
                    ],
                    (value) => setState(() => _filterEsquema = value!),
                    theme,
                  ),
                ),
                const SizedBox(width: 12),
                // Proveedor
                Expanded(
                  flex: 2,
                  child: _buildDropdown(
                    'Proveedor',
                    _filterProveedor,
                    [
                      {'value': 'todos', 'label': 'Todos'},
                      ...proveedores.map((p) => {
                            'value': p.id,
                            'label': p.nombre,
                          }),
                    ],
                    (value) => setState(() => _filterProveedor = value!),
                    theme,
                  ),
                ),
              ],
            ),

          // Móvil: Filtros en columna
          if (isMobile) ...[
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Buscar...',
                prefixIcon: Icon(Icons.search, color: theme.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: theme.primaryBackground,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                      'Estado',
                      _filterEstado,
                      [
                        {'value': 'todos', 'label': 'Todos'},
                        {
                          'value': EstadoFactura.pendiente,
                          'label': 'Pendiente'
                        },
                        {'value': EstadoFactura.pagada, 'label': 'Pagada'},
                      ],
                      (value) => setState(() => _filterEstado = value!),
                      theme),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown(
                      'Esquema',
                      _filterEsquema,
                      [
                        {'value': 'todos', 'label': 'Todos'},
                        {'value': EsquemaPago.push, 'label': 'PUSH'},
                        {'value': EsquemaPago.pull, 'label': 'PULL'},
                      ],
                      (value) => setState(() => _filterEsquema = value!),
                      theme),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<Map<String, String>> options,
    ValueChanged<String?> onChanged,
    AppTheme theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: theme.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.primary, width: 2),
            ),
            filled: true,
            fillColor: theme.primaryBackground,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option['value'],
              child: Text(
                option['label']!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
