import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:facturacion_demo/theme/theme.dart';

/// ============================================================================
/// PAGE NOT FOUND (404)
/// ============================================================================
/// Página de error 404 para rutas no encontradas
/// ============================================================================
class PageNotFoundPage extends StatelessWidget {
  const PageNotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 404 Icon
            Icon(
              Icons.error_outline,
              size: 120,
              color: theme.error,
            ),
            const SizedBox(height: 24),

            // 404 Text
            Text(
              '404',
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: theme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Message
            Text(
              'Página No Encontrada',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: theme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'La página que buscas no existe o ha sido movida.',
              style: TextStyle(
                fontSize: 14,
                color: theme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Back to Dashboard Button
            ElevatedButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.home),
              label: const Text('Volver al Dashboard'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
