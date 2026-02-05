import 'package:flutter/material.dart';
import 'package:facturacion_demo/theme/theme.dart';

/// ============================================================================
/// PAYMENT ACTIONS WIDGET
/// ============================================================================
/// Botones de acción para proponer y ejecutar pagos optimizados
/// ============================================================================
class PaymentActions extends StatelessWidget {
  final bool isDisabled;
  final VoidCallback onProponer;
  final VoidCallback onEjecutar;

  const PaymentActions({
    super.key,
    required this.isDisabled,
    required this.onProponer,
    required this.onEjecutar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 768;

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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Título
          Row(
            children: [
              Icon(Icons.touch_app, color: theme.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                'Acciones de Pago',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Botón Proponer Pago
          SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: isDisabled ? null : onProponer,
              icon: const Icon(Icons.lightbulb_outline),
              label: Text(
                'Proponer Pago',
                style: TextStyle(
                  fontSize: isMobile ? 15 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.secondary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: theme.border,
                disabledForegroundColor: theme.textDisabled,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: isDisabled ? 0 : 2,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Botón Ejecutar Pago
          SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: isDisabled ? null : onEjecutar,
              icon: const Icon(Icons.check_circle),
              label: Text(
                'Ejecutar Pago',
                style: TextStyle(
                  fontSize: isMobile ? 15 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: theme.border,
                disabledForegroundColor: theme.textDisabled,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: isDisabled ? 0 : 2,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Información adicional
          if (isDisabled)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.warning.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: theme.warning,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Selecciona al menos una factura para habilitar las acciones',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.success.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: theme.success,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Listo para optimizar. Proponer guardará la propuesta, Ejecutar realizará el pago.',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),
          Divider(color: theme.border),
          const SizedBox(height: 16),

          // Nota sobre simulación
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                color: theme.textSecondary.withOpacity(0.5),
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Demo: Las acciones son simuladas. En producción se conectarían a servicios de pago reales.',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.textSecondary.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
