import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:facturacion_demo/models/models.dart';
import 'package:facturacion_demo/providers/proveedor_provider.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// PROVEEDOR FORM DIALOG
/// ============================================================================
/// Formulario para crear o editar proveedores
/// Validaciones de campos obligatorios y formato
/// ============================================================================
class ProveedorFormDialog extends StatefulWidget {
  final Proveedor? proveedor;

  const ProveedorFormDialog({super.key, this.proveedor});

  @override
  State<ProveedorFormDialog> createState() => _ProveedorFormDialogState();
}

class _ProveedorFormDialogState extends State<ProveedorFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreController;
  late TextEditingController _rfcController;
  late TextEditingController _diasPagoController;
  late TextEditingController _porcentajeDPPController;
  late TextEditingController _diasGraciaDPPController;
  late TextEditingController _contactoController;
  late TextEditingController _emailController;

  String _esquemaActivo = EsquemaPago.push;
  bool _dppPermitido = true;
  String _estado = 'activo';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _nombreController =
        TextEditingController(text: widget.proveedor?.nombre ?? '');
    _rfcController = TextEditingController(text: widget.proveedor?.rfc ?? '');
    _diasPagoController = TextEditingController(
      text: widget.proveedor?.diasPago.toString() ?? '30',
    );
    _porcentajeDPPController = TextEditingController(
      text: widget.proveedor?.porcentajeDPPBase.toStringAsFixed(2) ?? '3.00',
    );
    _diasGraciaDPPController = TextEditingController(
      text: widget.proveedor?.diasGraciaDPP.toString() ?? '15',
    );
    _contactoController =
        TextEditingController(text: widget.proveedor?.contacto ?? '');
    _emailController =
        TextEditingController(text: widget.proveedor?.email ?? '');

    if (widget.proveedor != null) {
      _esquemaActivo = widget.proveedor!.esquemaActivo;
      _dppPermitido = widget.proveedor!.dppPermitido;
      _estado = widget.proveedor!.estado.toString().split('.').last;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _rfcController.dispose();
    _diasPagoController.dispose();
    _porcentajeDPPController.dispose();
    _diasGraciaDPPController.dispose();
    _contactoController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final isEditing = widget.proveedor != null;

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Padding(
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
                        isEditing ? Icons.edit : Icons.add_business,
                        color: theme.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isEditing ? 'Editar Proveedor' : 'Nuevo Proveedor',
                          style: TextStyle(
                            color: theme.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Nombre
                  _buildTextField(
                    controller: _nombreController,
                    label: 'Nombre del Proveedor',
                    hint: 'Ej: Nexus Industries',
                    icon: Icons.business,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El nombre es obligatorio';
                      }
                      if (value.trim().length < 3) {
                        return 'El nombre debe tener al menos 3 caracteres';
                      }
                      return null;
                    },
                    theme: theme,
                  ),
                  const SizedBox(height: 16),

                  // RFC
                  _buildTextField(
                    controller: _rfcController,
                    label: 'RFC',
                    hint: 'Ej: NEX980512ABC',
                    icon: Icons.badge,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El RFC es obligatorio';
                      }
                      if (value.trim().length < 12 ||
                          value.trim().length > 13) {
                        return 'RFC inválido (12-13 caracteres)';
                      }
                      return null;
                    },
                    theme: theme,
                  ),
                  const SizedBox(height: 16),

                  // Esquema (Radio buttons)
                  Text(
                    'Esquema de Pago',
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('PUSH NC-Pago'),
                          value: EsquemaPago.push,
                          groupValue: _esquemaActivo,
                          onChanged: (value) =>
                              setState(() => _esquemaActivo = value!),
                          activeColor: theme.primary,
                          dense: true,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('PULL NC-Pago'),
                          value: EsquemaPago.pull,
                          groupValue: _esquemaActivo,
                          onChanged: (value) =>
                              setState(() => _esquemaActivo = value!),
                          activeColor: theme.secondary,
                          dense: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Días de Pago
                  _buildTextField(
                    controller: _diasPagoController,
                    label: 'Días de Pago',
                    hint: 'Ej: 30',
                    icon: Icons.calendar_today,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Los días de pago son obligatorios';
                      }
                      final dias = int.tryParse(value);
                      if (dias == null || dias < 1 || dias > 365) {
                        return 'Días inválidos (1-365)';
                      }
                      return null;
                    },
                    theme: theme,
                  ),
                  const SizedBox(height: 16),

                  // DPP Permitido (Switch)
                  SwitchListTile(
                    title: Text(
                      'DPP Permitido',
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Permite descuentos por pronto pago',
                      style:
                          TextStyle(color: theme.textSecondary, fontSize: 12),
                    ),
                    value: _dppPermitido,
                    onChanged: (value) => setState(() => _dppPermitido = value),
                    activeColor: theme.success,
                  ),
                  const SizedBox(height: 8),

                  // Campos DPP (solo si está permitido)
                  if (_dppPermitido) ...[
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _porcentajeDPPController,
                            label: '% DPP Base',
                            hint: 'Ej: 3.00',
                            icon: Icons.percent,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Requerido';
                              }
                              final porcentaje = double.tryParse(value);
                              if (porcentaje == null ||
                                  porcentaje < 0 ||
                                  porcentaje > 20) {
                                return 'Inválido (0-20)';
                              }
                              return null;
                            },
                            theme: theme,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _diasGraciaDPPController,
                            label: 'Días Gracia DPP',
                            hint: 'Ej: 15',
                            icon: Icons.timelapse,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Requerido';
                              }
                              final dias = int.tryParse(value);
                              if (dias == null || dias < 1 || dias > 90) {
                                return 'Inválido (1-90)';
                              }
                              return null;
                            },
                            theme: theme,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Contacto
                  _buildTextField(
                    controller: _contactoController,
                    label: 'Contacto',
                    hint: 'Ej: Carlos Mendoza',
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El contacto es obligatorio';
                      }
                      return null;
                    },
                    theme: theme,
                  ),
                  const SizedBox(height: 16),

                  // Email
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Ej: contacto@empresa.com',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El email es obligatorio';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Email inválido';
                      }
                      return null;
                    },
                    theme: theme,
                  ),
                  const SizedBox(height: 16),

                  // Estado (Radio buttons)
                  Text(
                    'Estado',
                    style: TextStyle(
                      color: theme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Activo'),
                          value: 'activo',
                          groupValue: _estado,
                          onChanged: (value) =>
                              setState(() => _estado = value!),
                          activeColor: theme.success,
                          dense: true,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Inactivo'),
                          value: 'inactivo',
                          groupValue: _estado,
                          onChanged: (value) =>
                              setState(() => _estado = value!),
                          activeColor: theme.textSecondary,
                          dense: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Botones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(color: theme.textSecondary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _handleSubmit,
                        icon: _isLoading
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Icon(isEditing ? Icons.save : Icons.add,
                                size: 18),
                        label: Text(
                            isEditing ? 'Guardar Cambios' : 'Crear Proveedor'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required AppTheme theme,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: theme.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: theme.textSecondary, size: 20),
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.error, width: 2),
            ),
            filled: true,
            fillColor: theme.primaryBackground,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final proveedorProvider = context.read<ProveedorProvider>();

      final proveedor = Proveedor(
        id: widget.proveedor?.id ??
            'PROV-${DateTime.now().millisecondsSinceEpoch}',
        nombre: _nombreController.text.trim(),
        rfc: _rfcController.text.trim().toUpperCase(),
        esquemaActivo: _esquemaActivo,
        diasPago: int.parse(_diasPagoController.text),
        dppPermitido: _dppPermitido,
        porcentajeDPPBase: double.parse(_porcentajeDPPController.text),
        diasGraciaDPP: int.parse(_diasGraciaDPPController.text),
        contacto: _contactoController.text.trim(),
        email: _emailController.text.trim().toLowerCase(),
        estado: _estado == 'activo'
            ? EstadoProveedor.activo
            : EstadoProveedor.inactivo,
      );

      if (widget.proveedor != null) {
        proveedorProvider.updateProveedor(proveedor);
        _showSnackBar('Proveedor actualizado correctamente', isError: false);
      } else {
        proveedorProvider.addProveedor(proveedor);
        _showSnackBar('Proveedor creado correctamente', isError: false);
      }

      Navigator.of(context).pop();
    } catch (e) {
      _showSnackBar('Error al guardar el proveedor: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? theme.error : theme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
