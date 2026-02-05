# Copilot Instructions for Payment Optimization Demo

## ⚠️ REGLA CRÍTICA - NUNCA EJECUTAR EN WINDOWS
**NUNCA ejecutar la aplicación en Windows con `flutter run -d windows`.**
**Esta es una aplicación WEB. Siempre usar Chrome: `flutter run -d chrome`**
**NO usar: `flutter run -d windows`, `flutter run -d macos`, `flutter run -d linux`**

## Project Overview
**Demo de Optimización de Pagos y Operaciones Financieras** is a cross-platform Flutter demo application (Web, Windows, iOS, Android, macOS, Linux) showcasing a professional payment optimization system for enterprise financial operations. Built with Provider state management, responsive design, PlutoGrid tables (desktop), Syncfusion charts, and elegant UI components. **This is a pure demo application with hardcoded data - NO backend connections, NO authentication, NO data persistence.**

**Purpose**: Demonstrate CBLuna's capabilities in creating sophisticated financial dashboards for payment optimization, supplier management, DPP (Descuento por Pronto Pago), Pull/Push payment schemes, and savings analysis for enterprise clients.

**Demo Context**: A multinational company with multiple suppliers seeking to optimize their payment flow and capture early payment benefits during a specific fiscal year (2026).

## Architecture Patterns

### Page Structure & Modularity
- **Page Organization**: Each page has its own folder under `lib/pages/`
- **Page-Specific Widgets**: Each page folder contains its own `widgets/` subfolder for modular components
  - Example: `lib/pages/facturas/widgets/factura_form.dart`, `lib/pages/dashboard/widgets/savings_chart.dart`
  - This keeps pages under 700 lines by extracting complex components
- **Global Widgets**: Shared components (Sidebar, Header, Navbar) live in `lib/widgets/`
- **Folder Structure**:
  - `lib/pages/dashboard/` → `dashboard_page.dart` + `widgets/` subfolder
  - `lib/pages/facturas/` → `facturas_page.dart` + `widgets/` subfolder
  - `lib/widgets/` → Sidebar, Header, Navbar (used across all pages)
- **Navigation**: No transition animations when switching pages via sidebar (use `NoTransitionPage` or `pageBuilder` with zero duration)

### State Management
- **Provider Pattern**: Uses `provider: ^6.1.1` for dependency injection and state management
- **Key Providers** (in `lib/providers/`):
  - `NavigationProvider()`: Handles navigation between pages
  - `ThemeProvider()`: Manages light/dark mode toggle
  - `FacturaProvider()`: Manages invoice CRUD operations (in-memory)
  - `ProveedorProvider()`: Manages supplier data and agreements
  - `PagoProvider()`: Manages payment operations and optimization
  - `ValidacionProvider()`: Manages validations and credit notes
  - Demo-specific providers for temporary UI state only
- **Setup**: Providers are registered in `main()` via `MultiProvider` before app initialization
- Reference: [lib/main.dart](lib/main.dart)

### Routing
- **Router**: `go_router: ^14.8.1` for declarative navigation
- **Key Config**: Single router file at [lib/router/router.dart](lib/router/router.dart)
- **URL Strategy**: Uses `url_strategy: ^0.2.0` to remove `#` from web URLs (configured in `main()`)
- **No Authentication**: Direct access to all pages - no login required
- **No Transition Animations**: Use `NoTransitionPage` or custom `pageBuilder` with `Duration.zero` for instant page switching
- **Navigation Implementation**:
  - **Sidebar (Desktop)**: Uses `context.go(route)` + `navigationProvider.setCurrentRoute(route)` in `SidebarItem`
  - **Mobile Navbar (Drawer)**: Uses `context.go(route)` + `Navigator.of(context).pop()` to close drawer after navigation
  - **CRITICAL**: Always use BOTH `context.go()` for actual navigation AND provider update for UI state sync
