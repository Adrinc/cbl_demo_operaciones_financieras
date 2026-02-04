/// Modelo de Pago (Payment)
class Pago {
  final String id;
  final List<String> facturaIds;
  final double montoTotal;
  final double ahorroGenerado;
  final DateTime fechaPropuesta;
  final DateTime? fechaEjecucion;
  final String estado; // 'propuesto' | 'aprobado' | 'ejecutado' | 'rechazado'
  final String tipo; // 'optimizado' | 'normal'

  Pago({
    required this.id,
    required this.facturaIds,
    required this.montoTotal,
    required this.ahorroGenerado,
    required this.fechaPropuesta,
    this.fechaEjecucion,
    required this.estado,
    required this.tipo,
  });

  Pago copyWith({
    String? id,
    List<String>? facturaIds,
    double? montoTotal,
    double? ahorroGenerado,
    DateTime? fechaPropuesta,
    DateTime? fechaEjecucion,
    String? estado,
    String? tipo,
  }) {
    return Pago(
      id: id ?? this.id,
      facturaIds: facturaIds ?? this.facturaIds,
      montoTotal: montoTotal ?? this.montoTotal,
      ahorroGenerado: ahorroGenerado ?? this.ahorroGenerado,
      fechaPropuesta: fechaPropuesta ?? this.fechaPropuesta,
      fechaEjecucion: fechaEjecucion ?? this.fechaEjecucion,
      estado: estado ?? this.estado,
      tipo: tipo ?? this.tipo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'facturaIds': facturaIds,
      'montoTotal': montoTotal,
      'ahorroGenerado': ahorroGenerado,
      'fechaPropuesta': fechaPropuesta.toIso8601String(),
      'fechaEjecucion': fechaEjecucion?.toIso8601String(),
      'estado': estado,
      'tipo': tipo,
    };
  }

  factory Pago.fromJson(Map<String, dynamic> json) {
    return Pago(
      id: json['id'],
      facturaIds: List<String>.from(json['facturaIds']),
      montoTotal: json['montoTotal'].toDouble(),
      ahorroGenerado: json['ahorroGenerado'].toDouble(),
      fechaPropuesta: DateTime.parse(json['fechaPropuesta']),
      fechaEjecucion: json['fechaEjecucion'] != null 
          ? DateTime.parse(json['fechaEjecucion']) 
          : null,
      estado: json['estado'],
      tipo: json['tipo'],
    );
  }
}
