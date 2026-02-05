import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// PAGE NOT FOUND - 404
/// ============================================================================
/// Página mostrada cuando se accede a una ruta no válida
/// ============================================================================

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final isMobile = MediaQuery.of(context).size.width < mobileSize;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isMobile ? 350 : 500),
          padding: EdgeInsets.all(isMobile ? 24 : 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono 404
              Icon(
                Icons.error_outline,
                size: isMobile ? 80 : 120,
                color: theme.error,
              ),
              const SizedBox(height: 24),

              // Título
              Text(
                '404',
                style: theme.title1.override(
                  fontFamily: theme.title1Family,
                  fontSize: isMobile ? 48 : 70,
                  color: theme.primaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Subtítulo
              Text(
                'Página no encontrada',
                style: theme.subtitle1.override(
                  fontFamily: theme.subtitle1Family,
                  fontSize: isMobile ? 20 : 28,
                  color: theme.primaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Descripción
              Text(
                'La página que buscas no existe o ha sido movida.',
                style: theme.bodyText1.override(
                  fontFamily: theme.bodyText1Family,
                  fontSize: isMobile ? 14 : 16,
                  color: theme.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Botón volver al inicio
              ElevatedButton.icon(
                onPressed: () => context.go(Routes.dashboard),
                icon: const Icon(Icons.home),
                label: const Text('Volver al Inicio'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 24 : 32,
                    vertical: isMobile ? 12 : 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
