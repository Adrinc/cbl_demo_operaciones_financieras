/// Modelo de Factura (Invoice)
class Factura {
  final String id;
  final String proveedorId;
  final String proveedorNombre;
  final String numeroFactura;
  final double importe;
  final String moneda;
  final DateTime fechaEmision;
  final DateTime fechaVencimiento;
  final int diasParaPago;
  final double porcentajeDPP;
  final double montoDPP; // Amount saved with DPP
  final double montoConDPP; // Final amount with DPP applied
  final String esquema; // 'pull' | 'push'
  final String estado; // 'pendiente' | 'pagada' | 'vencida' | 'cancelada'
  final String? notaCreditoId;
  final DateTime? fechaPago;

  Factura({
    required this.id,
    required this.proveedorId,
    required this.proveedorNombre,
    required this.numeroFactura,
    required this.importe,
    required this.moneda,
    required this.fechaEmision,
    required this.fechaVencimiento,
    required this.diasParaPago,
    required this.porcentajeDPP,
    required this.montoDPP,
    required this.montoConDPP,
    required this.esquema,
    required this.estado,
    this.notaCreditoId,
    this.fechaPago,
  });

  Factura copyWith({
    String? id,
    String? proveedorId,
    String? proveedorNombre,
    String? numeroFactura,
    double? importe,
    String? moneda,
    DateTime? fechaEmision,
    DateTime? fechaVencimiento,
    int? diasParaPago,
    double? porcentajeDPP,
    double? montoDPP,
    double? montoConDPP,
    String? esquema,
    String? estado,
    String? notaCreditoId,
    DateTime? fechaPago,
  }) {
    return Factura(
      id: id ?? this.id,
      proveedorId: proveedorId ?? this.proveedorId,
      proveedorNombre: proveedorNombre ?? this.proveedorNombre,
      numeroFactura: numeroFactura ?? this.numeroFactura,
      importe: importe ?? this.importe,
      moneda: moneda ?? this.moneda,
      fechaEmision: fechaEmision ?? this.fechaEmision,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      diasParaPago: diasParaPago ?? this.diasParaPago,
      porcentajeDPP: porcentajeDPP ?? this.porcentajeDPP,
      montoDPP: montoDPP ?? this.montoDPP,
      montoConDPP: montoConDPP ?? this.montoConDPP,
      esquema: esquema ?? this.esquema,
      estado: estado ?? this.estado,
      notaCreditoId: notaCreditoId ?? this.notaCreditoId,
      fechaPago: fechaPago ?? this.fechaPago,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'proveedorId': proveedorId,
      'proveedorNombre': proveedorNombre,
      'numeroFactura': numeroFactura,
      'importe': importe,
      'moneda': moneda,
      'fechaEmision': fechaEmision.toIso8601String(),
      'fechaVencimiento': fechaVencimiento.toIso8601String(),
      'diasParaPago': diasParaPago,
      'porcentajeDPP': porcentajeDPP,
      'montoDPP': montoDPP,
      'montoConDPP': montoConDPP,
      'esquema': esquema,
      'estado': estado,
      'notaCreditoId': notaCreditoId,
      'fechaPago': fechaPago?.toIso8601String(),
    };
  }

  factory Factura.fromJson(Map<String, dynamic> json) {
    return Factura(
      id: json['id'],
      proveedorId: json['proveedorId'],
      proveedorNombre: json['proveedorNombre'],
      numeroFactura: json['numeroFactura'],
      importe: json['importe'].toDouble(),
      moneda: json['moneda'],
      fechaEmision: DateTime.parse(json['fechaEmision']),
      fechaVencimiento: DateTime.parse(json['fechaVencimiento']),
      diasParaPago: json['diasParaPago'],
      porcentajeDPP: json['porcentajeDPP'].toDouble(),
      montoDPP: json['montoDPP'].toDouble(),
      montoConDPP: json['montoConDPP'].toDouble(),
      esquema: json['esquema'],
      estado: json['estado'],
      notaCreditoId: json['notaCreditoId'],
      fechaPago: json['fechaPago'] != null ? DateTime.parse(json['fechaPago']) : null,
    );
  }
}
