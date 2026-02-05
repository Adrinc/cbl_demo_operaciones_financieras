import 'package:flutter/material.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// GRADIENT BUTTON
/// ============================================================================
/// Botón con degradado profesional para acciones principales
/// Diseño moderno con efectos de hover y estados visuales
/// ============================================================================
class GradientButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final GradientButtonType type;
  final bool isLoading;
  final bool isCompact;
  final double? width;

  const GradientButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.type = GradientButtonType.primary,
    this.isLoading = false,
    this.isCompact = false,
    this.width,
  });

  // Factory constructors para tipos comunes
  factory GradientButton.primary({
    required String text,
    IconData? icon,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isCompact = false,
    double? width,
  }) =>
      GradientButton(
        text: text,
        icon: icon,
        onPressed: onPressed,
        type: GradientButtonType.primary,
        isLoading: isLoading,
        isCompact: isCompact,
        width: width,
      );

  factory GradientButton.secondary({
    required String text,
    IconData? icon,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isCompact = false,
    double? width,
  }) =>
      GradientButton(
        text: text,
        icon: icon,
        onPressed: onPressed,
        type: GradientButtonType.secondary,
        isLoading: isLoading,
        isCompact: isCompact,
        width: width,
      );

  factory GradientButton.success({
    required String text,
    IconData? icon,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isCompact = false,
    double? width,
  }) =>
      GradientButton(
        text: text,
        icon: icon,
        onPressed: onPressed,
        type: GradientButtonType.success,
        isLoading: isLoading,
        isCompact: isCompact,
        width: width,
      );

  factory GradientButton.danger({
    required String text,
    IconData? icon,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isCompact = false,
    double? width,
  }) =>
      GradientButton(
        text: text,
        icon: icon,
        onPressed: onPressed,
        type: GradientButtonType.danger,
        isLoading: isLoading,
        isCompact: isCompact,
        width: width,
      );

  factory GradientButton.warning({
    required String text,
    IconData? icon,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isCompact = false,
    double? width,
  }) =>
      GradientButton(
        text: text,
        icon: icon,
        onPressed: onPressed,
        type: GradientButtonType.warning,
        isLoading: isLoading,
        isCompact: isCompact,
        width: width,
      );

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width <= mobileSize;

    final gradientColors = _getGradientColors(theme);
    final isDisabled = widget.onPressed == null || widget.isLoading;

    final horizontalPadding =
        widget.isCompact ? 16.0 : (isMobile ? 20.0 : 24.0);
    final verticalPadding = widget.isCompact ? 10.0 : (isMobile ? 14.0 : 16.0);
    final fontSize = widget.isCompact ? 13.0 : (isMobile ? 14.0 : 15.0);
    final iconSize = widget.isCompact ? 18.0 : (isMobile ? 20.0 : 22.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor:
          isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDisabled
                ? [
                    theme.textDisabled.withOpacity(0.5),
                    theme.textDisabled.withOpacity(0.3)
                  ]
                : _isHovered
                    ? gradientColors.map((c) => c.withOpacity(0.9)).toList()
                    : gradientColors,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: isDisabled
              ? []
              : [
                  BoxShadow(
                    color: gradientColors.first
                        .withOpacity(_isHovered ? 0.4 : 0.25),
                    blurRadius: _isHovered ? 16 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : widget.onPressed,
            borderRadius: BorderRadius.circular(10),
            splashColor: Colors.white.withOpacity(0.2),
            highlightColor: Colors.white.withOpacity(0.1),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isLoading) ...[
                    SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ] else if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      size: iconSize,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Color> _getGradientColors(AppTheme theme) {
    switch (widget.type) {
      case GradientButtonType.primary:
        return [theme.primary, theme.primary.withOpacity(0.8)];
      case GradientButtonType.secondary:
        return [theme.secondary, theme.secondary.withOpacity(0.8)];
      case GradientButtonType.success:
        return [theme.success, const Color(0xFF059669)];
      case GradientButtonType.danger:
        return [theme.error, const Color(0xFFDC2626)];
      case GradientButtonType.warning:
        return [theme.warning, const Color(0xFFD97706)];
    }
  }
}

enum GradientButtonType {
  primary,
  secondary,
  success,
  danger,
  warning,
}

/// ============================================================================
/// OUTLINED GRADIENT BUTTON
/// ============================================================================
/// Botón con borde degradado para acciones secundarias
/// ============================================================================
class OutlinedGradientButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? color;
  final bool isCompact;
  final double? width;

  const OutlinedGradientButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.color,
    this.isCompact = false,
    this.width,
  });

  @override
  State<OutlinedGradientButton> createState() => _OutlinedGradientButtonState();
}

