import 'package:flutter/material.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// CONFIGURACIÓN PAGE
/// ============================================================================
/// Página de configuración del ejercicio fiscal y parámetros del sistema
/// Read-only o simulado (demo sin persistencia)
/// ============================================================================
class ConfiguracionPage extends StatefulWidget {
  const ConfiguracionPage({super.key});

  @override
  State<ConfiguracionPage> createState() => _ConfiguracionPageState();
}

class _ConfiguracionPageState extends State<ConfiguracionPage> {
  // Configuración del ejercicio (read-only para demo)
  final int _ejercicioFiscal = 2026;
  final String _moneda = 'USD';
  final double _porcentajeDPPDefecto = 4.0;
  final int _diasUmbralPagoRapido = 15;
  final int _diasUmbralPagoNormal = 30;

  // Notificaciones (simuladas)
  bool _notificarVencimientos = true;
  bool _notificarDPPDisponible = true;
  bool _notificarAhorros = true;
  int _diasAnticipacionAlerta = 7;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final isMobile = MediaQuery.of(context).size.width <= mobileSize;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Configuración del Sistema',
              style: TextStyle(
                fontSize: isMobile ? 24 : 32,
                fontWeight: FontWeight.bold,
                color: theme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Parámetros del ejercicio fiscal y preferencias del sistema',
              style: TextStyle(
                fontSize: 14,
                color: theme.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            // Sección 1: Ejercicio Fiscal
            _buildSection(
              theme: theme,
              isMobile: isMobile,
              title: 'Ejercicio Fiscal',
              icon: Icons.calendar_today,
              iconColor: theme.primary,
              children: [
                _buildReadOnlyField(
                  theme: theme,
                  label: 'Año Fiscal Activo',
                  value: _ejercicioFiscal.toString(),
                  icon: Icons.event,
                ),
                _buildReadOnlyField(
                  theme: theme,
                  label: 'Moneda Base',
                  value: _moneda,
                  icon: Icons.attach_money,
                ),
                _buildReadOnlyField(
                  theme: theme,
                  label: 'Período',
                  value: '1 de enero - 31 de diciembre',
                  icon: Icons.date_range,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Sección 2: Parámetros de Pago
            _buildSection(
              theme: theme,
              isMobile: isMobile,
              title: 'Parámetros de Pago',
              icon: Icons.settings,
              iconColor: theme.secondary,
              children: [
                _buildReadOnlyField(
                  theme: theme,
                  label: 'Porcentaje DPP por Defecto',
                  value: '${_porcentajeDPPDefecto.toStringAsFixed(2)} %',
                  icon: Icons.percent,
                ),
                _buildReadOnlyField(
                  theme: theme,
                  label: 'Umbral Pago Rápido',
                  value: '$_diasUmbralPagoRapido días',
                  icon: Icons.speed,
                ),
                _buildReadOnlyField(
                  theme: theme,
                  label: 'Umbral Pago Normal',
                  value: '$_diasUmbralPagoNormal días',
                  icon: Icons.schedule,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Sección 3: Notificaciones
            _buildSection(
              theme: theme,
              isMobile: isMobile,
              title: 'Preferencias de Notificaciones',
              icon: Icons.notifications,
              iconColor: theme.warning,
              children: [
                _buildSwitchTile(
                  theme: theme,
                  label: 'Notificar Vencimientos',
                  value: _notificarVencimientos,
                  onChanged: (value) {
                    setState(() => _notificarVencimientos = value);
                    _showDemoMessage(context, theme);
                  },
                  icon: Icons.notification_important,
                ),
                _buildSwitchTile(
                  theme: theme,
                  label: 'Notificar DPP Disponible',
                  value: _notificarDPPDisponible,
                  onChanged: (value) {
                    setState(() => _notificarDPPDisponible = value);
                    _showDemoMessage(context, theme);
                  },
                  icon: Icons.savings,
                ),
                _buildSwitchTile(
                  theme: theme,
                  label: 'Notificar Ahorros Generados',
                  value: _notificarAhorros,
                  onChanged: (value) {
                    setState(() => _notificarAhorros = value);
                    _showDemoMessage(context, theme);
                  },
                  icon: Icons.trending_up,
                ),
                _buildReadOnlyField(
                  theme: theme,
                  label: 'Días de Anticipación para Alertas',
                  value: '$_diasAnticipacionAlerta días',
                  icon: Icons.alarm,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Sección 4: Información del Sistema
            _buildSection(
              theme: theme,
              isMobile: isMobile,
              title: 'Información del Sistema',
              icon: Icons.info_outline,
              iconColor: theme.primary,
              children: [
                _buildReadOnlyField(
                  theme: theme,
                  label: 'Versión',
                  value: '1.0.0 Demo',
                  icon: Icons.code,
                ),
                _buildReadOnlyField(
                  theme: theme,
                  label: 'Última Actualización',
                  value: '4 de febrero del 2026',
                  icon: Icons.update,
                ),
                _buildReadOnlyField(
                  theme: theme,
                  label: 'Modo',
                  value: 'Demo Sin Persistencia',
                  icon: Icons.play_circle_outline,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Nota informativa
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: theme.primary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Esta es una aplicación de demostración. Los cambios no se guardan de forma permanente.',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required AppTheme theme,
    required bool isMobile,
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: theme.textPrimary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Section Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField({
    required AppTheme theme,
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: theme.textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required AppTheme theme,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: theme.textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: theme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: theme.success,
          ),
        ],
      ),
    );
  }

  void _showDemoMessage(BuildContext context, AppTheme theme) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Configuración actualizada (demo temporal)'),
            ),
          ],
        ),
        backgroundColor: theme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
