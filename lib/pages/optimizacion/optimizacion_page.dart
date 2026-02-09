import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facturacion_demo/providers/factura_provider.dart';
import 'package:facturacion_demo/providers/pago_provider.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/pages/optimizacion/widgets/invoice_selector.dart';
import 'package:facturacion_demo/pages/optimizacion/widgets/optimization_summary.dart';
import 'package:facturacion_demo/pages/optimizacion/widgets/payment_actions.dart';
import 'package:facturacion_demo/functions/money_format.dart';

/// ============================================================================
/// OPTIMIZACIÓN DE PAGOS PAGE
/// ============================================================================
/// Core feature: Selección inteligente de facturas para optimizar pagos
/// y maximizar ahorros mediante DPP (Descuento por Pronto Pago)
/// ============================================================================
class OptimizacionPage extends StatefulWidget {
  const OptimizacionPage({super.key});

  @override
  State<OptimizacionPage> createState() => _OptimizacionPageState();
}

class _OptimizacionPageState extends State<OptimizacionPage> {
  // IDs de facturas seleccionadas
  final Set<String> _selectedInvoiceIds = {};

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final facturaProvider = context.watch<FacturaProvider>();
    final pagoProvider = context.watch<PagoProvider>();

    // Obtener facturas pendientes (candidatas para optimización)
    final facturasPendientes =
        facturaProvider.facturas.where((f) => f.estado == 'pendiente').toList();

    // Filtrar facturas seleccionadas
    final facturasSeleccionadas = facturasPendientes
        .where((f) => _selectedInvoiceIds.contains(f.id))
        .toList();

    // Calcular totales
    final montoTotal = facturasSeleccionadas.fold<double>(
      0.0,
      (sum, f) => sum + f.importe,
    );

    final ahorroTotal = facturasSeleccionadas.fold<double>(
      0.0,
      (sum, f) => sum + f.montoDPP,
    );

    final montoFinal = montoTotal - ahorroTotal;

    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título y descripción
            Text(
              'Optimización de Pagos',
              style: TextStyle(
                fontSize: isMobile ? 24 : 32,
                fontWeight: FontWeight.bold,
                color: theme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selecciona las facturas pendientes que deseas incluir en el pago optimizado para maximizar ahorros mediante DPP.',
              style: TextStyle(
                fontSize: 14,
                color: theme.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            // Layout responsivo
            if (isMobile)
              // Mobile: Stack vertical
              Column(
                children: [
                  // Resumen superior
                  OptimizationSummary(
                    cantidadSeleccionada: facturasSeleccionadas.length,
                    montoTotal: montoTotal,
                    ahorroTotal: ahorroTotal,
                    montoFinal: montoFinal,
                  ),
                  const SizedBox(height: 24),

                  // Selector de facturas
                  InvoiceSelector(
                    facturas: facturasPendientes,
                    selectedIds: _selectedInvoiceIds,
                    onSelectionChanged: (ids) {
                      setState(() {
                        _selectedInvoiceIds.clear();
                        _selectedInvoiceIds.addAll(ids);
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Acciones
                  PaymentActions(
                    isDisabled: facturasSeleccionadas.isEmpty,
                    onProponer: () => _propenerPago(
                      context,
                      facturasSeleccionadas,
                      montoFinal,
                      ahorroTotal,
                      pagoProvider,
                    ),
                    onEjecutar: () => _ejecutarPago(
                      context,
                      facturasSeleccionadas,
                      montoFinal,
                      ahorroTotal,
                      pagoProvider,
                      facturaProvider,
                    ),
                  ),
                ],
              )
            else
              // Desktop: Grid 2 columnas
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Columna izquierda: Selector (60%)
                  Expanded(
                    flex: 6,
                    child: InvoiceSelector(
                      facturas: facturasPendientes,
                      selectedIds: _selectedInvoiceIds,
                      onSelectionChanged: (ids) {
                        setState(() {
                          _selectedInvoiceIds.clear();
                          _selectedInvoiceIds.addAll(ids);
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 24),

                  // Columna derecha: Resumen + Acciones (40%)
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        OptimizationSummary(
                          cantidadSeleccionada: facturasSeleccionadas.length,
                          montoTotal: montoTotal,
                          ahorroTotal: ahorroTotal,
                          montoFinal: montoFinal,
                        ),
                        const SizedBox(height: 24),
                        PaymentActions(
                          isDisabled: facturasSeleccionadas.isEmpty,
                          onProponer: () => _propenerPago(
                            context,
                            facturasSeleccionadas,
                            montoFinal,
                            ahorroTotal,
                            pagoProvider,
                          ),
                          onEjecutar: () => _ejecutarPago(
                            context,
                            facturasSeleccionadas,
                            montoFinal,
                            ahorroTotal,
                            pagoProvider,
                            facturaProvider,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  /// Proponer pago optimizado (simulado)
  void _propenerPago(
    BuildContext context,
    List<dynamic> facturas,
    double montoFinal,
    double ahorro,
    PagoProvider pagoProvider,
  ) {
    if (facturas.isEmpty) return;

    // Simular creación de propuesta
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Propuesta de pago creada: ${facturas.length} facturas por ${moneyFormat(montoFinal)} con ahorro de ${moneyFormat(ahorro)}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Ejecutar pago (simulado con éxito)
  void _ejecutarPago(
    BuildContext context,
    List<dynamic> facturas,
    double montoFinal,
    double ahorro,
    PagoProvider pagoProvider,
    FacturaProvider facturaProvider,
  ) {
    if (facturas.isEmpty) return;

    // Mostrar confirmación
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.orange),
            SizedBox(width: 12),
            Text('Confirmar Ejecución'),
          ],
        ),
        content: Text(
          '\u00bfDeseas ejecutar el pago de ${facturas.length} facturas por ${moneyFormat(montoFinal)}?\n\n'
          'Ahorro generado: ${moneyFormat(ahorro)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();

              // Simular ejecución exitosa
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '\u00a1Pago ejecutado exitosamente! Ahorro: ${moneyFormat(ahorro)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 5),
                ),
              );

              // Limpiar selección
              setState(() {
                _selectedInvoiceIds.clear();
              });
            },
            child: const Text('Ejecutar Pago'),
          ),
        ],
      ),
    );
  }
}
