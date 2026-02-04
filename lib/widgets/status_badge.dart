import 'package:flutter/material.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// STATUS BADGE
/// ============================================================================
/// Badge widget para mostrar estados con colores y estilos consistentes
/// Usado para estados de facturas, pagos, validaciones, etc.
/// ============================================================================
class StatusBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final IconData? icon;
  final bool isCompact;

  const StatusBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.icon,
    this.isCompact = false,
  });

  /// Factory constructors para estados comunes

  // Estados de facturas
  factory StatusBadge.pendiente(BuildContext context, {bool isCompact = false}) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    return StatusBadge(
      text: 'Pendiente',
      backgroundColor: theme.warning.withOpacity(0.15),
      textColor: theme.warning,
      borderColor: theme.warning,
      icon: Icons.schedule,
      isCompact: isCompact,
    );
  }

  factory StatusBadge.pagada(BuildContext context, {bool isCompact = false}) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    return StatusBadge(
      text: 'Pagada',
      backgroundColor: theme.success.withOpacity(0.15),
      textColor: theme.success,
      borderColor: theme.success,
      icon: Icons.check_circle,
      isCompact: isCompact,
    );
  }

  factory StatusBadge.vencida(BuildContext context, {bool isCompact = false}) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    return StatusBadge(
      text: 'Vencida',
      backgroundColor: theme.error.withOpacity(0.15),
      textColor: theme.error,
      borderColor: theme.error,
      icon: Icons.error_outline,
      isCompact: isCompact,
    );
  }

  factory StatusBadge.cancelada(BuildContext context, {bool isCompact = false}) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    return StatusBadge(
      text: 'Cancelada',
      backgroundColor: theme.textDisabled.withOpacity(0.15),
      textColor: theme.textDisabled,
      borderColor: theme.textDisabled,
      icon: Icons.cancel,
      isCompact: isCompact,
    );
  }

  // Esquemas de pago
  factory StatusBadge.pull(BuildContext context, {bool isCompact = false}) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    return StatusBadge(
      text: 'PULL NC-Pago',
      backgroundColor: theme.secondary.withOpacity(0.15),
      textColor: theme.secondary,
      borderColor: theme.secondary,
      isCompact: isCompact,
    );
  }

  factory StatusBadge.push(BuildContext context, {bool isCompact = false}) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    return StatusBadge(
      text: 'PUSH NC-Pago',
      backgroundColor: theme.primary.withOpacity(0.15),
      textColor: theme.primary,
      borderColor: theme.primary,
      isCompact: isCompact,
    );
  }

  // Estados de validaciones
  factory StatusBadge.aprobado(BuildContext context, {bool isCompact = false}) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    return StatusBadge(
      text: 'Aprobado',
      backgroundColor: theme.success.withOpacity(0.15),
      textColor: theme.success,
      borderColor: theme.success,
      icon: Icons.check_circle,
      isCompact: isCompact,
    );
  }

  factory StatusBadge.rechazado(BuildContext context, {bool isCompact = false}) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    return StatusBadge(
      text: 'Rechazado',
      backgroundColor: theme.error.withOpacity(0.15),
      textColor: theme.error,
      borderColor: theme.error,
      icon: Icons.cancel,
      isCompact: isCompact,
    );
  }

  // Estados de proveedores
  factory StatusBadge.activo(BuildContext context, {bool isCompact = false}) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    return StatusBadge(
      text: 'Activo',
      backgroundColor: theme.success.withOpacity(0.15),
      textColor: theme.success,
      borderColor: theme.success,
      icon: Icons.check_circle,
      isCompact: isCompact,
    );
  }

  factory StatusBadge.inactivo(BuildContext context, {bool isCompact = false}) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    return StatusBadge(
      text: 'Inactivo',
      backgroundColor: theme.textDisabled.withOpacity(0.15),
      textColor: theme.textDisabled,
      borderColor: theme.textDisabled,
      icon: Icons.remove_circle_outline,
      isCompact: isCompact,
    );
  }

  // Estados de pagos
  factory StatusBadge.propuesto(BuildContext context, {bool isCompact = false}) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    return StatusBadge(
      text: 'Propuesto',
      backgroundColor: theme.accent.withOpacity(0.15),
      textColor: theme.accent,
      borderColor: theme.accent,
      icon: Icons.lightbulb_outline,
      isCompact: isCompact,
    );
  }

  factory StatusBadge.ejecutado(BuildContext context, {bool isCompact = false}) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    return StatusBadge(
      text: 'Ejecutado',
      backgroundColor: theme.success.withOpacity(0.15),
      textColor: theme.success,
      borderColor: theme.success,
      icon: Icons.check_circle,
      isCompact: isCompact,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width <= mobileSize;

    final effectiveBackgroundColor = backgroundColor ?? theme.primary.withOpacity(0.15);
    final effectiveTextColor = textColor ?? theme.primary;
    final effectiveBorderColor = borderColor ?? theme.primary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(isCompact ? 6 : 20),
        border: Border.all(
          color: effectiveBorderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null && !isCompact) ...[
            Icon(
              icon,
              size: isMobile ? 14 : 16,
              color: effectiveTextColor,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: isCompact ? 11 : (isMobile ? 12 : 13),
              fontWeight: FontWeight.w600,
              color: effectiveTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
