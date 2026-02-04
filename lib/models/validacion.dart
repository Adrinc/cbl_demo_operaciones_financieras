/// Modelo de Validación (Validation)
class Validacion {
  final String id;
  final String tipo; // 'nota_credito' | 'estado_pago' | 'condicion_comercial'
  final String facturaId;
  final String descripcion;
  final String estado; // 'pendiente' | 'aprobado' | 'rechazado'
  final DateTime fecha;
  final String? motivo;

  Validacion({
    required this.id,
    required this.tipo,
    required this.facturaId,
    required this.descripcion,
    required this.estado,
    required this.fecha,
    this.motivo,
  });

  Validacion copyWith({
    String? id,
    String? tipo,
    String? facturaId,
    String? descripcion,
    String? estado,
    DateTime? fecha,
    String? motivo,
  }) {
    return Validacion(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      facturaId: facturaId ?? this.facturaId,
      descripcion: descripcion ?? this.descripcion,
      estado: estado ?? this.estado,
      fecha: fecha ?? this.fecha,
      motivo: motivo ?? this.motivo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo,
      'facturaId': facturaId,
      'descripcion': descripcion,
      'estado': estado,
      'fecha': fecha.toIso8601String(),
      'motivo': motivo,
    };
  }

  factory Validacion.fromJson(Map<String, dynamic> json) {
    return Validacion(
      id: json['id'],
      tipo: json['tipo'],
      facturaId: json['facturaId'],
      descripcion: json['descripcion'],
      estado: json['estado'],
      fecha: DateTime.parse(json['fecha']),
      motivo: json['motivo'],
    );
  }
}
