/// ============================================================================
/// PROVEEDOR LOGO HELPER
/// ============================================================================
/// Función para obtener el path del logo de un proveedor basado en su nombre
/// Los logos están en assets/images/isotipos/ con nombres en minúsculas
/// ============================================================================

/// Obtiene el path del logo de un proveedor basado en su nombre
/// Ejemplo: "Nexus Industries" -> "assets/images/isotipos/nexus.png"
String getProveedorLogoPath(String nombreProveedor) {
  // Extraer la primera palabra del nombre del proveedor
  final firstWord = nombreProveedor.split(' ').first.toLowerCase();
  return 'assets/images/isotipos/$firstWord.png';
}

/// Obtiene solo el nombre del archivo del logo (sin path)
/// Ejemplo: "Nexus Industries" -> "nexus.png"
String getProveedorLogoFileName(String nombreProveedor) {
  final firstWord = nombreProveedor.split(' ').first.toLowerCase();
  return '$firstWord.png';
}
