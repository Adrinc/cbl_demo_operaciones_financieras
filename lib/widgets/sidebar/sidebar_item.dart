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

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          context.go(widget.route);
          navigationProvider.setCurrentRoute(widget.route);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: isActive
                ? LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      theme.primary.withOpacity(0.15),
                      theme.primary.withOpacity(0.05),
                    ],
                  )
                : _isHovered
                    ? LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          theme.primary.withOpacity(0.08),
                          theme.primary.withOpacity(0.02),
                        ],
                      )
                    : null,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isActive
                  ? theme.primary.withOpacity(0.5)
                  : _isHovered
                      ? theme.primary.withOpacity(0.2)
                      : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Icono con contenedor
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: isActive
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.primary.withOpacity(0.2),
                            theme.primary.withOpacity(0.1),
                          ],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  widget.icon,
                  size: 20,
                  color: isActive ? theme.primary : theme.textSecondary,
                ),
              ),
              if (!widget.isCollapsed) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive ? theme.primary : theme.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Indicador activo
                if (isActive)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.primary,
                          theme.primary.withOpacity(0.6),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.primary.withOpacity(0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
