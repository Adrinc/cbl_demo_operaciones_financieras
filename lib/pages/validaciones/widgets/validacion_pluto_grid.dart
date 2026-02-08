import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';
import 'package:facturacion_demo/models/models.dart';
import 'package:facturacion_demo/providers/validacion_provider.dart';
import 'package:facturacion_demo/providers/factura_provider.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/functions/date_format.dart';

/// ============================================================================
/// VALIDACION PLUTO GRID
/// ============================================================================
/// Tabla de validaciones con PlutoGrid para desktop
/// Incluye acciones de aprobar/rechazar
/// ============================================================================
class ValidacionPlutoGrid extends StatefulWidget {
  final List<Validacion> validaciones;
  final String tipo;

  const ValidacionPlutoGrid({
    super.key,
    required this.validaciones,
    required this.tipo,
  });

  @override
  State<ValidacionPlutoGrid> createState() => _ValidacionPlutoGridState();
}

class _ValidacionPlutoGridState extends State<ValidacionPlutoGrid> {
  late PlutoGridStateManager stateManager;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final themeMode = Theme.of(context).brightness;

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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: PlutoGrid(
          key: ValueKey(themeMode),
          columns: _buildColumns(theme),
          rows: [],
          onLoaded: (PlutoGridOnLoadedEvent event) {
            stateManager = event.stateManager;
            stateManager.setShowColumnFilter(true);
          },
          createFooter: (stateManager) {
            return PlutoLazyPagination(
              pageSizeToMove: 15,
              fetch: (PlutoLazyPaginationRequest request) async {
                // Paginación correcta
                final page = request.page;
                const pageSize = 15;
                final startIndex = (page - 1) * pageSize;
                final endIndex = (startIndex + pageSize)
                    .clamp(0, widget.validaciones.length)
                    .toInt();

                final pageValidaciones = widget.validaciones.sublist(
                  startIndex.clamp(0, widget.validaciones.length).toInt(),
                  endIndex,
                );

                final rows =
                    pageValidaciones.map((v) => _buildRow(v, theme)).toList();

                return Future.value(PlutoLazyPaginationResponse(
                  totalPage: (widget.validaciones.length / pageSize).ceil(),
                  rows: rows,
                ));
              },
              stateManager: stateManager,
            );
          },
          configuration: PlutoGridConfiguration(
            style: PlutoGridStyleConfig(
              gridBackgroundColor: theme.surface,
              rowColor: theme.surface,
              activatedColor: theme.primary.withOpacity(0.1),
              checkedColor: theme.primary.withOpacity(0.15),
              cellTextStyle: TextStyle(
                color: theme.textPrimary,
                fontSize: 13,
              ),
              columnTextStyle: TextStyle(
                color: theme.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              gridBorderColor: theme.border,
              borderColor: theme.border,
              activatedBorderColor: theme.primary,
              inactivatedBorderColor: theme.border,
              iconColor: theme.textSecondary,
              disabledIconColor: theme.textDisabled,
              menuBackgroundColor: theme.surface,
              columnHeight: 48,
              rowHeight: 75,
              defaultColumnTitlePadding: const EdgeInsets.all(16),
              defaultCellPadding: const EdgeInsets.all(12),
              enableColumnBorderVertical: false,
              enableColumnBorderHorizontal: true,
              enableCellBorderVertical: false,
              enableCellBorderHorizontal: true,
              oddRowColor: theme.primaryBackground,
              evenRowColor: theme.surface,
            ),
            columnSize: const PlutoGridColumnSizeConfig(
              autoSizeMode: PlutoAutoSizeMode.scale,
              resizeMode: PlutoResizeMode.normal,
            ),
          ),
        ),
      ),
    );
  }

  List<PlutoColumn> _buildColumns(AppTheme theme) {
    return [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        width: 100,
        enableColumnDrag: false,
        enableSorting: true,
        enableContextMenu: false,
        enableDropToResize: true,
        renderer: (ctx) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.centerLeft,
            child: Text(
              ctx.cell.value,
              style: TextStyle(
                color: theme.textSecondary,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Tipo',
        field: 'tipo',
        type: PlutoColumnType.text(),
        width: 180,
        enableColumnDrag: false,
        enableSorting: true,
        renderer: (ctx) {
          final tipo = ctx.cell.value as String;
          IconData icon;
          String label;
          Color color;

          switch (tipo) {
            case 'nota_credito':
              icon = Icons.receipt_long;
              label = 'Nota de Crédito';
              color = theme.secondary;
              break;
            case 'estado_pago':
              icon = Icons.payment;
              label = 'Estado de Pago';
              color = theme.primary;
              break;
            case 'condicion_comercial':
              icon = Icons.handshake;
              label = 'Condición Comercial';
              color = theme.accent;
              break;
            default:
              icon = Icons.info;
              label = tipo;
              color = theme.textSecondary;
          }

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Factura',
        field: 'factura',
        type: PlutoColumnType.text(),
        width: 140,
        enableColumnDrag: false,
        enableSorting: true,
        renderer: (ctx) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.centerLeft,
            child: Text(
              ctx.cell.value,
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Descripción',
        field: 'descripcion',
        type: PlutoColumnType.text(),
        width: 300,
        enableColumnDrag: false,
        enableSorting: false,
        renderer: (ctx) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              ctx.cell.value,
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 13,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Fecha',
        field: 'fecha',
        type: PlutoColumnType.text(),
        width: 160,
        enableColumnDrag: false,
        enableSorting: true,
        renderer: (ctx) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.centerLeft,
            child: Text(
              ctx.cell.value,
              style: TextStyle(
                color: theme.textSecondary,
                fontSize: 13,
              ),
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Estado',
        field: 'estado',
        type: PlutoColumnType.text(),
        width: 140,
        enableColumnDrag: false,
        enableSorting: true,
        enableFilterMenuItem: true,
        renderer: (ctx) {
          final estado = ctx.cell.value as String;
          return Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: _buildEstadoBadge(estado, theme),
          );
        },
      ),
      PlutoColumn(
        title: 'Acciones',
        field: 'acciones',
        type: PlutoColumnType.text(),
        width: 180,
        enableColumnDrag: false,
        enableSorting: false,
        enableContextMenu: false,
        frozen: PlutoColumnFrozen.end,
        renderer: (ctx) {
          final validacionId = ctx.row.cells['id']!.value;
          final estado = ctx.row.cells['estado']!.value as String;

          if (estado != 'pendiente') {
            return Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text(
                estado == 'aprobado' ? 'Aprobada' : 'Rechazada',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          }

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Tooltip(
                  message: 'Aprobar',
                  child: InkWell(
                    onTap: () => _handleAprobar(context, validacionId),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.success,
                            theme.success.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: theme.success.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Tooltip(
                  message: 'Rechazar',
                  child: InkWell(
                    onTap: () => _handleRechazar(context, validacionId),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.error,
                            theme.error.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: theme.error.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.cancel_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ];
  }

  PlutoRow _buildRow(Validacion validacion, AppTheme theme) {
    // Buscar factura para obtener número
    final facturaProvider = context.read<FacturaProvider>();
    final factura = facturaProvider.getFacturaById(validacion.facturaId);
    final numeroFactura = factura?.numeroFactura ?? 'N/A';

    return PlutoRow(
      cells: {
        'id': PlutoCell(value: validacion.id),
        'tipo': PlutoCell(value: validacion.tipo),
        'factura': PlutoCell(value: numeroFactura),
        'descripcion': PlutoCell(value: validacion.descripcion),
        'fecha': PlutoCell(value: formatDate(validacion.fecha)),
        'estado': PlutoCell(value: validacion.estado),
        'acciones': PlutoCell(value: ''),
      },
    );
  }

  Widget _buildEstadoBadge(String estado, AppTheme theme) {
    switch (estado) {
      case 'pendiente':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.warning.withOpacity(0.2),
                theme.warning.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.warning, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: theme.warning.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.pending_outlined,
                color: theme.warning,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'PENDIENTE',
                style: TextStyle(
                  color: theme.warning,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      case 'aprobado':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.success.withOpacity(0.2),
                theme.success.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.success, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: theme.success.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: theme.success,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'APROBADO',
                style: TextStyle(
                  color: theme.success,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      case 'rechazado':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.error.withOpacity(0.2),
                theme.error.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.error, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: theme.error.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cancel_rounded,
                color: theme.error,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'RECHAZADO',
                style: TextStyle(
                  color: theme.error,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      default:
        return Text(estado);
    }
  }

  void _handleAprobar(BuildContext context, String validacionId) {
    final validacionProvider = context.read<ValidacionProvider>();

    validacionProvider.aprobarValidacion(validacionId, 'Aprobado desde UI');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text('Validación $validacionId aprobada exitosamente'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );

    // Recargar grid
    setState(() {});
  }

  void _handleRechazar(BuildContext context, String validacionId) {
    final validacionProvider = context.read<ValidacionProvider>();
    final theme = AppTheme.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.orange),
            SizedBox(width: 12),
            Text('Confirmar Rechazo'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('¿Estás seguro de rechazar esta validación?'),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Motivo del rechazo (opcional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Ingrese el motivo...',
              ),
              maxLines: 3,
              onChanged: (value) {
                // Store motivo if needed
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              validacionProvider.rechazarValidacion(
                  validacionId, 'Rechazado desde UI');

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.cancel, color: Colors.white),
                      const SizedBox(width: 12),
                      Text('Validación $validacionId rechazada'),
                    ],
                  ),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );

              // Recargar grid
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.error,
            ),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );
  }
}