- Routes:
  - `/` → Dashboard Financiero (landing page with KPIs and charts)
  - `/facturas` → Gestión de Facturas (PlutoGrid on desktop, Cards on mobile)
  - `/optimizacion` → Optimización de Pagos (core feature)
  - `/simulador` → Simulador de Escenarios (interactive what-if analysis)
  - `/validaciones` → Validación y Control (credit notes, payment status)
  - `/proveedores` → Gestión de Proveedores (supplier agreements)
  - `/reportes` → Reportes y Ahorro (advanced analytics)
  - `/configuracion` → Configuración del Ejercicio (settings)
  - External redirect: Exit button opens `https://cbluna.com/` in same window

### Theme System
- **Corporate Professional Theme**: Enterprise financial software aesthetic
- **Color Palette**:
  - **Light Mode**:
    - Primary: `#1E3A8A` (Deep corporate blue - structure/control)
    - Primary Hover: `#2749A6`
    - Secondary: `#10B981` (Emerald green - benefit/optimization)
    - Secondary Hover: `#059669`
    - Accent: `#3B82F6` (Bright blue)
    - Success: `#10B981` (Green - savings, positive)
    - Warning: `#F59E0B` (Amber - attention needed)
    - Error: `#EF4444` (Red - losses, negative)
    - Background: `#F8FAFC` (Light gray)
    - Surface: `#FFFFFF` (White)
    - Border: `#E5E7EB` (Light border)
    - Text Primary: `#0F172A` (Dark blue-gray)
    - Text Secondary: `#475569` (Medium gray)
    - Text Disabled: `#94A3B8` (Light gray)
  - **Dark Mode**:
    - Primary: `#3B82F6` (Bright blue)
    - Primary Hover: `#60A5FA`
    - Secondary: `#34D399` (Light emerald)
    - Secondary Hover: `#10B981`
    - Accent: `#60A5FA` (Light blue)
    - Success: `#34D399`
    - Warning: `#FBBF24`
    - Error: `#F87171`
    - Background: `#0F172A` (Deep dark blue)
    - Surface: `#1E293B` (Slate)
    - Border: `#334155` (Dark border)
    - Text Primary: `#F1F5F9` (Off-white)
    - Text Secondary: `#94A3B8` (Light gray)
    - Text Disabled: `#64748B` (Muted gray)
- **Color Usage Rules**:
  - **Blue** = Structure, control, navigation, primary actions
  - **Green** = Benefits, savings, optimization, positive values
  - **White/Gray** = Clarity, backgrounds, neutral elements
  - **Amber** = Warnings, pending states, attention needed
  - **Red** = Errors, losses, negative values, rejections
- **Toggle Location**: Theme toggle button ONLY in `PageHeader` (removed from Sidebar and MobileNavbar to avoid duplicates)
- **Theme Connection**: `ThemeProvider` connected to `MaterialApp.router` via `context.watch<ThemeProvider>()` in `main.dart`
- **Storage**: Theme preference saved via `SharedPreferences` under key `__theme_mode__`
- **Font**: Uses `google_fonts: ^6.2.1` with Poppins as primary font
- **Design Elements**: 
  - Rounded borders (8-12px)
  - Elevation/shadows for depth: `BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4))`
  - Bold text for emphasis
  - Zebra striping in tables
  - Status badges with icons

### AI Chatbot Integration (Simulated)
- **Header Button**: Icon button in PageHeader that simulates AI assistant capability
- **Icon**: `Icons.smart_toy_outlined` or similar AI icon
- **Behavior**: Opens a dialog/bottom sheet with informational message
- **Message Content**: "Este sistema puede integrar un asistente de IA para responder preguntas sobre optimización de pagos, análisis de facturas y recomendaciones financieras en tiempo real."
- **Purpose**: Demonstrate potential AI integration without actual implementation
- **Visual**: Subtle pulse animation on icon to draw attention

