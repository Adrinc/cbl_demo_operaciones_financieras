import 'package:flutter/material.dart';
import 'package:facturacion_demo/theme/theme.dart';

/// ============================================================================
/// AI ASSISTANT DIALOG
/// ============================================================================
/// Diálogo simulado que muestra el potencial de integración de IA
/// No implementa funcionalidad real, solo demostración
/// ============================================================================
class AIAssistantDialog extends StatelessWidget {
  const AIAssistantDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.border,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.secondary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy,
                size: 40,
                color: theme.secondary,
              ),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              'Asistente IA de Optimización',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              'Este sistema puede integrar un asistente de IA para responder preguntas sobre optimización de pagos, análisis de facturas y recomendaciones financieras en tiempo real.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: theme.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Features list
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeatureItem(
                    context,
                    icon: Icons.analytics,
                    text: 'Análisis predictivo de flujo de caja',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    context,
                    icon: Icons.lightbulb_outline,
                    text: 'Recomendaciones de optimización',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    context,
                    icon: Icons.chat_bubble_outline,
                    text: 'Respuestas instantáneas sobre pagos',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    context,
                    icon: Icons.insights,
                    text: 'Insights financieros personalizados',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Entendido',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, {required IconData icon, required String text}) {
    final theme = Theme.of(context).extension<AppTheme>()!;

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.secondary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: theme.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
