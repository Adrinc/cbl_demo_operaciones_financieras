import 'package:intl/intl.dart';

/// Formatea una fecha al estilo español completo
/// Ejemplo: DateTime(2026, 1, 3) → "3 de enero del 2026"
String formatDate(DateTime date) {
  final months = [
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
  ];
  
  return '${date.day} de ${months[date.month - 1]} del ${date.year}';
}

/// Formatea una fecha y hora al estilo español completo
/// Ejemplo: DateTime(2026, 1, 3, 13, 30) → "3 de enero del 2026 a las 13:30"
String formatDateTime(DateTime dateTime) {
  final months = [
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
  ];
  
  final timeFormat = DateFormat('HH:mm');
  final timeStr = timeFormat.format(dateTime);
  
  return '${dateTime.day} de ${months[dateTime.month - 1]} del ${dateTime.year} a las $timeStr';
}

/// Formatea solo la hora
/// Ejemplo: DateTime(2026, 1, 3, 13, 30) → "13:30"
String formatTime(DateTime dateTime) {
  final timeFormat = DateFormat('HH:mm');
  return timeFormat.format(dateTime);
}

/// Formatea fecha en formato corto
/// Ejemplo: DateTime(2026, 1, 3) → "03/01/2026"
String formatDateShort(DateTime date) {
  final dateFormat = DateFormat('dd/MM/yyyy');
  return dateFormat.format(date);
}

/// Calcula diferencia de días entre dos fechas
/// Retorna número de días (puede ser negativo si la fecha es futura)
int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

/// Retorna texto relativo de días
/// Ejemplo: -5 → "Vence en 5 días", 0 → "Vence hoy", 5 → "Venció hace 5 días"
String diasRelativoTexto(int dias) {
  if (dias < 0) {
    return 'Vence en ${dias.abs()} día${dias.abs() == 1 ? '' : 's'}';
  } else if (dias == 0) {
    return 'Vence hoy';
  } else {
    return 'Venció hace $dias día${dias == 1 ? '' : 's'}';
  }
}
