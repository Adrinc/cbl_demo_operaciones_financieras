import 'package:flutter/material.dart';
import 'package:facturacion_demo/pages/facturas/widgets/factura_pluto_grid.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// FACTURAS PAGE
/// ============================================================================
/// Página de gestión de facturas con PlutoGrid y CRUD completo
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
          SizedBox(
            height: MediaQuery.of(context).size.height - (isMobile ? 150 : 180),
            child: const FacturaPlutoGrid(),
          ),
        ],
      ),
    );
  }
}
