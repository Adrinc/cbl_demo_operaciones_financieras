/// Modelo de Nota de Crédito (Credit Note)
class NotaCredito {
  final String id;
  final String facturaId;
  final double monto;
  final String motivo;
  final String estado; // 'pendiente' | 'aplicada' | 'rechazada'
  final DateTime fecha;

  NotaCredito({
    required this.id,
    required this.facturaId,
    required this.monto,
    required this.motivo,
    required this.estado,
    required this.fecha,
  });

  NotaCredito copyWith({
    String? id,
    String? facturaId,
    double? monto,
    String? motivo,
    String? estado,
    DateTime? fecha,
  }) {
    return NotaCredito(
      id: id ?? this.id,
      facturaId: facturaId ?? this.facturaId,
      monto: monto ?? this.monto,
      motivo: motivo ?? this.motivo,
      estado: estado ?? this.estado,
      fecha: fecha ?? this.fecha,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'facturaId': facturaId,
      'monto': monto,
      'motivo': motivo,
      'estado': estado,
      'fecha': fecha.toIso8601String(),
    };
  }

  factory NotaCredito.fromJson(Map<String, dynamic> json) {
    return NotaCredito(
      id: json['id'],
      facturaId: json['facturaId'],
      monto: json['monto'].toDouble(),
      motivo: json['motivo'],
      estado: json['estado'],
      fecha: DateTime.parse(json['fecha']),
    );
  }
}
