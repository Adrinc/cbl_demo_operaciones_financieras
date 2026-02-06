import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facturacion_demo/providers/theme_provider.dart';
import 'package:facturacion_demo/providers/navigation_provider.dart';
import 'package:facturacion_demo/helpers/constants.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/widgets/chatbot/ai_assistant_dialog.dart';

/// ============================================================================
/// PAGE HEADER
/// ============================================================================
/// Header con toggle de tema, botón de chatbot AI y info del admin
/// Se muestra en todas las páginas
/// ============================================================================
class PageHeader extends StatelessWidget {
  final VoidCallback? onMenuPressed;

  const PageHeader({
    super.key,
    this.onMenuPressed,
  });

  void _showAIDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AIAssistantDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width <= mobileSize;
    final themeProvider = context.watch<ThemeProvider>();
    final navigationProvider = context.watch<NavigationProvider>();
    final theme = Theme.of(context).extension<AppTheme>()!;

    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 20,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: theme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.border.withOpacity(0.3),
            width: 1,
          ),
        ),
        // 🔥 SOMBRAS PREMIUM - Profundidad en dark mode
        boxShadow: [
          ...theme.shadowMedium,
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu button (mobile) o título
          if (isMobile)
            Container(
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: theme.primary,
                  size: 24,
                ),
                onPressed: onMenuPressed,
              ),
            )
          else
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.primary.withOpacity(0.15),
                        theme.primary.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Icon(
                    navigationProvider.getPageIcon(),
                    color: theme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  navigationProvider.getPageTitle(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: theme.textPrimary,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),

          // Right side: AI button, Theme toggle, Admin info
          Row(
            children: [
              // AI Assistant button (simple, like theme toggle)
              Tooltip(
                message: 'Asistente IA',
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.secondary.withOpacity(0.15),
                        theme.secondary.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.secondary.withOpacity(0.3),
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.smart_toy_outlined,
                      color: theme.secondary,
                      size: 20,
                    ),
                    onPressed: () => _showAIDialog(context),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Theme toggle
              Tooltip(
                message:
                    themeProvider.isDarkMode ? 'Modo Claro' : 'Modo Oscuro',
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: themeProvider.isDarkMode
                          ? [
                              theme.warning.withOpacity(0.15),
                              theme.warning.withOpacity(0.05),
                            ]
                          : [
                              theme.primary.withOpacity(0.15),
                              theme.primary.withOpacity(0.05),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: themeProvider.isDarkMode
                          ? theme.warning.withOpacity(0.3)
                          : theme.primary.withOpacity(0.3),
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      themeProvider.isDarkMode
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      color: themeProvider.isDarkMode
                          ? theme.warning
                          : theme.primary,
                      size: 20,
                    ),
                    onPressed: () => themeProvider.toggleTheme(),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                ),
              ),

              SizedBox(width: isMobile ? 16 : 20),

              // Admin profile menu (always show, simplified on very small screens)
              _AdminProfileMenu(isMobile: isMobile),
            ],
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// ADMIN PROFILE MENU - Menú desplegable premium con opciones
/// ============================================================================
class _AdminProfileMenu extends StatefulWidget {
  final bool isMobile;

  const _AdminProfileMenu({required this.isMobile});

  @override
  State<_AdminProfileMenu> createState() => _AdminProfileMenuState();
}

class _AdminProfileMenuState extends State<_AdminProfileMenu> {
  bool _isHovered = false;

  void _showProfileMenu(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = button.localToGlobal(Offset.zero, ancestor: overlay);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + button.size.height + 8,
        overlay.size.width - position.dx - button.size.width,
        overlay.size.height - position.dy - button.size.height,
      ),
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.border.withOpacity(0.3),
          width: 1,
        ),
      ),
      color: theme.surface,
      shadowColor: (isDark ? Colors.black : theme.textPrimary).withOpacity(0.2),
      items: [
        // Header del menú con info del usuario
        PopupMenuItem<String>(
          enabled: false,
          padding: EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.primary.withOpacity(0.1),
                  theme.primary.withOpacity(0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Avatar grande
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.primary,
                        theme.primary.withOpacity(0.6),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundImage: const AssetImage(adminAvatarPath),
                    backgroundColor: theme.surface,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        adminName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: theme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        adminRole,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: theme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'admin@arxis.com',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: theme.textSecondary.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Divisor
        PopupMenuItem<String>(
          enabled: false,
          height: 1,
          padding: EdgeInsets.zero,
          child: Divider(
            height: 1,
            thickness: 1,
            color: theme.border.withOpacity(0.3),
          ),
        ),

        // Opción: Mi Perfil
        PopupMenuItem<String>(
          value: 'profile',
          height: 48,
          child: _MenuOption(
            icon: Icons.person_outline,
            label: 'Mi Perfil',
            color: theme.primary,
          ),
        ),

        // Opción: Configuración
        PopupMenuItem<String>(
          value: 'settings',
          height: 48,
          child: _MenuOption(
            icon: Icons.settings_outlined,
            label: 'Configuración',
            color: theme.textSecondary,
          ),
        ),

        // Divisor
        PopupMenuItem<String>(
          enabled: false,
          height: 1,
          padding: EdgeInsets.zero,
          child: Divider(
            height: 1,
            thickness: 1,
            color: theme.border.withOpacity(0.3),
          ),
        ),

        // Opción: Cerrar Sesión
        PopupMenuItem<String>(
          value: 'logout',
          height: 48,
          child: _MenuOption(
            icon: Icons.logout,
            label: 'Cerrar Sesión',
            color: theme.error,
          ),
        ),
      ],
    ).then((value) {
      if (value == 'logout') {
        _showLogoutDialog(context);
      } else if (value == 'profile') {
        _showComingSoonSnackbar(context, 'Perfil');
      } else if (value == 'settings') {
        _showComingSoonSnackbar(context, 'Configuración');
      }
    });
  }

  void _showLogoutDialog(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.border.withOpacity(0.3),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.error.withOpacity(0.15),
                    theme.error.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.logout,
                color: theme.error,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Cerrar Sesión',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.textPrimary,
              ),
            ),
          ],
        ),
        content: Text(
          'Esta es una aplicación DEMO sin autenticación real.\n\nEn un sistema de producción, aquí se cerraría la sesión del usuario y se redirigiría a la pantalla de login.',
          style: TextStyle(
            fontSize: 14,
            color: theme.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'Entendido',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoonSnackbar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature: Funcionalidad demo'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showProfileMenu(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isMobile ? 6 : 8,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: _isHovered
                  ? [
                      theme.primary.withOpacity(0.12),
                      theme.primary.withOpacity(0.06),
                    ]
                  : [
                      theme.primary.withOpacity(0.08),
                      theme.primary.withOpacity(0.02),
                    ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.primary.withOpacity(_isHovered ? 0.25 : 0.15),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar simple sin decoración extra
              CircleAvatar(
                radius: 12,
                backgroundImage: const AssetImage(adminAvatarPath),
                backgroundColor: theme.surface,
              ),

              if (!widget.isMobile) ...[
                const SizedBox(width: 6),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      adminName,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: theme.textPrimary,
                      ),
                    ),
                    Text(
                      adminRole,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                        color: theme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: theme.textSecondary,
                  size: 14,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// ============================================================================
/// MENU OPTION - Item individual del menú desplegable
/// ============================================================================
class _MenuOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MenuOption({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 18,
            color: color,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: theme.textPrimary,
          ),
        ),
      ],
    );
  }
}
