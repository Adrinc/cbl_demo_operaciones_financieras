import 'package:flutter/material.dart';
import 'package:facturacion_demo/models/models.dart';
import 'package:facturacion_demo/theme/theme.dart';

/// ============================================================================
/// SCENARIO CONTROLS WIDGET
/// ============================================================================
/// Controles interactivos para ajustar parámetros de simulación
/// Incluye sliders, dropdowns y toggles
/// ============================================================================
class ScenarioControls extends StatelessWidget {
  final double dppPercentage;
  final int paymentDays;
  final String selectedScheme;
  final Set<String> selectedProveedores;
  final List<Proveedor> proveedores;
  final Function(double) onDppChanged;
  final Function(int) onDaysChanged;
  final Function(String) onSchemeChanged;
  final Function(Set<String>) onProveedoresChanged;

  const ScenarioControls({
    super.key,
    required this.dppPercentage,
    required this.paymentDays,
    required this.selectedScheme,
    required this.selectedProveedores,
    required this.proveedores,
    required this.onDppChanged,
    required this.onDaysChanged,
    required this.onSchemeChanged,
    required this.onProveedoresChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

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
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.accent.withOpacity(0.15),
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
                Icon(Icons.tune, color: theme.accent, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Parámetros de Simulación',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DPP Percentage Slider
                _buildControlSection(
                  icon: Icons.percent,
                  title: 'Porcentaje de DPP',
                  theme: theme,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Descuento por pronto pago',
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.textSecondary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: theme.success.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.success,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '${dppPercentage.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.success,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: theme.success,
                          inactiveTrackColor: theme.border,
                          thumbColor: theme.success,
                          overlayColor: theme.success.withOpacity(0.2),
                          valueIndicatorColor: theme.success,
                        ),
                        child: Slider(
                          value: dppPercentage,
                          min: 0,
                          max: 10,
                          divisions: 100,
                          label: '${dppPercentage.toStringAsFixed(1)}%',
                          onChanged: onDppChanged,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '0%',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.textSecondary,
                            ),
                          ),
                          Text(
                            '10%',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Payment Days Slider
                _buildControlSection(
                  icon: Icons.calendar_today,
                  title: 'Días de Pago',
                  theme: theme,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Plazo de pago desde emisión',
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.textSecondary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: theme.primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.primary,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '$paymentDays días',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: theme.primary,
                          inactiveTrackColor: theme.border,
                          thumbColor: theme.primary,
                          overlayColor: theme.primary.withOpacity(0.2),
                          valueIndicatorColor: theme.primary,
                        ),
                        child: Slider(
                          value: paymentDays.toDouble(),
                          min: 1,
                          max: 90,
                          divisions: 89,
                          label: '$paymentDays días',
                          onChanged: (value) => onDaysChanged(value.toInt()),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '1 día',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.textSecondary,
                            ),
                          ),
                          Text(
                            '90 días',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Payment Scheme Toggle
                _buildControlSection(
                  icon: Icons.swap_horiz,
                  title: 'Esquema de Pago',
                  theme: theme,
                  child: Column(
                    children: [
                      _buildSchemeButton('push', 'PUSH NC-Pago', theme),
                      const SizedBox(height: 8),
                      _buildSchemeButton('pull', 'PULL NC-Pago', theme),
                      const SizedBox(height: 8),
                      _buildSchemeButton('mixto', 'Esquema Mixto', theme),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Supplier Selection
                _buildControlSection(
                  icon: Icons.business,
                  title: 'Proveedores',
                  theme: theme,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedProveedores.isEmpty
                            ? 'Todos los proveedores'
                            : '${selectedProveedores.length} seleccionados',
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          // Botón "Todos"
                          _buildProveedorChip(
                            'Todos',
                            selectedProveedores.isEmpty,
                            () => onProveedoresChanged({}),
                            theme,
                          ),
                          // Chips de proveedores
                          ...proveedores.take(6).map((p) {
                            final isSelected =
                                selectedProveedores.contains(p.id);
                            return _buildProveedorChip(
                              p.nombre.split(' ').first,
                              isSelected,
                              () {
                                final newSet =
                                    Set<String>.from(selectedProveedores);
                                if (isSelected) {
                                  newSet.remove(p.id);
                                } else {
                                  newSet.add(p.id);
                                }
                                onProveedoresChanged(newSet);
                              },
                              theme,
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Reset Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      onDppChanged(3.0);
                      onDaysChanged(30);
                      onSchemeChanged('pull');
                      onProveedoresChanged({});
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Restablecer valores'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.textSecondary,
                      side: BorderSide(color: theme.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlSection({
    required IconData icon,
    required String title,
    required AppTheme theme,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: theme.textSecondary, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: theme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildSchemeButton(String value, String label, AppTheme theme) {
    final isSelected = selectedScheme == value;
    return InkWell(
      onTap: () => onSchemeChanged(value),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.secondary.withOpacity(0.15)
              : theme.primaryBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? theme.secondary : theme.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? theme.secondary : theme.textSecondary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? theme.secondary : theme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProveedorChip(
    String label,
    bool isSelected,
    VoidCallback onTap,
    AppTheme theme,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.accent.withOpacity(0.15)
              : theme.primaryBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? theme.accent : theme.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? theme.accent : theme.textSecondary,
          ),
        ),
      ),
    );
  }
}