### Data Layer (Mock/Hardcoded)
- **Mock Data**: All data in [lib/data/mock_data.dart](lib/data/mock_data.dart)
  - **Facturas**: 60-80 sample invoices with varied states
    - 30% already paid (history)
    - 40% pending with DPP available (opportunity)
    - 20% pending without DPP (normal)
    - 10% overdue or with issues (alerts)
  - **Proveedores**: 12-15 fictional professional suppliers
  - **Pagos**: 15-20 executed payments for history
  - **Validaciones**: 20-25 validations (pending/approved/rejected)
  - **Notas de Crédito**: 8-10 credit notes
  - **Exercise Info**: Fiscal year 2026 (January-December)
- **Currency**: USD with explicit symbol (`$ 22,780.00 USD`)
- **Temporal Persistence**: Users can create/edit/delete records during session
- **No Real Persistence**: All changes lost on page refresh/app restart
- **No Backend**: Zero API calls, zero database queries, pure in-memory operations
- **Models**: Simplified models in [lib/models/](lib/models/)

### Data Models

```dart
// Factura (Invoice)
class Factura {
  final String id;
  final String proveedorId;
  final String proveedorNombre;
  final String numeroFactura;
  final double importe;
  final String moneda; // 'USD'
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
}

// Proveedor (Supplier)
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
}

// Pago (Payment)
class Pago {
  final String id;
  final List<String> facturaIds;
  final double montoTotal;
  final double ahorroGenerado;
  final DateTime fechaPropuesta;
  final DateTime? fechaEjecucion;
  final String estado; // 'propuesto' | 'aprobado' | 'ejecutado' | 'rechazado'
  final String tipo; // 'optimizado' | 'normal'
}

// Validacion (Validation)
class Validacion {
  final String id;
  final String tipo; // 'nota_credito' | 'estado_pago' | 'condicion_comercial'
  final String facturaId;
  final String descripcion;
  final String estado; // 'pendiente' | 'aprobado' | 'rechazado'
  final DateTime fecha;
  final String? motivo;
}

// NotaCredito (Credit Note)
class NotaCredito {
  final String id;
  final String facturaId;
  final double monto;
  final String motivo;
  final String estado; // 'pendiente' | 'aplicada' | 'rechazada'
  final DateTime fecha;
}
```

### Sample Supplier Names (Fictional)
```
- Nexus Industries
- Atlas Logistics
- Vertex Solutions
- Meridian Corp
- Pinnacle Supply
- Horizon Tech
- Summit Materials
- Vanguard Services
- Quantum Exports
- Sterling Partners
- Apex Trading
- Nova Distribution
```

## Project Structure

