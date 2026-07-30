import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sasheco_dashboard_web/core/theme/app_colors.dart';
import 'package:sasheco_dashboard_web/core/widgets/app_background.dart';

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  bool isSidebarCollapsed = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void toggleSidebar() {
    setState(() {
      isSidebarCollapsed = !isSidebarCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final bool isDesktop = MediaQuery.of(context).size.width > 1024;

    return AppBackground(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        drawer: isDesktop
            ? null
            : Theme(
                data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
                child: Drawer(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: _buildSidebar(false, location), // Mobile sidebar is never collapsed (shows text)
                ),
              ),
        body: Row(
          children: [
            // Sidebar for Desktop
            if (isDesktop)
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: isSidebarCollapsed ? 80.0 : 280.0,
                child: _buildSidebar(isSidebarCollapsed, location),
              ),
            // Main Content Area
            Expanded(
              child: Column(
                children: [
                  // Top App Bar with Glassmorphism
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                      child: Container(
                        height: 80,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.45), // Glass topbar
                          border: Border(
                            bottom: BorderSide(color: Colors.white.withOpacity(0.3)),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Menu toggle button
                            IconButton(
                              icon: const Icon(Icons.menu, color: AppColors.textSecondary),
                              onPressed: () {
                                if (isDesktop) {
                                  toggleSidebar();
                                } else {
                                  _scaffoldKey.currentState?.openDrawer();
                                }
                              },
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.notifications_none, color: AppColors.textSecondary),
                              onPressed: () {},
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.help_outline, color: AppColors.textSecondary),
                              onPressed: () {},
                            ),
                            const SizedBox(width: 24),
                            const CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person, size: 20, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Content
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(isDesktop ? 40.0 : 24.0),
                      child: widget.child,
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

  Widget _buildSidebar(bool isCollapsed, String location) {
    final bool showText = !isCollapsed;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.9), // Glass sidebar
            border: Border(
              right: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 32),
              // Logo
              Row(
                mainAxisAlignment: showText ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: [
                  if (showText) const SizedBox(width: 24),
                  Image.asset('assets/images/logo.png', height: 48),
                  if (showText) ...[
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SASHECO',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Enterprise Hub',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Colors.white70,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  ]
                ],
              ),
              const SizedBox(height: 48),
              // Navigation Links
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 8 : 16),
                  children: [
                    _buildNavItem(context, 'Dashboard', Icons.dashboard, '/dashboard', location, showText),
                    _buildNavItem(context, 'Create User', Icons.person_add, '/create-user', location, showText),
                    _buildNavItem(context, 'Global Permissions', Icons.admin_panel_settings, '/global-permissions', location, showText),
                    _buildNavItem(context, 'Engineering', Icons.engineering, '/engineering', location, showText),
                    _buildNavItem(context, 'Secretary', Icons.edit_document, '/secretary', location, showText),
                    _buildNavItem(context, 'Financial', Icons.attach_money, '/financial', location, showText),
                    _buildNavItem(context, 'Contract Approval', Icons.gavel, '/approval', location, showText),
                    _buildNavItem(context, 'Vendor Data', Icons.store, '/vendor', location, showText),
                    _buildNavItem(context, 'Site Data', Icons.location_on, '/site', location, showText),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, String title, IconData icon, String route, String currentLocation, bool showText) {
    final bool isActive = currentLocation == route;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isActive && showText
            ? const Border(left: BorderSide(color: AppColors.accent, width: 4))
            : null,
      ),
      child: Tooltip(
        message: showText ? '' : title,
        child: ListTile(
          leading: Icon(icon, color: isActive ? AppColors.accent : Colors.white70),
          title: showText
              ? Text(
                  title,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.white70,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          contentPadding: EdgeInsets.symmetric(horizontal: showText ? 16.0 : 0.0),
          horizontalTitleGap: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onTap: () {
            context.go(route);
            if (MediaQuery.of(context).size.width <= 1024) {
              Navigator.of(context).pop(); // Close drawer on mobile
            }
          },
        ),
      ),
    );
  }
}
