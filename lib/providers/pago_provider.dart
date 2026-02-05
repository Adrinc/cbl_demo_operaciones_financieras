import 'package:flutter/material.dart';
import 'package:facturacion_demo/models/models.dart';
import 'package:facturacion_demo/data/mock_data.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// PAGO PROVIDER
/// ============================================================================
/// Gestiona el estado y operaciones CRUD de pagos (en memoria)
/// Los cambios persisten durante la sesión pero se pierden al reiniciar
/// ============================================================================
class PagoProvider extends ChangeNotifier {
  List<Pago> _pagos = [];

  List<Pago> get pagos => List.unmodifiable(_pagos);

  /// Constructor que carga los datos mock
  PagoProvider() {
    _loadMockData();
  }

  /// Carga los datos mock iniciales
  void _loadMockData() {
    _pagos = List.from(mockPagos);
    notifyListeners();
  }

  /// Obtiene un pago por ID
  Pago? getPagoById(String id) {
    try {
      return _pagos.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene pagos por estado
  List<Pago> getPagosByEstado(String estado) {
    return _pagos.where((p) => p.estado == estado).toList();
  }

  /// Obtiene pagos ejecutados
  List<Pago> getPagosEjecutados() {
    return _pagos.where((p) => p.estado == EstadoPago.ejecutado).toList();
  }

  /// Obtiene pagos propuestos pendientes
  List<Pago> getPagosPropuestos() {
    return _pagos.where((p) => p.estado == EstadoPago.propuesto).toList();
  }

  /// Obtiene pagos optimizados
  List<Pago> getPagosOptimizados() {
    return _pagos.where((p) => p.tipo == 'optimizado').toList();
  }

  /// Agrega un nuevo pago
  void addPago(Pago pago) {
    _pagos.add(pago);
    notifyListeners();
  }

  /// Actualiza un pago existente
  void updatePago(Pago pago) {
    final index = _pagos.indexWhere((p) => p.id == pago.id);
    if (index != -1) {
      _pagos[index] = pago;
      notifyListeners();
    }
  }

  /// Elimina un pago por ID
  void deletePago(String id) {
    _pagos.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  /// Ejecuta un pago propuesto
  void ejecutarPago(String id, DateTime fechaEjecucion) {
    final index = _pagos.indexWhere((p) => p.id == id);
    if (index != -1) {
      final pago = _pagos[index];
      _pagos[index] = Pago(
        id: pago.id,
        facturaIds: pago.facturaIds,
        montoTotal: pago.montoTotal,
        ahorroGenerado: pago.ahorroGenerado,
        fechaPropuesta: pago.fechaPropuesta,
        fechaEjecucion: fechaEjecucion,
        estado: EstadoPago.ejecutado,
        tipo: pago.tipo,
      );
      notifyListeners();
    }
  }

  /// Aprueba un pago propuesto
  void aprobarPago(String id) {
    final index = _pagos.indexWhere((p) => p.id == id);
    if (index != -1) {
      final pago = _pagos[index];
      _pagos[index] = Pago(
        id: pago.id,
        facturaIds: pago.facturaIds,
        montoTotal: pago.montoTotal,
        ahorroGenerado: pago.ahorroGenerado,
        fechaPropuesta: pago.fechaPropuesta,
        fechaEjecucion: pago.fechaEjecucion,
        estado: EstadoPago.aprobado,
        tipo: pago.tipo,
      );
      notifyListeners();
    }
  }

  /// Rechaza un pago propuesto
  void rechazarPago(String id) {
    final index = _pagos.indexWhere((p) => p.id == id);
    if (index != -1) {
      final pago = _pagos[index];
      _pagos[index] = Pago(
        id: pago.id,
        facturaIds: pago.facturaIds,
        montoTotal: pago.montoTotal,
        ahorroGenerado: pago.ahorroGenerado,
        fechaPropuesta: pago.fechaPropuesta,
        fechaEjecucion: pago.fechaEjecucion,
        estado: EstadoPago.rechazado,
        tipo: pago.tipo,
      );
      notifyListeners();
    }
  }

  /// Calcula el ahorro total generado
  double getTotalAhorroGenerado() {
    return _pagos
        .where((p) => p.estado == EstadoPago.ejecutado)
        .fold(0.0, (sum, p) => sum + p.ahorroGenerado);
  }

  /// Calcula el ahorro potencial de pagos propuestos
  double getAhorroPotencial() {
    return _pagos
        .where((p) => p.estado == EstadoPago.propuesto)
        .fold(0.0, (sum, p) => sum + p.ahorroGenerado);
  }

  /// Resetea los datos a los valores mock originales
  void resetData() {
    _loadMockData();
  }

  /// Obtiene el conteo de pagos por estado
  Map<String, int> getPagosCountByEstado() {
    return {
      EstadoPago.propuesto:
          _pagos.where((p) => p.estado == EstadoPago.propuesto).length,
      EstadoPago.aprobado:
          _pagos.where((p) => p.estado == EstadoPago.aprobado).length,
      EstadoPago.ejecutado:
          _pagos.where((p) => p.estado == EstadoPago.ejecutado).length,
      EstadoPago.rechazado:
          _pagos.where((p) => p.estado == EstadoPago.rechazado).length,
    };
  }

  /// Obtiene el conteo de pagos por tipo
  Map<String, int> getPagosCountByTipo() {
    return {
      'optimizado': _pagos.where((p) => p.tipo == 'optimizado').length,
      'normal': _pagos.where((p) => p.tipo == 'normal').length,
    };
  }
}