```
lib/
├── main.dart                    # App entry, MultiProvider setup
├── data/                        # Mock/hardcoded data
│   └── mock_data.dart           # Central data hub (all mock data)
├── functions/                   # Pure utility functions
│   ├── date_format.dart         # "3 de enero del 2026" formatting
│   ├── money_format.dart        # Currency formatting "$ 22,780.00 USD"
│   ├── percentage_format.dart   # Percentage formatting "4.00 %"
│   └── ...other utilities
├── helpers/                     # Shared utilities and constants
│   ├── constants.dart           # Breakpoints (mobileSize = 768), routes
│   ├── globals.dart             # Global keys (navigation, snackbar)
│   └── ...other helpers
├── internationalization/        # i18n with intl package (Spanish)
├── models/                      # Dart models
│   ├── factura.dart
│   ├── proveedor.dart
│   ├── pago.dart
│   ├── validacion.dart
│   ├── nota_credito.dart
│   └── models.dart              # Barrel file
├── pages/                       # Full-page widgets
│   ├── main_container/          # Main layout with sidebar/navbar + header
│   │   └── main_container_page.dart
│   ├── dashboard/               # Dashboard Financiero
│   │   ├── dashboard_page.dart
│   │   └── widgets/
│   │       ├── kpi_cards.dart
│   │       ├── savings_chart.dart
│   │       ├── invoices_by_status_chart.dart
│   │       └── alerts_widget.dart
│   ├── facturas/                # Gestión de Facturas
│   │   ├── facturas_page.dart
│   │   └── widgets/
│   │       ├── factura_form.dart
│   │       ├── factura_pluto_grid.dart
│   │       └── factura_mobile_card.dart
│   ├── optimizacion/            # Optimización de Pagos
│   │   ├── optimizacion_page.dart
│   │   └── widgets/
│   │       ├── invoice_selector.dart
│   │       ├── optimization_summary.dart
│   │       └── payment_actions.dart
│   ├── simulador/               # Simulador de Escenarios
│   │   ├── simulador_page.dart
│   │   └── widgets/
│   │       ├── scenario_controls.dart
│   │       └── impact_preview.dart
│   ├── validaciones/            # Validación y Control
│   │   ├── validaciones_page.dart
│   │   └── widgets/
│   │       ├── validacion_pluto_grid.dart
│   │       └── credit_note_form.dart
│   ├── proveedores/             # Gestión de Proveedores
│   │   ├── proveedores_page.dart
│   │   └── widgets/
│   │       ├── proveedor_form.dart
│   │       └── proveedor_pluto_grid.dart
│   ├── reportes/                # Reportes y Ahorro
│   │   ├── reportes_page.dart
│   │   └── widgets/
│   │       ├── savings_by_period_chart.dart
│   │       ├── savings_by_supplier_chart.dart
│   │       └── monthly_comparison_chart.dart
│   ├── configuracion/           # Configuración del Ejercicio
│   │   ├── configuracion_page.dart
│   │   └── widgets/
│   └── page_not_found/          # 404 fallback
│       └── page_not_found.dart
├── providers/                   # ChangeNotifier providers
│   ├── navigation_provider.dart
│   ├── theme_provider.dart
│   ├── factura_provider.dart
│   ├── proveedor_provider.dart
│   ├── pago_provider.dart
│   └── validacion_provider.dart
├── router/                      # GoRouter configuration
│   └── router.dart
├── theme/                       # Theme definitions
│   └── theme.dart               # AppTheme with light/dark modes
└── widgets/                     # Global reusable UI components
    ├── sidebar/
    │   ├── sidebar.dart
    │   └── sidebar_item.dart
    ├── navbar/
    │   └── mobile_navbar.dart
    ├── header/
    │   └── page_header.dart
    ├── chatbot/
    │   └── ai_assistant_dialog.dart
    ├── kpi_card.dart
    ├── status_badge.dart
    └── charts/
        ├── line_chart_widget.dart
        ├── pie_chart_widget.dart
        ├── bar_chart_widget.dart
        └── donut_chart_widget.dart
```

## Critical Dependencies & Integration Points

### UI Libraries
- **pluto_grid: ^8.0.0**: Data tables for desktop with `PlutoLazyPagination` (15 rows per page)
- **syncfusion_flutter_charts: ^latest**: Professional charts for dashboard and reports (line, pie, bar, donut, area)
- **google_fonts: ^6.2.1**: Typography via Poppins font
- **provider: ^6.1.1**: State management
- **go_router: ^14.6.2**: Navigation and routing
- **shared_preferences: ^2.2.2**: Theme mode persistence only
- **url_launcher: ^6.2.0**: For opening https://cbluna.com/ in same window

### Demo-Specific
- **No external services**: All third-party services removed
- **No authentication**: Direct access to all pages
- **Temporal persistence**: CRUD operations work in-memory during session
- **Responsive Design**:
  - Desktop (>768px): PlutoGrid tables, collapsible sidebar
  - Mobile (≤768px): Card layouts, hamburger navbar
- **PlutoGrid Configuration**:
  - Use `PlutoLazyPagination` with `pageSizeToMove: 15` for pagination
  - Pass `rows: []` to PlutoGrid (empty) - data loaded via `fetch` callback
  - Add `ValueKey` with `themeMode` to force rebuild on theme change
