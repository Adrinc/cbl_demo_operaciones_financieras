import 'package:flutter/material.dart';
import 'package:facturacion_demo/pages/facturas/widgets/factura_pluto_grid.dart';
import 'package:facturacion_demo/pages/facturas/widgets/factura_mobile_cards.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// FACTURAS PAGE
/// ============================================================================
/// Página de gestión de facturas con PlutoGrid (desktop) y Cards (mobile)
/// Responsive: Desktop muestra tabla, móvil muestra tarjetas con paginación
/// ============================================================================

class FacturasPage extends StatelessWidget {
  const FacturasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < mobileSize;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Desktop: PlutoGrid
          if (!isMobile)
            SizedBox(
              height: MediaQuery.of(context).size.height - 180,
              child: const FacturaPlutoGrid(),
            ),

          // Mobile: Cards con paginación
          if (isMobile) const FacturaMobileCards(),
        ],
      ),
    );
  }
}
