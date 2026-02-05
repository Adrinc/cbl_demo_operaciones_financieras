import 'package:flutter/material.dart';
import 'package:facturacion_demo/models/models.dart';
import 'package:facturacion_demo/data/mock_data.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// VALIDACION PROVIDER
/// ============================================================================
/// Gestiona el estado y operaciones de validaciones y notas de crédito (en memoria)
/// Los cambios persisten durante la sesión pero se pierden al reiniciar
/// ============================================================================
class ValidacionProvider extends ChangeNotifier {
  List<Validacion> _validaciones = [];
  List<NotaCredito> _notasCredito = [];

  List<Validacion> get validaciones => List.unmodifiable(_validaciones);
  List<NotaCredito> get notasCredito => List.unmodifiable(_notasCredito);

  /// Constructor que carga los datos mock
  ValidacionProvider() {
    _loadMockData();
  }

  /// Carga los datos mock iniciales
  void _loadMockData() {
    _validaciones = List.from(mockValidaciones);
    _notasCredito = List.from(mockNotasCredito);
    notifyListeners();
  }

  // ============================================================================
  // VALIDACIONES
  // ============================================================================

  /// Obtiene una validación por ID
  Validacion? getValidacionById(String id) {
    try {
      return _validaciones.firstWhere((v) => v.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene validaciones por estado
  List<Validacion> getValidacionesByEstado(String estado) {
    return _validaciones.where((v) => v.estado == estado).toList();
  }

  /// Obtiene validaciones por tipo
  List<Validacion> getValidacionesByTipo(String tipo) {
    return _validaciones.where((v) => v.tipo == tipo).toList();
  }

  /// Obtiene validaciones pendientes
  List<Validacion> getValidacionesPendientes() {
    return _validaciones
        .where((v) => v.estado == EstadoValidacion.pendiente)
        .toList();
  }

  /// Agrega una nueva validación
  void addValidacion(Validacion validacion) {
    _validaciones.add(validacion);
    notifyListeners();
  }

  /// Actualiza una validación existente
  void updateValidacion(Validacion validacion) {
    final index = _validaciones.indexWhere((v) => v.id == validacion.id);
    if (index != -1) {
      _validaciones[index] = validacion;
      notifyListeners();
    }
  }

  /// Elimina una validación por ID
  void deleteValidacion(String id) {
    _validaciones.removeWhere((v) => v.id == id);
    notifyListeners();
  }

  /// Aprueba una validación
  void aprobarValidacion(String id, String motivo) {
    final index = _validaciones.indexWhere((v) => v.id == id);
    if (index != -1) {
      final validacion = _validaciones[index];
      _validaciones[index] = Validacion(
        id: validacion.id,
        tipo: validacion.tipo,
        facturaId: validacion.facturaId,
        descripcion: validacion.descripcion,
        estado: EstadoValidacion.aprobado,
        fecha: validacion.fecha,
        motivo: motivo,
      );
      notifyListeners();
    }
  }

  /// Rechaza una validación
  void rechazarValidacion(String id, String motivo) {
    final index = _validaciones.indexWhere((v) => v.id == id);
    if (index != -1) {
      final validacion = _validaciones[index];
      _validaciones[index] = Validacion(
        id: validacion.id,
        tipo: validacion.tipo,
        facturaId: validacion.facturaId,
        descripcion: validacion.descripcion,
        estado: EstadoValidacion.rechazado,
        fecha: validacion.fecha,
        motivo: motivo,
      );
      notifyListeners();
    }
  }

  // ============================================================================
  // NOTAS DE CRÉDITO
  // ============================================================================

  /// Obtiene una nota de crédito por ID
  NotaCredito? getNotaCreditoById(String id) {
    try {
      return _notasCredito.firstWhere((nc) => nc.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene notas de crédito por factura
  List<NotaCredito> getNotasCreditoByFactura(String facturaId) {
    return _notasCredito.where((nc) => nc.facturaId == facturaId).toList();
  }

  /// Obtiene notas de crédito por estado
  List<NotaCredito> getNotasCreditoByEstado(String estado) {
    return _notasCredito.where((nc) => nc.estado == estado).toList();
  }

  /// Obtiene notas de crédito pendientes
  List<NotaCredito> getNotasCreditoPendientes() {
    return _notasCredito.where((nc) => nc.estado == 'pendiente').toList();
  }

  /// Agrega una nueva nota de crédito
  void addNotaCredito(NotaCredito notaCredito) {
    _notasCredito.add(notaCredito);
    notifyListeners();
  }

  /// Actualiza una nota de crédito existente
  void updateNotaCredito(NotaCredito notaCredito) {
    final index = _notasCredito.indexWhere((nc) => nc.id == notaCredito.id);
    if (index != -1) {
      _notasCredito[index] = notaCredito;
      notifyListeners();
    }
  }

  /// Elimina una nota de crédito por ID
  void deleteNotaCredito(String id) {
    _notasCredito.removeWhere((nc) => nc.id == id);
    notifyListeners();
  }

  /// Aplica una nota de crédito
  void aplicarNotaCredito(String id) {
    final index = _notasCredito.indexWhere((nc) => nc.id == id);
    if (index != -1) {
      final notaCredito = _notasCredito[index];
      _notasCredito[index] = NotaCredito(
        id: notaCredito.id,
        facturaId: notaCredito.facturaId,
        monto: notaCredito.monto,
        motivo: notaCredito.motivo,
        estado: 'aplicada',
        fecha: notaCredito.fecha,
      );
      notifyListeners();
    }
  }

  /// Rechaza una nota de crédito
  void rechazarNotaCredito(String id) {
    final index = _notasCredito.indexWhere((nc) => nc.id == id);
    if (index != -1) {
      final notaCredito = _notasCredito[index];
      _notasCredito[index] = NotaCredito(
        id: notaCredito.id,
        facturaId: notaCredito.facturaId,
        monto: notaCredito.monto,
        motivo: notaCredito.motivo,
        estado: 'rechazada',
        fecha: notaCredito.fecha,
      );
      notifyListeners();
    }
  }

  /// Resetea los datos a los valores mock originales
  void resetData() {
    _loadMockData();
  }

  /// Obtiene el conteo de validaciones por estado
  Map<String, int> getValidacionesCountByEstado() {
    return {
      EstadoValidacion.pendiente: _validaciones
          .where((v) => v.estado == EstadoValidacion.pendiente)
          .length,
      EstadoValidacion.aprobado: _validaciones
          .where((v) => v.estado == EstadoValidacion.aprobado)
          .length,
      EstadoValidacion.rechazado: _validaciones
          .where((v) => v.estado == EstadoValidacion.rechazado)
          .length,
    };
  }

  /// Obtiene el conteo de notas de crédito por estado
  Map<String, int> getNotasCreditoCountByEstado() {
    return {
      'pendiente': _notasCredito.where((nc) => nc.estado == 'pendiente').length,
      'aplicada': _notasCredito.where((nc) => nc.estado == 'aplicada').length,
      'rechazada': _notasCredito.where((nc) => nc.estado == 'rechazada').length,
    };
  }
}