- **Date Format**: Spanish locale
  - **Full DateTime**: "3 de enero del 2026 a las 13:30"
  - **Date only**: "3 de enero del 2026"
- **Money Format**: `$ 22,780.00 USD` (explicit currency symbol and code)
- **Percentage Format**: `4.00 %` (with space before %)
- **Exit Button**: "Salir de la Demo" - Redirects to https://cbluna.com/ in same window

## Important Conventions

### Naming & Organization
- **Files**: `snake_case.dart` for files, PascalCase for classes, camelCase for variables
- **Imports**: Group as (1) dart:, (2) package:flutter, (3) package:third_party, (4) relative imports
- **Constants**: SCREAMING_SNAKE_CASE for constants

### State Updates
- **Never mutate**: Always create new instances or use `notifyListeners()` in ChangeNotifiers
- **Build context usage**: Pass context when needed for theme/localization, avoid storing globally
- **Disposal**: Remember to dispose listeners/controllers in `dispose()` methods

### Error Handling
- **No network errors**: No API calls to fail
- **UI feedback**: Use SnackBar for user messages
- **Validation**: Client-side only (email format, required fields, numeric validation)

## Build & Deployment

### Commands
```bash
# Clean & prepare
flutter clean && flutter pub get

# Windows debug/release
flutter run -d windows
flutter build windows --release

# Web deployment
flutter build web --release
# Output: build/web/

# Mobile builds
flutter build apk --release      # Android
flutter build ios --release      # iOS
```

## Pages Overview

### 1. Dashboard Financiero (`/`)
**Purpose**: Executive overview of financial operations

**KPIs**:
| KPI | Icon | Color |
|-----|------|-------|
| Total Facturas del Ejercicio | `Icons.receipt_long` | Primary |
| Ahorro Generado | `Icons.savings` | Success (green) |
| Pagos Ejecutados | `Icons.check_circle` | Success |
| Pagos Pendientes | `Icons.pending` | Warning |
| Ahorro Perdido (Oportunidad) | `Icons.trending_down` | Error |

**Charts** (Syncfusion):
- Line chart: Savings trend over time
- Donut chart: Invoices by status
- Bar chart: Savings vs losses by month

**Widgets**:
- Alert widget: Invoices expiring DPP soon (<7 days)
- Quick summary of active fiscal year

### 2. Gestión de Facturas (`/facturas`)
**Purpose**: Primary input management - invoice CRUD

**Table Columns** (PlutoGrid):
| Column | Description |
|--------|-------------|
| ID ARXIS | Internal ID |
| Proveedor | Supplier name with avatar |
| Factura | Invoice number |
| Importe | Amount with currency |
| Días Aplicar Pago | Days to payment |
| %DPP | Early payment discount % |
| $DPP | Discount amount |
| $ Pronto Pago | Final amount with DPP |
| Esquema | Pull/Push badge |
| Estado | Status badge |
| Acciones | Edit/Delete/View |

**Features**:
- Create new invoice
- Edit existing
- Delete (with confirmation)
- Filter by status, supplier, scheme
- Search by invoice number
- "Opportunity" column showing potential savings

### 3. Optimización de Pagos (`/optimizacion`)
**Purpose**: Core service feature - payment optimization

**Components**:
- Invoice selector with checkboxes
- Real-time savings counter (animated)
- Comparison view: Normal payment vs Optimized payment
- Apply Pull/Push/DPP options
- Summary panel:
  - Selected invoices count
  - Total amount
  - Total savings
  - Final payment amount
- Action buttons:
  - "Proponer Pago" (primary)
  - "Ejecutar Pago" (demo - shows success message)

### 4. Simulador de Escenarios (`/simulador`)
**Purpose**: Interactive what-if analysis (wow factor)

**Controls**:
- Slider: DPP percentage (0-10%)
- Slider: Payment days (1-90)
- Dropdown: Select suppliers
- Toggle: Pull/Push scheme
- Date picker: Simulation date

