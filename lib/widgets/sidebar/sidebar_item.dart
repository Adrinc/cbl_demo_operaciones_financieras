import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:facturacion_demo/providers/navigation_provider.dart';
import 'package:facturacion_demo/theme/theme.dart';

/// ============================================================================
/// SIDEBAR ITEM
/// ============================================================================
/// Item individual del sidebar con estado activo/inactivo
/// ============================================================================
class SidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool isCollapsed;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.route,
    this.isCollapsed = false,
  });

  @override
  State<SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.watch<NavigationProvider>();
    final isActive = navigationProvider.isRouteActive(widget.route);
    final theme = Theme.of(context).extension<AppTheme>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          context.go(widget.route);
          navigationProvider.setCurrentRoute(widget.route);
        },
        child: AnimatedScale(
          scale: _isHovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: EdgeInsets.symmetric(
              horizontal: widget.isCollapsed ? 8 : 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              // Background muy sutil - casi transparente
              color: isActive
                  ? (isDark
                      ? theme.surface.withOpacity(0.3)
                      : theme.surface.withOpacity(0.4))
                  : _isHovered
                      ? theme.surface.withOpacity(0.3)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive
                    ? theme.primary // Borde azul sólido
                    : _isHovered
                        ? theme.border.withOpacity(0.5)
                        : Colors.transparent,
                width: isActive ? 2 : 1,
              ),
              // Sombras: SOLO glow azul en dark mode, sombra neutral en light
              boxShadow: isActive && isDark
                  ? [
                      // Glow azul sutil solo en dark mode
                      BoxShadow(
                        color: theme.primary.withOpacity(0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : _isHovered
                      ? [
                          BoxShadow(
                            color: (isDark ? Colors.black : theme.textPrimary)
                                .withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
            ),
            child: Stack(
              children: [
                // Indicador lateral izquierdo para item activo
                if (isActive && !widget.isCollapsed)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 3,
                      decoration: BoxDecoration(
                        color: theme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                // Contenido del item
                Padding(
                  padding: EdgeInsets.only(
                    left: isActive && !widget.isCollapsed ? 8 : 0,
                  ),
                  child: Row(
                    mainAxisAlignment: widget.isCollapsed
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      // Icono sin container decorativo - color contrastante
                      Icon(
                        widget.icon,
                        size: 22,
                        color: isActive
                            ? (isDark
                                ? Colors.white // Blanco en dark mode
                                : theme.textPrimary) // Negro en light mode
                            : _isHovered
                                ? theme.textPrimary.withOpacity(0.8)
                                : theme.textPrimary.withOpacity(0.6),
                      ),
                      if (!widget.isCollapsed) ...[
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            widget.label,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  isActive ? FontWeight.w600 : FontWeight.w500,
                              color: isActive
                                  ? (isDark
                                      ? Colors.white // Blanco en dark mode
                                      : theme
                                          .textPrimary) // Negro en light mode
                                  : _isHovered
                                      ? theme.textPrimary.withOpacity(0.85)
                                      : theme.textPrimary.withOpacity(0.7),
                              letterSpacing: 0.2,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
