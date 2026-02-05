import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:facturacion_demo/providers/navigation_provider.dart';
import 'package:facturacion_demo/providers/theme_provider.dart';
import 'package:facturacion_demo/providers/factura_provider.dart';
import 'package:facturacion_demo/providers/proveedor_provider.dart';
import 'package:facturacion_demo/providers/pago_provider.dart';
import 'package:facturacion_demo/providers/validacion_provider.dart';
import 'package:facturacion_demo/router/router.dart';
import 'package:facturacion_demo/theme/theme.dart';

/// ============================================================================
/// MAIN
/// ============================================================================
/// Punto de entrada de la aplicación
/// Configura MultiProvider con todos los providers necesarios
/// ============================================================================
void main() {
  // Remove '#' from web URLs
  setPathUrlStrategy();

  runApp(const FacturacionDemoApp());
}

class FacturacionDemoApp extends StatelessWidget {
  const FacturacionDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FacturaProvider()),
        ChangeNotifierProvider(create: (_) => ProveedorProvider()),
        ChangeNotifierProvider(create: (_) => PagoProvider()),
        ChangeNotifierProvider(create: (_) => ValidacionProvider()),
      ],
      child: const _AppContent(),
    );
  }
}

class _AppContent extends StatelessWidget {
  const _AppContent();

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp.router(
      title: 'Demo Optimización de Pagos - CBLuna',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppTheme.lightTheme.primaryBackground,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppTheme.darkTheme.primaryBackground,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      themeMode: themeProvider.themeMode,
    );
  }
}