**Impact Preview**:
- Real-time calculation as user moves sliders
- Before/After comparison
- Animated savings counter
- Visual graph of impact

### 5. Validación y Control (`/validaciones`)
**Purpose**: Financial control and verification

**Tabs**:
1. Notas de Crédito
2. Estados de Pago
3. Condiciones Comerciales

**Status Badges**:
- Pendiente (amber)
- Aprobado (green)
- Rechazado (red)

**Actions**:
- Approve/Reject validations (simulated)
- View details
- Add comments

### 6. Gestión de Proveedores (`/proveedores`)
**Purpose**: Supplier agreement management

**Table Columns**:
| Column | Description |
|--------|-------------|
| Proveedor | Name with avatar |
| RFC | Tax ID |
| Esquema | Pull/Push active |
| Días Pago | Standard payment days |
| DPP Permitido | Yes/No badge |
| % DPP Base | Base discount % |
| Contacto | Contact person |
| Estado | Active/Inactive |
| Acciones | Edit/View |

**Features**:
- View supplier details
- Edit agreement terms (simulated)
- Filter by scheme, DPP status

### 7. Reportes y Ahorro (`/reportes`)
**Purpose**: Business value demonstration

**Charts** (Syncfusion):
- Savings by period (line/area chart)
- Savings by supplier (horizontal bar)
- Monthly comparison (grouped bar)
- Opportunity loss analysis (donut)

**Filters**:
- Date range picker
- Supplier multiselect
- Scheme filter

**Export** (simulated):
- "Exportar PDF" button (shows success message)
- "Exportar Excel" button (shows success message)

### 8. Configuración (`/configuracion`)
**Purpose**: Fiscal year and system parameters

**Settings** (read-only or simulated edit):
- Active fiscal year: 2026
- Currency: USD
- Default DPP percentage
- Payment day thresholds
- Notification preferences (visual only)

## PlutoGrid Design Standards

### Container & Borders
```dart
Container(
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
  child: ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: PlutoGrid(...),
  ),
)
```

### Column Auto-Sizing
```dart
configuration: PlutoGridConfiguration(
  columnSize: const PlutoGridColumnSizeConfig(
    autoSizeMode: PlutoAutoSizeMode.scale,
    resizeMode: PlutoResizeMode.normal,
  ),
)
```

### Money Column Renderer
```dart
renderer: (ctx) {
  final amount = ctx.cell.value as double;
  final isPositive = amount >= 0;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: isPositive 
          ? theme.success.withOpacity(0.1) 
          : theme.error.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      '\$ ${amount.toStringAsFixed(2)} USD',
      style: TextStyle(
        color: isPositive ? theme.success : theme.error,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
```

### Scheme Badge Renderer (Pull/Push)
```dart
renderer: (ctx) {
  final scheme = ctx.cell.value as String;
  final isPull = scheme.toLowerCase() == 'pull';
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: isPull 
          ? theme.secondary.withOpacity(0.15) 
          : theme.primary.withOpacity(0.15),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isPull ? theme.secondary : theme.primary,
        width: 1,
      ),
    ),
    child: Text(
      isPull ? 'PULL NC-Pago' : 'PUSH NC-Pago',
      style: TextStyle(
        color: isPull ? theme.secondary : theme.primary,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    ),
  );
}
```

## Quick Links
- **Demo Purpose**: Showcase CBLuna's payment optimization capabilities
- **Business Context**: Enterprise financial operations and supplier management
- **Design System**: Professional blue/green palette with enterprise aesthetic
- **Key Features**: DPP optimization, Pull/Push schemes, savings analysis, supplier management
- **Target Audience**: CFOs, Finance Directors, Treasury Managers evaluating payment solutions
- **Main Site**: https://cbluna.com/ (exit button destination)

---

## 🚀 PLAN DE ACCIÓN POR FASES

### FASE 1: Fundamentos y Configuración Base
**Objetivo**: Establecer la estructura del proyecto y configuración inicial

