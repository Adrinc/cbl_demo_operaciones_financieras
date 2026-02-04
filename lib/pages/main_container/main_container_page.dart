import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:facturacion_demo/providers/navigation_provider.dart';
import 'package:facturacion_demo/widgets/sidebar/sidebar.dart';
import 'package:facturacion_demo/widgets/navbar/mobile_navbar.dart';
import 'package:facturacion_demo/widgets/header/page_header.dart';
import 'package:facturacion_demo/helpers/constants.dart';

/// ============================================================================
/// MAIN CONTAINER PAGE
/// ============================================================================
/// Layout principal con Sidebar (desktop) o Navbar (mobile) + Header + Content
/// Responsive: 768px breakpoint
/// ============================================================================
class MainContainerPage extends StatefulWidget {
  final Widget child;

  const MainContainerPage({
    super.key,
    required this.child,
  });

  @override
  State<MainContainerPage> createState() => _MainContainerPageState();
}

class _MainContainerPageState extends State<MainContainerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSidebarCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width <= mobileSize;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: isMobile
          ? Drawer(
              child: MobileNavbar(
                onClose: () {
                  if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            )
          : null,
      body: Row(
        children: [
          // Sidebar (solo desktop)
          if (!isMobile)
            Sidebar(
              isCollapsed: _isSidebarCollapsed,
              onToggleCollapse: () {
                setState(() {
                  _isSidebarCollapsed = !_isSidebarCollapsed;
                });
              },
            ),

          // Content area
          Expanded(
            child: Column(
              children: [
                // Header
                PageHeader(
                  onMenuPressed: isMobile
                      ? () {
                          _scaffoldKey.currentState?.openDrawer();
                        }
                      : null,
                ),

                // Page content
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
