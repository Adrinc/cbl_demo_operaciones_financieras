import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';
import 'package:facturacion_demo/providers/factura_provider.dart';
import 'package:facturacion_demo/models/models.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/helpers/constants.dart';
import 'package:facturacion_demo/widgets/status_badge.dart';
import 'package:facturacion_demo/pages/facturas/widgets/factura_form_dialog.dart';
import 'package:facturacion_demo/functions/date_format.dart';
import 'package:facturacion_demo/functions/money_format.dart';

/// ============================================================================
/// FACTURA PLUTO GRID - Desktop Table
/// ============================================================================
/// Tabla PlutoGrid con paginación para gestión de facturas
/// ============================================================================

class FacturaPlutoGrid extends StatefulWidget {
  final String filterEstado;
  final String filterEsquema;
  final String filterProveedor;
  final String searchQuery;

  const FacturaPlutoGrid({
    super.key,
    this.filterEstado = 'todos',
    this.filterEsquema = 'todos',
    this.filterProveedor = 'todos',
    this.searchQuery = '',
  });

  @override
  State<FacturaPlutoGrid> createState() => _FacturaPlutoGridState();
}

class _FacturaPlutoGridState extends State<FacturaPlutoGrid> {
  PlutoGridStateManager? _stateManager;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final themeMode = Theme.of(context).brightness;
    final facturaProvider = context.watch<FacturaProvider>();

    // Aplicar filtros
    List<Factura> facturas = facturaProvider.facturas.where((f) {
      // Filtro de estado
      if (widget.filterEstado != 'todos' && f.estado != widget.filterEstado) {
        return false;
      }
      // Filtro de esquema
      if (widget.filterEsquema != 'todos' &&
          f.esquema != widget.filterEsquema) {
        return false;
      }
      // Filtro de proveedor
      if (widget.filterProveedor != 'todos' &&
          f.proveedorId != widget.filterProveedor) {
        return false;
      }
      // Búsqueda
      if (widget.searchQuery.isNotEmpty) {
        final query = widget.searchQuery.toLowerCase();
        return f.numeroFactura.toLowerCase().contains(query) ||
            f.proveedorNombre.toLowerCase().contains(query) ||
            f.id.toLowerCase().contains(query);
      }
      return true;
    }).toList();

