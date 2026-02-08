import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facturacion_demo/providers/validacion_provider.dart';
import 'package:facturacion_demo/models/models.dart';
import 'package:facturacion_demo/theme/theme.dart';
import 'package:facturacion_demo/pages/validaciones/widgets/validacion_pluto_grid.dart';
import 'package:facturacion_demo/pages/validaciones/widgets/validacion_mobile_cards.dart';
import 'package:facturacion_demo/pages/validaciones/widgets/credit_note_form.dart';

/// ============================================================================
/// VALIDACIONES Y CONTROL PAGE
/// ============================================================================
/// Gestión de validaciones, notas de crédito y control de pagos
/// Incluye tabs para diferentes tipos de validaciones
/// ============================================================================
class ValidacionesPage extends StatefulWidget {
  const ValidacionesPage({super.key});

  @override
  State<ValidacionesPage> createState() => _ValidacionesPageState();
}

class _ValidacionesPageState extends State<ValidacionesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTab = 0;
  bool _showInfoMessage = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTab = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final validacionProvider = context.watch<ValidacionProvider>();
    final isMobile = MediaQuery.of(context).size.width < 768;

    // Filtrar validaciones por tipo según tab
    final List<String> tipos = [
      'nota_credito',
      'estado_pago',
      'condicion_comercial',
    ];
    final validacionesFiltradas = _currentTab < tipos.length
        ? validacionProvider.validaciones
            .where((v) => v.tipo == tipos[_currentTab])
            .toList()
        : validacionProvider.validaciones;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            decoration: BoxDecoration(
              color: theme.surface,
              border: Border(
                bottom: BorderSide(color: theme.border, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.warning,
                            theme.warning.withOpacity(0.7)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.verified_user,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Validación y Control',
                            style: TextStyle(
                              fontSize: isMobile ? 24 : 32,
                              fontWeight: FontWeight.bold,
                              color: theme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Aprueba o rechaza notas de crédito, verifica estados de pago y valida condiciones comerciales antes de ejecutar pagos',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isMobile)
                      ElevatedButton.icon(
                        onPressed: () => _showCreditNoteForm(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Nueva Nota de Crédito'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.success,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                // Información contextual
                if (_showInfoMessage)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.accent.withOpacity(0.1),
                          theme.secondary.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.accent.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.accent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.help_outline,
                            color: theme.accent,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '¿Para qué sirve esta pantalla?',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: theme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Antes de ejecutar pagos, es necesario verificar ajustes pendientes: notas de crédito (devoluciones/descuentos), estados de pago (confirmaciones bancarias) y condiciones comerciales (cambios en acuerdos). Aquí apruebas o rechazas estas validaciones.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              setState(() => _showInfoMessage = false),
                          icon: Icon(Icons.close, color: theme.textSecondary),
                          tooltip: 'Ocultar mensaje',
                          iconSize: 20,
                        ),
                      ],
                    ),
                  ),
                if (_showInfoMessage) const SizedBox(height: 20),

                // Tabs
                Container(
                  decoration: BoxDecoration(
                    color: theme.primaryBackground,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: theme.border),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: theme.primary,
                    indicatorWeight: 3,
                    labelColor: theme.primary,
                    unselectedLabelColor: theme.textSecondary,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    tabs: [
                      Tab(
                        icon: const Icon(Icons.receipt_long),
                        text: isMobile ? 'NC' : 'Notas de Crédito',
                      ),
                      Tab(
                        icon: const Icon(Icons.payment),
                        text: isMobile ? 'Pagos' : 'Estados de Pago',
                      ),
                      Tab(
                        icon: const Icon(Icons.handshake),
                        text: isMobile ? 'Cond.' : 'Condiciones Comerciales',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Notas de Crédito
                _buildTabContent(
                  context,
                  validacionesFiltradas,
                  'nota_credito',
                  theme,
                  isMobile,
                ),
                // Tab 2: Estados de Pago
                _buildTabContent(
                  context,
                  validacionesFiltradas,
                  'estado_pago',
                  theme,
                  isMobile,
                ),
                // Tab 3: Condiciones Comerciales
                _buildTabContent(
                  context,
                  validacionesFiltradas,
                  'condicion_comercial',
                  theme,
                  isMobile,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: isMobile
          ? FloatingActionButton.extended(
              onPressed: () => _showCreditNoteForm(context),
              icon: const Icon(Icons.add),
              label: const Text('Nueva NC'),
              backgroundColor: theme.success,
            )
          : null,
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    List<Validacion> validaciones,
    String tipo,
    AppTheme theme,
    bool isMobile,
  ) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats cards
          _buildStatsCards(validaciones, theme, isMobile),
          const SizedBox(height: 24),

          // Table or Cards
          Expanded(
            child: isMobile
                ? ValidacionMobileCards(
                    validaciones: validaciones,
                    tipo: tipo,
                  )
                : ValidacionPlutoGrid(
                    validaciones: validaciones,
                    tipo: tipo,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(
    List<dynamic> validaciones,
    AppTheme theme,
    bool isMobile,
  ) {
    final pendientes =
        validaciones.where((v) => v.estado == 'pendiente').length;
    final aprobadas = validaciones.where((v) => v.estado == 'aprobado').length;
    final rechazadas =
        validaciones.where((v) => v.estado == 'rechazado').length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.pending,
            label: 'Pendientes',
            value: '$pendientes',
            color: theme.warning,
            theme: theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.check_circle,
            label: 'Aprobadas',
            value: '$aprobadas',
            color: theme.success,
            theme: theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.cancel,
            label: 'Rechazadas',
            value: '$rechazadas',
            color: theme.error,
            theme: theme,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required AppTheme theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: theme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showCreditNoteForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => const CreditNoteFormDialog(),
    );
  }
}
