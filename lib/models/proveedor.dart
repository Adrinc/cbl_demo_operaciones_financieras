import 'dart:typed_data';

/// Modelo de Proveedor (Supplier)
class Proveedor {
  final String id;
  final String nombre;
  final String rfc;
  final String esquemaActivo; // 'pull' | 'push'
  final int diasPago; // Standard payment days
  final bool dppPermitido;
  final double porcentajeDPPBase;
  final int diasGraciaDPP;
  final String contacto;
  final String email;
  final String estado; // 'activo' | 'inactivo'
  final String?
      logo; // Logo filename (e.g., 'nexus.png') - for predefined logos
  final Uint8List? logoBytes; // Custom uploaded logo bytes

  Proveedor({
    required this.id,
    required this.nombre,
    required this.rfc,
    required this.esquemaActivo,
    required this.diasPago,
    required this.dppPermitido,
    required this.porcentajeDPPBase,
    required this.diasGraciaDPP,
    required this.contacto,
    required this.email,
    required this.estado,
    this.logo,
    this.logoBytes,
  });

  Proveedor copyWith({
    String? id,
    String? nombre,
    String? rfc,
    String? esquemaActivo,
    int? diasPago,
    bool? dppPermitido,
    double? porcentajeDPPBase,
    int? diasGraciaDPP,
    String? contacto,
    String? email,
    String? estado,
    String? logo,
    Uint8List? logoBytes,
  }) {
    return Proveedor(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      rfc: rfc ?? this.rfc,
      esquemaActivo: esquemaActivo ?? this.esquemaActivo,
      diasPago: diasPago ?? this.diasPago,
      dppPermitido: dppPermitido ?? this.dppPermitido,
      porcentajeDPPBase: porcentajeDPPBase ?? this.porcentajeDPPBase,
      diasGraciaDPP: diasGraciaDPP ?? this.diasGraciaDPP,
      contacto: contacto ?? this.contacto,
      email: email ?? this.email,
      estado: estado ?? this.estado,
      logo: logo ?? this.logo,
      logoBytes: logoBytes ?? this.logoBytes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'rfc': rfc,
      'esquemaActivo': esquemaActivo,
      'diasPago': diasPago,
      'dppPermitido': dppPermitido,
      'porcentajeDPPBase': porcentajeDPPBase,
      'diasGraciaDPP': diasGraciaDPP,
      'contacto': contacto,
      'email': email,
      'estado': estado,
      'logo': logo,
    };
  }

  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      id: json['id'],
      nombre: json['nombre'],
      rfc: json['rfc'],
      esquemaActivo: json['esquemaActivo'],
      diasPago: json['diasPago'],
      dppPermitido: json['dppPermitido'],
      porcentajeDPPBase: json['porcentajeDPPBase'].toDouble(),
      diasGraciaDPP: json['diasGraciaDPP'],
      contacto: json['contacto'],
      email: json['email'],
      estado: json['estado'],
      logo: json['logo'],
    );
  }
}
