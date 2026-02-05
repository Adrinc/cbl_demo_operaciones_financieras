/// Formatea un porcentaje con 2 decimales y símbolo %
/// Ejemplo: 4.5 → "4.50 %"
String formatPercentage(double percentage) {
  return '${percentage.toStringAsFixed(2)} %';
}

/// Formatea un porcentaje compacto (sin decimales si es entero)
/// Ejemplo: 4.0 → "4%", 4.5 → "4.5%"
String formatPercentageCompact(double percentage) {
  if (percentage == percentage.roundToDouble()) {
    return '${percentage.toStringAsFixed(0)}%';
  }
  return '${percentage.toStringAsFixed(1)}%';
}