| Paso | Descripción | Archivos |
|------|-------------|----------|
| 1.1 | Actualizar `pubspec.yaml` con dependencias correctas | `pubspec.yaml` |
| 1.2 | Crear sistema de temas (Light/Dark) | `lib/theme/theme.dart` |
| 1.3 | Crear constantes y helpers | `lib/helpers/constants.dart`, `globals.dart` |
| 1.4 | Crear funciones utilitarias | `lib/functions/` (date, money, percentage) |
| 1.5 | Crear modelos de datos | `lib/models/` (todos los modelos) |
| 1.6 | Crear mock data completo | `lib/data/mock_data.dart` |

### FASE 2: Providers y Estado
**Objetivo**: Implementar la gestión de estado

| Paso | Descripción | Archivos |
|------|-------------|----------|
| 2.1 | NavigationProvider | `lib/providers/navigation_provider.dart` |
| 2.2 | ThemeProvider (con persistencia) | `lib/providers/theme_provider.dart` |
| 2.3 | FacturaProvider (CRUD) | `lib/providers/factura_provider.dart` |
| 2.4 | ProveedorProvider | `lib/providers/proveedor_provider.dart` |
| 2.5 | PagoProvider | `lib/providers/pago_provider.dart` |
| 2.6 | ValidacionProvider | `lib/providers/validacion_provider.dart` |

### FASE 3: Infraestructura de UI
**Objetivo**: Crear componentes globales reutilizables

| Paso | Descripción | Archivos |
|------|-------------|----------|
| 3.1 | Router con todas las rutas | `lib/router/router.dart` |
| 3.2 | MainContainer (layout principal) | `lib/pages/main_container/` |
| 3.3 | Sidebar (desktop, colapsable) | `lib/widgets/sidebar/` |
| 3.4 | MobileNavbar (hamburger menu) | `lib/widgets/navbar/` |
| 3.5 | PageHeader (con toggle tema + chatbot) | `lib/widgets/header/` |
| 3.6 | AI Assistant Dialog (simulado) | `lib/widgets/chatbot/` |
| 3.7 | KPI Card widget | `lib/widgets/kpi_card.dart` |
| 3.8 | Status Badge widget | `lib/widgets/status_badge.dart` |
| 3.9 | Main.dart con MultiProvider | `lib/main.dart` |

### FASE 4: Dashboard Financiero
**Objetivo**: Página de inicio con KPIs y gráficos

| Paso | Descripción | Archivos |
|------|-------------|----------|
| 4.1 | Dashboard page base | `lib/pages/dashboard/dashboard_page.dart` |
| 4.2 | KPI Cards section | `lib/pages/dashboard/widgets/kpi_cards.dart` |
| 4.3 | Savings chart (Syncfusion line) | `lib/pages/dashboard/widgets/savings_chart.dart` |
| 4.4 | Invoices by status (donut) | `lib/pages/dashboard/widgets/invoices_status_chart.dart` |
| 4.5 | Alerts widget | `lib/pages/dashboard/widgets/alerts_widget.dart` |

### FASE 5: Gestión de Facturas
**Objetivo**: CRUD completo de facturas

| Paso | Descripción | Archivos |
|------|-------------|----------|
| 5.1 | Facturas page base | `lib/pages/facturas/facturas_page.dart` |
| 5.2 | PlutoGrid table (desktop) | `lib/pages/facturas/widgets/factura_pluto_grid.dart` |
| 5.3 | Mobile cards | `lib/pages/facturas/widgets/factura_mobile_card.dart` |
| 5.4 | Factura form (create/edit) | `lib/pages/facturas/widgets/factura_form.dart` |

### FASE 6: Optimización de Pagos
**Objetivo**: Core feature - selección y optimización