class _OutlinedGradientButtonState extends State<OutlinedGradientButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width <= mobileSize;

    final color = widget.color ?? theme.primary;
    final isDisabled = widget.onPressed == null;

    final horizontalPadding =
        widget.isCompact ? 14.0 : (isMobile ? 18.0 : 22.0);
    final verticalPadding = widget.isCompact ? 8.0 : (isMobile ? 12.0 : 14.0);
    final fontSize = widget.isCompact ? 13.0 : (isMobile ? 14.0 : 15.0);
    final iconSize = widget.isCompact ? 18.0 : (isMobile ? 20.0 : 22.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor:
          isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width,
        decoration: BoxDecoration(
          color: _isHovered ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDisabled ? theme.textDisabled.withOpacity(0.5) : color,
            width: 1.5,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : widget.onPressed,
            borderRadius: BorderRadius.circular(10),
            splashColor: color.withOpacity(0.2),
            highlightColor: color.withOpacity(0.1),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      size: iconSize,
                      color: isDisabled ? theme.textDisabled : color,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      color: isDisabled ? theme.textDisabled : color,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ============================================================================
/// ICON ACTION BUTTON
/// ============================================================================
/// Botón de icono pequeño para acciones en tablas
/// ============================================================================
class IconActionButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final String? tooltip;
  final bool isCompact;

  const IconActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.tooltip,
    this.isCompact = false,
  });

  factory IconActionButton.edit(
          {VoidCallback? onPressed, bool isCompact = false}) =>
      IconActionButton(
        icon: Icons.edit_outlined,
        onPressed: onPressed,
        color: const Color(0xFF3B82F6),
        tooltip: 'Editar',
        isCompact: isCompact,
      );

  factory IconActionButton.delete(
          {VoidCallback? onPressed, bool isCompact = false}) =>
      IconActionButton(
        icon: Icons.delete_outline,
        onPressed: onPressed,
        color: const Color(0xFFEF4444),
        tooltip: 'Eliminar',
        isCompact: isCompact,
      );

  factory IconActionButton.view(
          {VoidCallback? onPressed, bool isCompact = false}) =>
      IconActionButton(
        icon: Icons.visibility_outlined,
        onPressed: onPressed,
        color: const Color(0xFF2DD4BF),
        tooltip: 'Ver detalles',
        isCompact: isCompact,
      );

  factory IconActionButton.approve(
          {VoidCallback? onPressed, bool isCompact = false}) =>
      IconActionButton(
        icon: Icons.check_circle_outline,
        onPressed: onPressed,
        color: const Color(0xFF10B981),
        tooltip: 'Aprobar',
        isCompact: isCompact,
      );

  factory IconActionButton.reject(
          {VoidCallback? onPressed, bool isCompact = false}) =>
      IconActionButton(
        icon: Icons.cancel_outlined,
        onPressed: onPressed,
        color: const Color(0xFFEF4444),
        tooltip: 'Rechazar',
        isCompact: isCompact,
      );

  @override
  State<IconActionButton> createState() => _IconActionButtonState();
}

class _IconActionButtonState extends State<IconActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final color = widget.color ?? theme.primary;
    final isDisabled = widget.onPressed == null;
    final size = widget.isCompact ? 32.0 : 36.0;
    final iconSize = widget.isCompact ? 18.0 : 20.0;

    Widget button = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor:
          isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _isHovered ? color.withOpacity(0.15) : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isHovered ? color.withOpacity(0.5) : color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : widget.onPressed,
            borderRadius: BorderRadius.circular(8),
            child: Center(
              child: Icon(
                widget.icon,
                size: iconSize,
                color: isDisabled ? theme.textDisabled : color,
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return button;
  }
}
