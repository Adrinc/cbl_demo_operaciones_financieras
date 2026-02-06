import 'package:flutter/material.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// KPI CARD
/// ============================================================================
/// Card widget para mostrar KPIs con icono, título, valor y tendencia
/// Usado en Dashboard y otras páginas para métricas clave
/// ============================================================================
class KPICard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final String? subtitle;
  final IconData? trendIcon;
  final Color? trendColor;
  final VoidCallback? onTap;
  final bool isCompact;

  const KPICard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    this.subtitle,
    this.trendIcon,
    this.trendColor,
    this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width <= mobileSize;
    final theme = Theme.of(context).extension<AppTheme>()!;

    // Padding y tamaños reducidos para modo compacto
    final padding = isCompact ? 14.0 : (isMobile ? 16.0 : 20.0);
    final iconBoxSize = isCompact ? 40.0 : (isMobile ? 48.0 : 56.0);
    final iconSize = isCompact ? 22.0 : (isMobile ? 26.0 : 30.0);
    // 🔥 Tamaños aumentados para mejor legibilidad
    final titleSize = isCompact ? 16.0 : (isMobile ? 14.5 : 18.0);
    final valueSize = isCompact ? 18.0 : (isMobile ? 22.0 : 26.0);
    final subtitleSize = isCompact ? 11.5 : 12.0;
    final verticalSpacing = isCompact ? 8.0 : (isMobile ? 14.0 : 18.0);

    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor:
            onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
            // 🔥 SOMBRAS PREMIUM - Máximo impacto visual
            boxShadow: [
              ...theme.shadowPremium,
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon + Trend
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icono con degradado
                  Container(
                    width: iconBoxSize,
                    height: iconBoxSize,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color.withOpacity(0.2),
                          color.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: color.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: iconSize,
                      color: color,
                    ),
                  ),
                  if (trendIcon != null && trendColor != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            trendColor!.withOpacity(0.25),
                            trendColor!.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: trendColor!.withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        trendIcon,
                        size: isCompact ? 14 : 18,
                        color: trendColor,
                      ),
                    ),
                ],
              ),

              SizedBox(height: verticalSpacing),

              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w500,
                  color: theme.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: isCompact ? 4 : (isMobile ? 6 : 8)),

              // Value
              Text(
                value,
                style: TextStyle(
                  fontSize: valueSize,
                  fontWeight: FontWeight.bold,
                  color: theme.textPrimary,
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Subtitle (optional)
              if (subtitle != null) ...[
                SizedBox(height: isCompact ? 4 : 6),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: subtitleSize,
                    fontWeight: FontWeight.w400,
                    color: theme.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
