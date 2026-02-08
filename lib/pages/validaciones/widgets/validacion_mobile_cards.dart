import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facturacion_demo/models/models.dart';
import 'package:facturacion_demo/providers/validacion_provider.dart';
import 'package:facturacion_demo/providers/factura_provider.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/functions/date_format.dart';

/// ============================================================================
/// VALIDACION MOBILE CARDS
/// ============================================================================
/// Tarjetas de validaciones para vista móvil
/// Con paginación y acciones
/// ============================================================================
class ValidacionMobileCards extends StatefulWidget {
  final List<Validacion> validaciones;
  final String tipo;

  const ValidacionMobileCards({
    super.key,
    required this.validaciones,
    required this.tipo,
  });

  @override
  State<ValidacionMobileCards> createState() => _ValidacionMobileCardsState();
}

class _ValidacionMobileCardsState extends State<ValidacionMobileCards> {
  int _currentPage = 0;
  final int _itemsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final totalPages =
        (widget.validaciones.length / _itemsPerPage).ceil().clamp(1, 999);
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex =
        (startIndex + _itemsPerPage).clamp(0, widget.validaciones.length);
    final currentItems = widget.validaciones.sublist(startIndex, endIndex);

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Header info
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.accent.withOpacity(0.1),
                theme.primary.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: theme.border),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: theme.accent, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Mostrando ${currentItems.length} de ${widget.validaciones.length} validaciones',
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Cards
        ...currentItems.map((validacion) => _buildCard(validacion, theme)),

        // Paginación
        if (totalPages > 1) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: theme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: theme.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _currentPage > 0
                      ? () => setState(() => _currentPage--)
                      : null,
                  icon: const Icon(Icons.chevron_left),
                  color: theme.primary,
                  disabledColor: theme.textDisabled,
                ),
                Text(
                  'Página ${_currentPage + 1} de $totalPages',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: _currentPage < totalPages - 1
                      ? () => setState(() => _currentPage++)
                      : null,
                  icon: const Icon(Icons.chevron_right),
                  color: theme.primary,
                  disabledColor: theme.textDisabled,
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCard(Validacion validacion, AppTheme theme) {
    final facturaProvider = context.read<FacturaProvider>();
    final factura = facturaProvider.getFacturaById(validacion.facturaId);
    final numeroFactura = factura?.numeroFactura ?? 'N/A';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: theme.textPrimary.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con tipo y estado
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.primary.withOpacity(0.08),
                  theme.accent.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                _buildTipoIcon(validacion.tipo, theme),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getTipoLabel(validacion.tipo),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.textPrimary,
                        ),
                      ),
                      Text(
                        validacion.id,
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.textSecondary,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                _buildEstadoBadge(validacion.estado, theme),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Factura
                _buildInfoRow(
                  icon: Icons.receipt_long,
                  label: 'Factura',
                  value: numeroFactura,
                  theme: theme,
                ),
                const SizedBox(height: 12),

                // Descripción
                _buildInfoRow(
                  icon: Icons.description,
                  label: 'Descripción',
                  value: validacion.descripcion,
                  theme: theme,
                  maxLines: 3,
                ),
                const SizedBox(height: 12),

                // Fecha
                _buildInfoRow(
                  icon: Icons.calendar_today,
                  label: 'Fecha',
                  value: formatDate(validacion.fecha),
                  theme: theme,
                ),

                // Acciones (solo si está pendiente)
                if (validacion.estado == 'pendiente') ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _handleAprobar(context, validacion.id),
                          icon:
                              const Icon(Icons.check_circle_rounded, size: 20),
                          label: const Text('Aprobar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.success,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              _handleRechazar(context, validacion.id),
                          icon: Icon(Icons.cancel_rounded,
                              size: 20, color: theme.error),
                          label: Text('Rechazar',
                              style: TextStyle(color: theme.error)),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: theme.error, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        validacion.estado == 'aprobado'
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        color: validacion.estado == 'aprobado'
                            ? theme.success
                            : theme.error,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        validacion.estado == 'aprobado'
                            ? 'Esta validación ya fue aprobada'
                            : 'Esta validación fue rechazada',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.textSecondary,
                          fontStyle: FontStyle.italic,
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
    );
  }

  Widget _buildTipoIcon(String tipo, AppTheme theme) {
    IconData icon;
    Color color;

    switch (tipo) {
      case 'nota_credito':
        icon = Icons.receipt_long;
        color = theme.accent;
        break;
      case 'estado_pago':
        icon = Icons.payment;
        color = theme.secondary;
        break;
      case 'condicion_comercial':
        icon = Icons.handshake;
        color = theme.primary;
        break;
      default:
        icon = Icons.description;
        color = theme.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  String _getTipoLabel(String tipo) {
    switch (tipo) {
      case 'nota_credito':
        return 'Nota de Crédito';
      case 'estado_pago':
        return 'Estado de Pago';
      case 'condicion_comercial':
        return 'Condición Comercial';
      default:
        return tipo;
    }
  }

  Widget _buildEstadoBadge(String estado, AppTheme theme) {
    Color color;
    IconData icon;
    String label;

    switch (estado) {
      case 'pendiente':
        color = theme.warning;
        icon = Icons.pending_outlined;
        label = 'PENDIENTE';
        break;
      case 'aprobado':
        color = theme.success;
        icon = Icons.check_circle_rounded;
        label = 'APROBADO';
        break;
      case 'rechazado':
        color = theme.error;
        icon = Icons.cancel_rounded;
        label = 'RECHAZADO';
        break;
      default:
        color = theme.textSecondary;
        icon = Icons.info;
        label = estado.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required AppTheme theme,
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: theme.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: theme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleAprobar(BuildContext context, String validacionId) {
    final validacionProvider = context.read<ValidacionProvider>();

    validacionProvider.aprobarValidacion(validacionId, 'Aprobado desde móvil');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Validación $validacionId aprobada exitosamente'),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );

    setState(() {});
  }

  void _handleRechazar(BuildContext context, String validacionId) {
    final validacionProvider = context.read<ValidacionProvider>();
    final theme = AppTheme.of(context);

    showDialog(
      context: context,
      builder: (ctx) {
        String motivo = '';
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber, color: theme.warning),
              const SizedBox(width: 12),
              const Text('Confirmar Rechazo'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('¿Estás seguro de rechazar esta validación?'),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Motivo (opcional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) => motivo = value,
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
                validacionProvider.rechazarValidacion(
                  validacionId,
                  motivo.isEmpty ? 'Rechazado desde móvil' : motivo,
                );

                Navigator.of(ctx).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.info, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text('Validación $validacionId rechazada'),
                        ),
                      ],
                    ),
                    backgroundColor: theme.error,
                    duration: const Duration(seconds: 3),
                  ),
                );

                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.error,
              ),
              child: const Text('Rechazar'),
            ),
          ],
        );
      },
    );
  }
}
