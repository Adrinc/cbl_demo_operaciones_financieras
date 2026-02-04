import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:facturacion_demo/helpers/constants.dart';
import 'package:facturacion_demo/pages/main_container/main_container_page.dart';
import 'package:facturacion_demo/pages/page_not_found.dart';

/// ============================================================================
/// ROUTER CONFIGURATION
/// ============================================================================
/// Configuración de rutas con go_router
/// Sin animaciones de transición para navegación instantánea
/// ============================================================================

final GoRouter appRouter = GoRouter(
  initialLocation: Routes.dashboard,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainContainerPage(child: child);
      },
      routes: [
        GoRoute(
          path: Routes.dashboard,
          name: 'dashboard',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: Container(), // TODO: Dashboard page (Fase 4)
          ),
        ),
        GoRoute(
          path: Routes.facturas,
          name: 'facturas',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: Container(), // TODO: Facturas page (Fase 5)
          ),
        ),
        GoRoute(
          path: Routes.optimizacion,
          name: 'optimizacion',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: Container(), // TODO: Optimización page (Fase 6)
          ),
        ),
        GoRoute(
          path: Routes.simulador,
          name: 'simulador',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: Container(), // TODO: Simulador page (Fase 7)
          ),
        ),
        GoRoute(
          path: Routes.validaciones,
          name: 'validaciones',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: Container(), // TODO: Validaciones page (Fase 8)
          ),
        ),
        GoRoute(
          path: Routes.proveedores,
          name: 'proveedores',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: Container(), // TODO: Proveedores page (Fase 9)
          ),
        ),
        GoRoute(
          path: Routes.reportes,
          name: 'reportes',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: Container(), // TODO: Reportes page (Fase 10)
          ),
        ),
        GoRoute(
          path: Routes.configuracion,
          name: 'configuracion',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: Container(), // TODO: Configuración page (Fase 11)
          ),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const PageNotFound(),
);
