import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:facturacion_demo/providers/factura_provider.dart';
import 'package:facturacion_demo/providers/proveedor_provider.dart';
import 'package:facturacion_demo/models/models.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// FACTURA FORM DIALOG
/// ============================================================================
/// Diálogo para crear/editar facturas
/// ============================================================================

class FacturaFormDialog extends StatefulWidget {
  final Factura? factura;

  const FacturaFormDialog({super.key, this.factura});

  @override
  State<FacturaFormDialog> createState() => _FacturaFormDialogState();
}

class _FacturaFormDialogState extends State<FacturaFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _numeroFacturaController;
  late TextEditingController _importeController;
  late TextEditingController _diasPagoController;
  late TextEditingController _porcentajeDPPController;

  String? _selectedProveedorId;
  String _selectedEsquema = EsquemaPago.pull;
  String _selectedEstado = EstadoFactura.pendiente;
  DateTime _fechaEmision = DateTime.now();
  DateTime? _fechaVencimiento;

  @override
  void initState() {
    super.initState();

    _numeroFacturaController = TextEditingController(
      text: widget.factura?.numeroFactura ?? '',
    );
    _importeController = TextEditingController(
      text: widget.factura?.importe.toString() ?? '',
    );
    _diasPagoController = TextEditingController(
      text: widget.factura?.diasParaPago.toString() ?? '30',
    );
    _porcentajeDPPController = TextEditingController(
      text: widget.factura?.porcentajeDPP.toString() ?? '0',
    );

    if (widget.factura != null) {
      _selectedProveedorId = widget.factura!.proveedorId;
      _selectedEsquema = widget.factura!.esquema;
      _selectedEstado = widget.factura!.estado;
      _fechaEmision = widget.factura!.fechaEmision;
      _fechaVencimiento = widget.factura!.fechaVencimiento;
    }
  }

  @override
  void dispose() {
    _numeroFacturaController.dispose();
    _importeController.dispose();
    _diasPagoController.dispose();
    _porcentajeDPPController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final proveedorProvider = context.watch<ProveedorProvider>();
    final proveedores = proveedorProvider.proveedores;

    return Dialog(
      backgroundColor: theme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    widget.factura == null ? Icons.add : Icons.edit,
                    color: theme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.factura == null ? 'Nueva Factura' : 'Editar Factura',
                    style: theme.subtitle1.override(
                      fontFamily: theme.subtitle1Family,
                      fontSize: 24,
                      color: theme.primaryText,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: theme.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Form fields
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Proveedor
                      Text(
                        'Proveedor *',
                        style: theme.bodyText2.override(
                          fontFamily: theme.bodyText2Family,
                          color: theme.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedProveedorId,
                        decoration: InputDecoration(
                          hintText: 'Selecciona un proveedor',
                          filled: true,
                          fillColor: theme.formBackground,
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
                            borderSide:
                                BorderSide(color: theme.primary, width: 2),
                          ),
                        ),
                        items: proveedores.map((p) {
                          return DropdownMenuItem(
                            value: p.id,
                            child: Text(p.nombre),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedProveedorId = value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Selecciona un proveedor';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Número de factura
                      Text(
                        'Número de Factura *',
                        style: theme.bodyText2.override(
                          fontFamily: theme.bodyText2Family,
                          color: theme.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _numeroFacturaController,
                        decoration: InputDecoration(
                          hintText: 'Ej: FAC-2026-001',
                          filled: true,
                          fillColor: theme.formBackground,
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
                            borderSide:
                                BorderSide(color: theme.primary, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa el número de factura';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Importe y Días de pago (fila)
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Importe (USD) *',
                                  style: theme.bodyText2.override(
                                    fontFamily: theme.bodyText2Family,
                                    color: theme.primaryText,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _importeController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}')),
                                  ],
                                  decoration: InputDecoration(
                                    hintText: '0.00',
                                    prefixText: '\$ ',
                                    filled: true,
                                    fillColor: theme.formBackground,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: theme.border),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: theme.border),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: theme.primary, width: 2),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Ingresa el importe';
                                    }
                                    final amount = double.tryParse(value);
                                    if (amount == null || amount <= 0) {
                                      return 'Importe inválido';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Días para Pago *',
                                  style: theme.bodyText2.override(
                                    fontFamily: theme.bodyText2Family,
                                    color: theme.primaryText,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _diasPagoController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    hintText: '30',
                                    filled: true,
                                    fillColor: theme.formBackground,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: theme.border),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: theme.border),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: theme.primary, width: 2),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Ingresa los días';
                                    }
                                    final days = int.tryParse(value);
                                    if (days == null || days <= 0) {
                                      return 'Días inválidos';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Porcentaje DPP
                      Text(
                        'Porcentaje DPP (%)',
                        style: theme.bodyText2.override(
                          fontFamily: theme.bodyText2Family,
                          color: theme.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _porcentajeDPPController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        decoration: InputDecoration(
                          hintText: '0.00',
                          suffixText: '%',
                          filled: true,
                          fillColor: theme.formBackground,
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
                            borderSide:
                                BorderSide(color: theme.primary, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Esquema y Estado (fila)
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Esquema de Pago *',
                                  style: theme.bodyText2.override(
                                    fontFamily: theme.bodyText2Family,
                                    color: theme.primaryText,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: _selectedEsquema,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: theme.formBackground,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: theme.border),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: theme.border),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: theme.primary, width: 2),
                                    ),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: EsquemaPago.pull,
                                      child: Text('PULL NC-Pago'),
                                    ),
                                    DropdownMenuItem(
                                      value: EsquemaPago.push,
                                      child: Text('PUSH NC-Pago'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() => _selectedEsquema = value!);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Estado *',
                                  style: theme.bodyText2.override(
                                    fontFamily: theme.bodyText2Family,
                                    color: theme.primaryText,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: _selectedEstado,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: theme.formBackground,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: theme.border),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: theme.border),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: theme.primary, width: 2),
                                    ),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: EstadoFactura.pendiente,
                                      child: Text('Pendiente'),
                                    ),
                                    DropdownMenuItem(
                                      value: EstadoFactura.pagada,
                                      child: Text('Pagada'),
                                    ),
                                    DropdownMenuItem(
                                      value: EstadoFactura.vencida,
                                      child: Text('Vencida'),
                                    ),
                                    DropdownMenuItem(
                                      value: EstadoFactura.cancelada,
                                      child: Text('Cancelada'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() => _selectedEstado = value!);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _saveFactura,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(widget.factura == null ? 'Crear' : 'Guardar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveFactura() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final facturaProvider = context.read<FacturaProvider>();
    final proveedor = context
        .read<ProveedorProvider>()
        .proveedores
        .firstWhere((p) => p.id == _selectedProveedorId!);

    final importe = double.parse(_importeController.text);
    final diasPago = int.parse(_diasPagoController.text);
    final porcentajeDPP = double.tryParse(_porcentajeDPPController.text) ?? 0.0;

    final fechaVencimiento = _fechaEmision.add(Duration(days: diasPago));
    final montoDPP = importe * (porcentajeDPP / 100);
    final montoConDPP = importe - montoDPP;

    if (widget.factura == null) {
      // Crear nueva factura
      final nuevaFactura = Factura(
        id: 'FAC-${DateTime.now().millisecondsSinceEpoch}',
        proveedorId: _selectedProveedorId!,
        proveedorNombre: proveedor.nombre,
        numeroFactura: _numeroFacturaController.text,
        importe: importe,
        moneda: monedaPredeterminada,
        fechaEmision: _fechaEmision,
        fechaVencimiento: fechaVencimiento,
        diasParaPago: diasPago,
        porcentajeDPP: porcentajeDPP,
        montoDPP: montoDPP,
        montoConDPP: montoConDPP,
        esquema: _selectedEsquema,
        estado: _selectedEstado,
      );

      facturaProvider.addFactura(nuevaFactura);

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Factura creada correctamente')),
      );
    } else {
      // Actualizar factura existente
      final facturaActualizada = Factura(
        id: widget.factura!.id,
        proveedorId: _selectedProveedorId!,
        proveedorNombre: proveedor.nombre,
        numeroFactura: _numeroFacturaController.text,
        importe: importe,
        moneda: monedaPredeterminada,
        fechaEmision: _fechaEmision,
        fechaVencimiento: fechaVencimiento,
        diasParaPago: diasPago,
        porcentajeDPP: porcentajeDPP,
        montoDPP: montoDPP,
        montoConDPP: montoConDPP,
        esquema: _selectedEsquema,
        estado: _selectedEstado,
        notaCreditoId: widget.factura!.notaCreditoId,
        fechaPago: widget.factura!.fechaPago,
      );

      facturaProvider.updateFactura(facturaActualizada);

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Factura actualizada correctamente')),
      );
    }
  }
}
