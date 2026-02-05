import 'package:flutter/material.dart';
import 'package:facturacion_demo/models/models.dart';
import 'package:facturacion_demo/data/mock_data.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// FACTURA PROVIDER
/// ============================================================================
/// Gestiona el estado y operaciones CRUD de facturas (en memoria)
/// Los cambios persisten durante la sesión pero se pierden al reiniciar
/// ============================================================================
class FacturaProvider extends ChangeNotifier {
  List<Factura> _facturas = [];

  List<Factura> get facturas => List.unmodifiable(_facturas);

  /// Constructor que carga los datos mock
  FacturaProvider() {
    _loadMockData();
  }

  /// Carga los datos mock iniciales
  void _loadMockData() {
    _facturas = List.from(mockFacturas);
    notifyListeners();
  }

  /// Obtiene una factura por ID
  Factura? getFacturaById(String id) {
    try {
      return _facturas.firstWhere((f) => f.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene facturas por estado
  List<Factura> getFacturasByEstado(String estado) {
    return _facturas.where((f) => f.estado == estado).toList();
  }

  /// Obtiene facturas por proveedor
  List<Factura> getFacturasByProveedor(String proveedorId) {
    return _facturas.where((f) => f.proveedorId == proveedorId).toList();
  }

  /// Obtiene facturas con DPP disponible
  List<Factura> getFacturasConDPP() {
    return _facturas
        .where(
            (f) => f.porcentajeDPP > 0 && f.estado == EstadoFactura.pendiente)
        .toList();
  }

  /// Obtiene facturas vencidas
  List<Factura> getFacturasVencidas() {
    return _facturas.where((f) => f.estado == EstadoFactura.vencida).toList();
  }

  /// Agrega una nueva factura
  void addFactura(Factura factura) {
    _facturas.add(factura);
    notifyListeners();
  }

  /// Actualiza una factura existente
  void updateFactura(Factura factura) {
    final index = _facturas.indexWhere((f) => f.id == factura.id);
    if (index != -1) {
      _facturas[index] = factura;
      notifyListeners();
    }
  }

  /// Elimina una factura por ID
  void deleteFactura(String id) {
    _facturas.removeWhere((f) => f.id == id);
    notifyListeners();
  }

  /// Marca una factura como pagada
  void marcarComoPagada(String id, DateTime fechaPago) {
    final index = _facturas.indexWhere((f) => f.id == id);
    if (index != -1) {
      final factura = _facturas[index];
      _facturas[index] = Factura(
        id: factura.id,
        proveedorId: factura.proveedorId,
        proveedorNombre: factura.proveedorNombre,
        numeroFactura: factura.numeroFactura,
        importe: factura.importe,
        moneda: factura.moneda,
        fechaEmision: factura.fechaEmision,
        fechaVencimiento: factura.fechaVencimiento,
        diasParaPago: factura.diasParaPago,
        porcentajeDPP: factura.porcentajeDPP,
        montoDPP: factura.montoDPP,
        montoConDPP: factura.montoConDPP,
        esquema: factura.esquema,
        estado: EstadoFactura.pagada,
        notaCreditoId: factura.notaCreditoId,
        fechaPago: fechaPago,
      );
      notifyListeners();
    }
  }

  /// Calcula el total de facturas pendientes
  double getTotalPendiente() {
    return _facturas
        .where((f) => f.estado == EstadoFactura.pendiente)
        .fold(0.0, (sum, f) => sum + f.importe);
  }

  /// Calcula el ahorro potencial disponible
  double getAhorroPotencial() {
    return _facturas
        .where(
            (f) => f.estado == EstadoFactura.pendiente && f.porcentajeDPP > 0)
        .fold(0.0, (sum, f) => sum + f.montoDPP);
  }

  /// Calcula el ahorro perdido (facturas vencidas con DPP)
  double getAhorroPerdido() {
    return _facturas
        .where((f) => f.estado == EstadoFactura.vencida && f.porcentajeDPP > 0)
        .fold(0.0, (sum, f) => sum + f.montoDPP);
  }

  /// Resetea los datos a los valores mock originales
  void resetData() {
    _loadMockData();
  }

  /// Obtiene el conteo de facturas por estado
  Map<String, int> getFacturasCountByEstado() {
    return {
      EstadoFactura.pendiente:
          _facturas.where((f) => f.estado == EstadoFactura.pendiente).length,
      EstadoFactura.pagada:
          _facturas.where((f) => f.estado == EstadoFactura.pagada).length,
      EstadoFactura.vencida:
          _facturas.where((f) => f.estado == EstadoFactura.vencida).length,
      EstadoFactura.cancelada:
          _facturas.where((f) => f.estado == EstadoFactura.cancelada).length,
    };
  }
}
