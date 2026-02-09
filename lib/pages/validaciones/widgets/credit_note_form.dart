import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facturacion_demo/models/models.dart';
import 'package:facturacion_demo/providers/validacion_provider.dart';
import 'package:facturacion_demo/providers/factura_provider.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/functions/money_format.dart';

/// ============================================================================
/// CREDIT NOTE FORM DIALOG
/// ============================================================================
/// Formulario para crear notas de crédito
/// ============================================================================
class CreditNoteFormDialog extends StatefulWidget {
  const CreditNoteFormDialog({super.key});

  @override
  State<CreditNoteFormDialog> createState() => _CreditNoteFormDialogState();
}

class _CreditNoteFormDialogState extends State<CreditNoteFormDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedFacturaId;
  double _monto = 0.0;
  String _motivo = '';

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final facturaProvider = context.watch<FacturaProvider>();
    final validacionProvider = context.read<ValidacionProvider>();

    // Obtener facturas disponibles (pagadas o pendientes)
    final facturasDisponibles = facturaProvider.facturas
        .where((f) => f.estado == 'pagada' || f.estado == 'pendiente')
        .toList();

    return Dialog(
      backgroundColor: theme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 24,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 650, maxHeight: 750),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.success.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.receipt_long,
                        color: theme.success,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nueva Nota de Crédito',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: theme.textPrimary,
                            ),
                          ),
                          Text(
                            'Crear una nota de crédito para una factura',
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      color: theme.textSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Divider(color: theme.border),
                const SizedBox(height: 24),

                // Selector de factura
                Text(
                  'Factura',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: 'Seleccionar factura',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: theme.primaryBackground,
                    prefixIcon: Icon(Icons.search, color: theme.textSecondary),
                  ),
                  value: _selectedFacturaId,
                  items: facturasDisponibles.map((factura) {
                    return DropdownMenuItem<String>(
                      value: factura.id,
                      child: Text(
                        '${factura.numeroFactura} - ${factura.proveedorNombre} (${moneyFormatCompact(factura.importe)})',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFacturaId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Debe seleccionar una factura';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Monto
                Text(
                  'Monto de la Nota de Crédito',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: '0.00',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: theme.primaryBackground,
                    prefixIcon: Icon(
                      Icons.attach_money,
                      color: theme.success,
                    ),
                    suffixText: 'USD',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (value) {
                    _monto = double.tryParse(value) ?? 0.0;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el monto';
                    }
                    final monto = double.tryParse(value);
                    if (monto == null || monto <= 0) {
                      return 'Ingrese un monto válido mayor a 0';
                    }
                    // Validar que no exceda el monto de la factura
                    if (_selectedFacturaId != null) {
                      final factura =
                          facturaProvider.getFacturaById(_selectedFacturaId!);
                      if (factura != null && monto > factura.importe) {
                        return 'El monto no puede exceder el importe de la factura';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Motivo
                Text(
                  'Motivo',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Describa el motivo de la nota de crédito...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: theme.primaryBackground,
                    prefixIcon: Icon(
                      Icons.edit_note,
                      color: theme.textSecondary,
                    ),
                  ),
                  maxLines: 4,
                  onChanged: (value) {
                    _motivo = value;
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingrese el motivo';
                    }
                    if (value.trim().length < 10) {
                      return 'El motivo debe tener al menos 10 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Información adicional
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: theme.accent.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.accent,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '¿Qué es una Nota de Crédito?',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: theme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Documento que ajusta el monto de una factura (devoluciones, descuentos, correcciones). Se crea en estado "Pendiente" y requiere aprobación antes de aplicarse.',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Botones
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: theme.textSecondary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () => _handleSubmit(
                        context,
                        validacionProvider,
                      ),
                      icon: const Icon(Icons.check),
                      label: const Text('Crear Nota de Crédito'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit(
    BuildContext context,
    ValidacionProvider validacionProvider,
  ) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Crear validación de tipo nota_credito
    final nuevaValidacion = Validacion(
      id: 'VAL-NC-${DateTime.now().millisecondsSinceEpoch}',
      tipo: 'nota_credito',
      facturaId: _selectedFacturaId!,
      descripcion:
          'Nota de cr\u00e9dito por ${moneyFormat(_monto)}. Motivo: $_motivo',
      estado: 'pendiente',
      fecha: DateTime.now(),
      motivo: _motivo,
    );

    validacionProvider.addValidacion(nuevaValidacion);

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                  'Nota de crédito creada exitosamente. Pendiente de aprobación.'),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
      ),
    );
  }
}
