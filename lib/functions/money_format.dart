/// Formatea un monto de dinero en formato USD con símbolo y moneda
/// Ejemplo: 22780.5 → "$ 22,780.50 USD"
String moneyFormat(double x, {String currency = 'USD'}) {
  List<String> parts = x.toStringAsFixed(2).split('.');
  RegExp re = RegExp(r'\B(?=(\d{3})+(?!\d))');

  parts[0] = parts[0].replaceAll(re, ',');
  return '\$ ${parts.join('.')} $currency';
}

/// Formatea un monto compacto sin moneda
/// Ejemplo: 22780.5 → "$ 22,780.50"
String moneyFormatCompact(double x) {
  List<String> parts = x.toStringAsFixed(2).split('.');
  RegExp re = RegExp(r'\B(?=(\d{3})+(?!\d))');

  parts[0] = parts[0].replaceAll(re, ',');
  return '\$ ${parts.join('.')}';
}
