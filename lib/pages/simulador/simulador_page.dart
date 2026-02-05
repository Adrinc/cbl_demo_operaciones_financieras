import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facturacion_demo/providers/factura_provider.dart';
import 'package:facturacion_demo/providers/proveedor_provider.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/pages/simulador/widgets/scenario_controls.dart';
import 'package:facturacion_demo/pages/simulador/widgets/impact_preview.dart';

/// ============================================================================
/// SIMULADOR DE ESCENARIOS PAGE
/// ============================================================================
/// Feature interactivo para análisis "what-if"
/// Permite simular diferentes escenarios de optimización de pagos
/// ============================================================================
class SimuladorPage extends StatefulWidget {
  const SimuladorPage({super.key});

  @override
  State<SimuladorPage> createState() => _SimuladorPageState();
}

class _SimuladorPageState extends State<SimuladorPage> {
  // Parámetros de simulación
  double _dppPercentage = 3.0; // 0-10%
  int _paymentDays = 30; // 1-90 días
  String _selectedScheme = 'pull'; // 'pull' | 'push' | 'mixto'
  Set<String> _selectedProveedores = {};

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final facturaProvider = context.watch<FacturaProvider>();
    final proveedorProvider = context.watch<ProveedorProvider>();
    final isMobile = MediaQuery.of(context).size.width < 768;

    // Obtener facturas pendientes
    final facturasPendientes =
        facturaProvider.facturas.where((f) => f.estado == 'pendiente').toList();

    // Filtrar por proveedores seleccionados (si hay)
    final facturasSimuladas = _selectedProveedores.isEmpty
        ? facturasPendientes
        : facturasPendientes
            .where((f) => _selectedProveedores.contains(f.proveedorId))
            .toList();

    // Cálculos de impacto
    final montoOriginal = facturasSimuladas.fold<double>(
      0.0,
      (sum, f) => sum + f.importe,
    );

    // Simular ahorro con parámetros ajustados
    final ahorroSimulado = facturasSimuladas.fold<double>(
      0.0,
      (sum, f) {
        // Calcular ahorro basado en DPP simulado
        final ahorroBase = f.importe * (_dppPercentage / 100);
        // Ajustar por días de pago (menos días = más ahorro)
        final factorDias = (_paymentDays <= 30) ? 1.0 : 0.85;
        return sum + (ahorroBase * factorDias);
      },
    );

    final montoFinalSimulado = montoOriginal - ahorroSimulado;

    // Comparación con escenario actual
    final ahorroActual = facturasSimuladas.fold<double>(
      0.0,
      (sum, f) => sum + f.montoDPP,
    );

    final diferencia = ahorroSimulado - ahorroActual;
    final mejora = ahorroActual > 0 ? (diferencia / ahorroActual) * 100 : 0.0;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título y descripción
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [theme.accent, theme.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.science_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Simulador de Escenarios',
                        style: TextStyle(
                          fontSize: isMobile ? 24 : 32,
                          fontWeight: FontWeight.bold,
                          color: theme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Experimenta con diferentes parámetros de optimización y visualiza el impacto en tiempo real',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Layout responsivo
            if (isMobile)
              // Mobile: Stack vertical
              Column(
                children: [
                  ScenarioControls(
                    dppPercentage: _dppPercentage,
                    paymentDays: _paymentDays,
                    selectedScheme: _selectedScheme,
                    selectedProveedores: _selectedProveedores,
                    proveedores: proveedorProvider.proveedores,
                    onDppChanged: (value) {
                      setState(() => _dppPercentage = value);
                    },
                    onDaysChanged: (value) {
                      setState(() => _paymentDays = value);
                    },
                    onSchemeChanged: (value) {
                      setState(() => _selectedScheme = value);
                    },
                    onProveedoresChanged: (value) {
                      setState(() => _selectedProveedores = value);
                    },
                  ),
                  const SizedBox(height: 24),
                  ImpactPreview(
                    montoOriginal: montoOriginal,
                    ahorroSimulado: ahorroSimulado,
                    montoFinal: montoFinalSimulado,
                    ahorroActual: ahorroActual,
                    diferencia: diferencia,
                    mejora: mejora,
                    cantidadFacturas: facturasSimuladas.length,
                    dppPercentage: _dppPercentage,
                    paymentDays: _paymentDays,
                  ),
                ],
              )
            else
              // Desktop: Grid 2 columnas
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Columna izquierda: Controles (40%)
                  Expanded(
                    flex: 4,
                    child: ScenarioControls(
                      dppPercentage: _dppPercentage,
                      paymentDays: _paymentDays,
                      selectedScheme: _selectedScheme,
                      selectedProveedores: _selectedProveedores,
                      proveedores: proveedorProvider.proveedores,
                      onDppChanged: (value) {
                        setState(() => _dppPercentage = value);
                      },
                      onDaysChanged: (value) {
                        setState(() => _paymentDays = value);
                      },
                      onSchemeChanged: (value) {
                        setState(() => _selectedScheme = value);
                      },
                      onProveedoresChanged: (value) {
                        setState(() => _selectedProveedores = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 24),

                  // Columna derecha: Preview (60%)
                  Expanded(
                    flex: 6,
                    child: ImpactPreview(
                      montoOriginal: montoOriginal,
                      ahorroSimulado: ahorroSimulado,
                      montoFinal: montoFinalSimulado,
                      ahorroActual: ahorroActual,
                      diferencia: diferencia,
                      mejora: mejora,
                      cantidadFacturas: facturasSimuladas.length,
                      dppPercentage: _dppPercentage,
                      paymentDays: _paymentDays,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
