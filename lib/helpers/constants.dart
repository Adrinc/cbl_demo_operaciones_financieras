// Demo de Optimización de Pagos - Constants
// Configuración central de la aplicación

// ==============================================
// INFORMACIÓN DE LA EMPRESA / DEMO
// ==============================================
const String appName = 'ARXIS';
const String appFullName = 'Sistema de Optimización de Pagos';
const String appTagline = 'Optimiza tus pagos, maximiza tu ahorro';

// ==============================================
// CONFIGURACIÓN DEL EJERCICIO FISCAL
// ==============================================
const int ejercicioFiscal = 2026;
const String ejercicioNombre = 'Ejercicio Fiscal 2026';
const String monedaPredeterminada = 'USD';

// ==============================================
// RESPONSIVE BREAKPOINT
// ==============================================
const int mobileSize = 768; // Ancho mínimo para desktop

// ==============================================
// RUTAS DE NAVEGACIÓN
// ==============================================
class Routes {
  static const String dashboard = '/';
  static const String facturas = '/facturas';
  static const String optimizacion = '/optimizacion';
  static const String simulador = '/simulador';
  static const String validaciones = '/validaciones';
  static const String proveedores = '/proveedores';
  static const String reportes = '/reportes';
  static const String configuracion = '/configuracion';
  static const String notFound = '/404';
}

// ==============================================
// URL EXTERNA
// ==============================================
const String urlSitioWeb = 'https://cbluna.com/';

// ==============================================
// INFORMACIÓN DEL DEMO
// ==============================================
const String demoVersion = '1.0.0';
const String demoDisclaimer =
    'Esta es una demostración interactiva con datos simulados. '
    'No se conecta a servidores reales y los cambios se pierden al recargar la página.';
const String demoRoleNote =
    'El sistema soporta múltiples roles y niveles de acceso, '
    'los cuales no se muestran en esta versión demostrativa.';

// ==============================================
// USUARIO DEMO (ADMINISTRADOR)
// ==============================================
const String adminName = 'María';
const String adminRole = 'Administrador';
const String adminEmail = 'maria@demo.com';
const String adminAvatarPath = 'assets/images/avatares/Maria.png';

// ==============================================
// ESTADOS DE FACTURA
// ==============================================
class EstadoFactura {
  static const String pendiente = 'pendiente';
  static const String pagada = 'pagada';
  static const String vencida = 'vencida';
  static const String cancelada = 'cancelada';
}

// ==============================================
// ESQUEMAS DE PAGO
// ==============================================
class EsquemaPago {
  static const String pull = 'pull';
  static const String push = 'push';
}

// ==============================================
// ESTADOS DE VALIDACIÓN
// ==============================================
class EstadoValidacion {
  static const String pendiente = 'pendiente';
  static const String aprobado = 'aprobado';
  static const String rechazado = 'rechazado';
}

// ==============================================
// ESTADOS DE PAGO
// ==============================================
class EstadoPago {
  static const String propuesto = 'propuesto';
  static const String aprobado = 'aprobado';
  static const String ejecutado = 'ejecutado';
  static const String rechazado = 'rechazado';
}

// ==============================================
// TIPOS DE VALIDACIÓN
// ==============================================
class TipoValidacion {
  static const String notaCredito = 'nota_credito';
  static const String estadoPago = 'estado_pago';
  static const String condicionComercial = 'condicion_comercial';
}

// ==============================================
// ESTADOS DE PROVEEDOR
// ==============================================
class EstadoProveedor {
  static const String activo = 'activo';
  static const String inactivo = 'inactivo';
}

// ==============================================
// LÍMITES Y CONFIGURACIÓN
// ==============================================
const int plutoGridPageSize = 15; // Registros por página en PlutoGrid
const int dppMaxDias = 90; // Máximo de días para DPP
const double dppMaxPorcentaje = 10.0; // Máximo porcentaje de DPP
const int alertaDiasDPP = 7; // Días de alerta para DPP próximo a vencer