    final columns = [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        width: 120,
        enableEditingMode: false,
        renderer: (rendererContext) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.centerLeft,
            child: Text(
              rendererContext.cell.value,
              style: TextStyle(
                color: theme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Proveedor',
        field: 'proveedor',
        type: PlutoColumnType.text(),
        width: 180,
        enableEditingMode: false,
      ),
      PlutoColumn(
        title: 'Factura',
        field: 'numeroFactura',
        type: PlutoColumnType.text(),
        width: 150,
        enableEditingMode: false,
        renderer: (rendererContext) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.centerLeft,
            child: Text(
              rendererContext.cell.value,
              style: TextStyle(
                color: theme.primaryText,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Importe',
        field: 'importe',
        type: PlutoColumnType.currency(
          symbol: '\$ ',
          decimalDigits: 2,
        ),
        width: 140,
        enableEditingMode: false,
        renderer: (rendererContext) {
          final rawValue = rendererContext.cell.value;
          final value =
              rawValue is int ? rawValue.toDouble() : (rawValue as double);
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            alignment: Alignment.centerRight,
            child: Text(
              moneyFormat(value),
              style: TextStyle(
                color: theme.primaryText,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Días Pago',
        field: 'diasPago',
        type: PlutoColumnType.number(),
        width: 100,
        enableEditingMode: false,
        renderer: (rendererContext) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            child: Text(
              '${rendererContext.cell.value}',
              style: TextStyle(
                color: theme.textSecondary,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
      PlutoColumn(
        title: '%DPP',
        field: 'porcentajeDPP',
        type: PlutoColumnType.number(),
        width: 90,
        enableEditingMode: false,
        renderer: (rendererContext) {
          final rawValue = rendererContext.cell.value;
          final value =
              rawValue is int ? rawValue.toDouble() : (rawValue as double);
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            child: Text(
              value > 0 ? '${value.toStringAsFixed(2)} %' : '-',
              style: TextStyle(
                color: value > 0 ? theme.secondary : theme.textDisabled,
                fontSize: 12,
                fontWeight: value > 0 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
      PlutoColumn(
        title: '\$DPP',
        field: 'montoDPP',
        type: PlutoColumnType.currency(
          symbol: '\$ ',
          decimalDigits: 2,
        ),
        width: 120,
        enableEditingMode: false,
        renderer: (rendererContext) {
          final rawValue = rendererContext.cell.value;
          final value =
              rawValue is int ? rawValue.toDouble() : (rawValue as double);
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            alignment: Alignment.centerRight,
            child: value > 0
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      moneyFormat(value),
                      style: TextStyle(
                        color: theme.secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Text(
                    '-',
                    style: TextStyle(
                      color: theme.textDisabled,
                      fontSize: 12,
                    ),
                  ),
          );
        },
      ),
      PlutoColumn(
        title: 'Esquema',
        field: 'esquema',
        type: PlutoColumnType.text(),
        width: 140,
        enableEditingMode: false,
        renderer: (rendererContext) {
          final esquema = rendererContext.cell.value as String;
          return Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: esquema.toLowerCase() == EsquemaPago.pull
                ? StatusBadge.pull(context)
                : StatusBadge.push(context),
          );
        },
      ),
      PlutoColumn(
        title: 'Estado',
        field: 'estado',
        type: PlutoColumnType.text(),
        width: 120,
        enableEditingMode: false,
        renderer: (rendererContext) {
          final estado = rendererContext.cell.value as String;
          return Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: _buildEstadoBadge(estado),
          );
        },
      ),
      PlutoColumn(
        title: 'Vencimiento',
        field: 'fechaVencimiento',
        type: PlutoColumnType.text(),
        width: 130,
        enableEditingMode: false,
        renderer: (rendererContext) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            child: Text(
              rendererContext.cell.value,
              style: TextStyle(
                color: theme.textSecondary,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Acciones',
        field: 'acciones',
        type: PlutoColumnType.text(),
        width: 140,
        enableEditingMode: false,
        frozen: PlutoColumnFrozen.end,
        renderer: (rendererContext) {
          final facturaId = rendererContext.row.cells['id']!.value;
          final factura = facturas.firstWhere((f) => f.id == facturaId);

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.edit, size: 18, color: theme.primary),
                onPressed: () => _editFactura(context, factura),
                tooltip: 'Editar',
              ),
              IconButton(
                icon: Icon(Icons.delete, size: 18, color: theme.error),
                onPressed: () => _deleteFactura(context, factura),
                tooltip: 'Eliminar',
              ),
            ],
          );
        },
      ),
    ];

    return Container(
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: PlutoGrid(
          key: ValueKey('factura_grid_$themeMode'),
          columns: columns,
          rows: [],
          onLoaded: (PlutoGridOnLoadedEvent event) {
            _stateManager = event.stateManager;
            _stateManager!.setShowColumnFilter(true);
          },
          createHeader: (stateManager) => _buildHeader(context),
          configuration: PlutoGridConfiguration(
            style: PlutoGridStyleConfig(
              gridBackgroundColor: theme.surface,
              rowColor: theme.surface,
              oddRowColor: theme.primaryBackground.withOpacity(0.5),
              activatedColor: theme.primary.withOpacity(0.15),
              checkedColor: theme.secondary.withOpacity(0.2),
              cellTextStyle: TextStyle(
                color: theme.primaryText,
                fontSize: 13,
              ),
              columnTextStyle: TextStyle(
                color: theme.primaryText,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              gridBorderColor: theme.border.withOpacity(0.5),
              borderColor: theme.border.withOpacity(0.3),
              activatedBorderColor: theme.primary,
              inactivatedBorderColor: theme.border.withOpacity(0.3),
              iconColor: theme.textSecondary,
              disabledIconColor: theme.textDisabled,
              menuBackgroundColor: theme.surface,
              columnHeight: 48,
              rowHeight: 75,
              cellColorInReadOnlyState: theme.surface,
            ),
            columnSize: const PlutoGridColumnSizeConfig(
              autoSizeMode: PlutoAutoSizeMode.scale,
              resizeMode: PlutoResizeMode.normal,
            ),
          ),
          createFooter: (stateManager) {
            return PlutoLazyPagination(
              stateManager: stateManager,
              pageSizeToMove: plutoGridPageSize,
              initialPage: 1,
              initialFetch: true,
              fetchWithSorting: true,
              fetchWithFiltering: true,
              fetch: (PlutoLazyPaginationRequest request) async {
                var filteredFacturas = List.from(facturas);

                // Aplicar filtros
                if (request.filterRows.isNotEmpty) {
                  for (var filter in request.filterRows) {
                    final field = filter.cells['column']?.value;
                    final filterValue = filter.cells['value']?.value
                            ?.toString()
                            .toLowerCase() ??
                        '';

                    if (field != null && filterValue.isNotEmpty) {
                      filteredFacturas = filteredFacturas.where((f) {
                        String cellValue = '';
                        switch (field) {
                          case 'id':
                            cellValue = f.id.toLowerCase();
                            break;
                          case 'proveedor':
                            cellValue = f.proveedorNombre.toLowerCase();
                            break;
                          case 'numeroFactura':
                            cellValue = f.numeroFactura.toLowerCase();
                            break;
                          case 'esquema':
                            cellValue = f.esquema.toLowerCase();
                            break;
                          case 'estado':
                            cellValue = f.estado.toLowerCase();
                            break;
                        }
                        return cellValue.contains(filterValue);
                      }).toList();
                    }
                  }
                }

                // Aplicar ordenamiento
                if (request.sortColumn != null) {
                  filteredFacturas.sort((a, b) {
                    dynamic aValue, bValue;
                    switch (request.sortColumn!.field) {
                      case 'importe':
                        aValue = a.importe;
                        bValue = b.importe;
                        break;
                      case 'diasPago':
                        aValue = a.diasParaPago;
                        bValue = b.diasParaPago;
                        break;
                      case 'porcentajeDPP':
                        aValue = a.porcentajeDPP;
                        bValue = b.porcentajeDPP;
                        break;
                      case 'fechaVencimiento':
                        aValue = a.fechaVencimiento;
                        bValue = b.fechaVencimiento;
                        break;
                      default:
                        aValue = a.numeroFactura;
                        bValue = b.numeroFactura;
                    }
                    final compare = request.sortColumn!.sort.isAscending
                        ? Comparable.compare(aValue, bValue)
                        : Comparable.compare(bValue, aValue);
                    return compare;
                  });
                }

                final totalCount = filteredFacturas.length;
                final pageSize = plutoGridPageSize;
                final start = (request.page - 1) * pageSize;
                final end = (start + pageSize).clamp(0, totalCount);
                final pageFacturas = filteredFacturas.sublist(start, end);

                final rows = pageFacturas.map((factura) {
                  return PlutoRow(
                    cells: {
                      'id': PlutoCell(value: factura.id),
                      'proveedor': PlutoCell(value: factura.proveedorNombre),
                      'numeroFactura': PlutoCell(value: factura.numeroFactura),
                      'importe': PlutoCell(value: factura.importe),
                      'diasPago': PlutoCell(value: factura.diasParaPago),
                      'porcentajeDPP': PlutoCell(value: factura.porcentajeDPP),
                      'montoDPP': PlutoCell(value: factura.montoDPP),
                      'esquema': PlutoCell(value: factura.esquema),
                      'estado': PlutoCell(value: factura.estado),
                      'fechaVencimiento': PlutoCell(
                        value: formatDate(factura.fechaVencimiento),
                      ),
                      'acciones': PlutoCell(value: ''),
                    },
                  );
                }).toList();

                return PlutoLazyPaginationResponse(
                  totalPage: (totalCount / pageSize).ceil(),
                  rows: rows,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = AppTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surface,
        border: Border(
          bottom: BorderSide(color: theme.border.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          // Icono
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.receipt_long,
              color: theme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Gestión de Facturas',
            style: theme.subtitle1.override(
              fontFamily: theme.subtitle1Family,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: theme.primaryText,
            ),
          ),
          const Spacer(),
          // Botón
          ElevatedButton.icon(
            onPressed: () => _createFactura(context),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Nueva Factura'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstadoBadge(String estado) {
    switch (estado) {
      case EstadoFactura.pendiente:
        return StatusBadge.pendiente(context);
      case EstadoFactura.pagada:
        return StatusBadge.pagada(context);
      case EstadoFactura.vencida:
        return StatusBadge.vencida(context);
      case EstadoFactura.cancelada:
        return StatusBadge.cancelada(context);
      default:
        return StatusBadge.pendiente(context);
    }
  }

  void _createFactura(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const FacturaFormDialog(),
    );
  }

  void _editFactura(BuildContext context, factura) {
    showDialog(
      context: context,
      builder: (context) => FacturaFormDialog(factura: factura),
    );
  }

  void _deleteFactura(BuildContext context, factura) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Factura'),
        content: Text(
            '¿Estás seguro de eliminar la factura ${factura.numeroFactura}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<FacturaProvider>().deleteFactura(factura.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Factura eliminada correctamente')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.of(context).error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