| Paso | Descripción | Archivos |
|------|-------------|----------|
| 6.1 | Optimización page base | `lib/pages/optimizacion/optimizacion_page.dart` |
| 6.2 | Invoice selector | `lib/pages/optimizacion/widgets/invoice_selector.dart` |
| 6.3 | Optimization summary | `lib/pages/optimizacion/widgets/optimization_summary.dart` |
| 6.4 | Payment actions | `lib/pages/optimizacion/widgets/payment_actions.dart` |

### FASE 7: Simulador de Escenarios
**Objetivo**: Feature interactivo "wow factor"

| Paso | Descripción | Archivos |
|------|-------------|----------|
| 7.1 | Simulador page base | `lib/pages/simulador/simulador_page.dart` |
| 7.2 | Scenario controls (sliders) | `lib/pages/simulador/widgets/scenario_controls.dart` |
| 7.3 | Impact preview (real-time) | `lib/pages/simulador/widgets/impact_preview.dart` |

### FASE 8: Validaciones y Control
**Objetivo**: Gestión de validaciones y notas de crédito

| Paso | Descripción | Archivos |
|------|-------------|----------|
| 8.1 | Validaciones page base | `lib/pages/validaciones/validaciones_page.dart` |
| 8.2 | Validacion PlutoGrid | `lib/pages/validaciones/widgets/validacion_pluto_grid.dart` |
| 8.3 | Credit note form | `lib/pages/validaciones/widgets/credit_note_form.dart` |

### FASE 9: Gestión de Proveedores
**Objetivo**: CRUD de proveedores y acuerdos

| Paso | Descripción | Archivos |
|------|-------------|----------|
| 9.1 | Proveedores page base | `lib/pages/proveedores/proveedores_page.dart` |
| 9.2 | Proveedor PlutoGrid | `lib/pages/proveedores/widgets/proveedor_pluto_grid.dart` |
| 9.3 | Proveedor form | `lib/pages/proveedores/widgets/proveedor_form.dart` |

### FASE 10: Reportes y Ahorro
**Objetivo**: Analytics y visualización de valor

| Paso | Descripción | Archivos |
|------|-------------|----------|
| 10.1 | Reportes page base | `lib/pages/reportes/reportes_page.dart` |
| 10.2 | Savings by period chart | `lib/pages/reportes/widgets/savings_by_period_chart.dart` |
| 10.3 | Savings by supplier chart | `lib/pages/reportes/widgets/savings_by_supplier_chart.dart` |
| 10.4 | Monthly comparison chart | `lib/pages/reportes/widgets/monthly_comparison_chart.dart` |

### FASE 11: Configuración
**Objetivo**: Parámetros del ejercicio fiscal

| Paso | Descripción | Archivos |
|------|-------------|----------|
| 11.1 | Configuración page | `lib/pages/configuracion/configuracion_page.dart` |

### FASE 12: Pulido Final
**Objetivo**: Refinamiento y testing

| Paso | Descripción |
|------|-------------|
| 12.1 | Page Not Found (404) |
| 12.2 | Responsive testing (desktop/mobile) |
| 12.3 | Theme toggle testing (light/dark) |
| 12.4 | CRUD operations testing |
| 12.5 | Build web y Windows |

---

## Resumen de Fases

| Fase | Nombre | Archivos Aprox. | Prioridad |
|------|--------|-----------------|-----------|
| 1 | Fundamentos | 10-12 | 🔴 Crítica |
| 2 | Providers | 6 | 🔴 Crítica |
| 3 | UI Infrastructure | 10-12 | 🔴 Crítica |
| 4 | Dashboard | 5 | 🟠 Alta |
| 5 | Facturas | 4 | 🟠 Alta |
| 6 | Optimización | 4 | 🟠 Alta |
| 7 | Simulador | 3 | 🟡 Media |
| 8 | Validaciones | 3 | 🟡 Media |
| 9 | Proveedores | 3 | 🟡 Media |
| 10 | Reportes | 4 | 🟡 Media |
| 11 | Configuración | 1 | 🟢 Baja |
| 12 | Pulido | - | 🟢 Baja |

**Total estimado**: ~55-60 archivos nuevos/modificados
