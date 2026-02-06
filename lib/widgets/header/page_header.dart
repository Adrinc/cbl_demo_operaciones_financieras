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
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: theme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.border.withOpacity(0.5),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
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

              const SizedBox(width: 8),

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

              if (!isMobile) const SizedBox(width: 16),

              // Admin info (hide on small mobile)
              if (!isMobile || size.width > 400)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        theme.primary.withOpacity(0.08),
                        theme.primary.withOpacity(0.02),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: theme.primary.withOpacity(0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Avatar con imagen real y borde degradado
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.primary,
                              theme.primary.withOpacity(0.5),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundImage: const AssetImage(adminAvatarPath),
                          backgroundColor: theme.surface,
                        ),
                      ),

                      if (!isMobile) ...[
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              adminName,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: theme.textPrimary,
                              ),
                            ),
                            Text(
                              adminRole,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: theme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
