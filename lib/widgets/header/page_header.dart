import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facturacion_demo/providers/theme_provider.dart';
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
    final theme = Theme.of(context).extension<AppTheme>()!;

    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: theme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.border,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.textPrimary.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu button (mobile) o título
          if (isMobile)
            IconButton(
              icon: Icon(
                Icons.menu,
                color: theme.textPrimary,
                size: 26,
              ),
              onPressed: onMenuPressed,
            )
          else
            Text(
              'Optimización de Pagos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.textPrimary,
              ),
            ),

          // Right side: AI button, Theme toggle, Admin info
          Row(
            children: [
              // AI Assistant button
              Tooltip(
                message: 'Asistente IA',
                child: _AnimatedIconButton(
                  icon: Icons.smart_toy_outlined,
                  color: theme.secondary,
                  onPressed: () => _showAIDialog(context),
                ),
              ),

              const SizedBox(width: 12),

              // Theme toggle
              Tooltip(
                message: themeProvider.isDarkMode ? 'Modo Claro' : 'Modo Oscuro',
                child: IconButton(
                  icon: Icon(
                    themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: theme.textSecondary,
                    size: 22,
                  ),
                  onPressed: () => themeProvider.toggleTheme(),
                ),
              ),

              if (!isMobile) const SizedBox(width: 16),

              // Admin info (hide on small mobile)
              if (!isMobile || size.width > 400)
                Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: theme.primary.withOpacity(0.2),
                      child: Text(
                        adminName.substring(0, 1),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.primary,
                        ),
                      ),
                    ),

                    if (!isMobile) ...[
                      const SizedBox(width: 12),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          Text(
                            adminRole,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: theme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Widget auxiliar para botón con animación de pulso
class _AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _AnimatedIconButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  State<_AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<_AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: IconButton(
        icon: Icon(
          widget.icon,
          color: widget.color,
          size: 24,
        ),
        onPressed: widget.onPressed,
      ),
    );
  }
}
